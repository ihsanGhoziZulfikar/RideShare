import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_share/constant.dart';
import 'package:ride_share/pages/chat_page.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final loc.Location locationController = loc.Location();
  late GoogleMapController _mapController;
  StreamSubscription<QuerySnapshot>? _requestSubscription;

  static const LatLng sourceLocation =
      LatLng(-6.862417460687757, 107.59372402873836);
  static const LatLng destination =
      LatLng(-6.889144835635328, 107.5959113186077);

  List<LatLng> polylineCoordinates = [];
  bool _locationPermissionGranted = false;

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  final Set<Marker> _markers = {};

  String _selectedMarkerTitle = '';
  String _selectedMarkerSubtitle = '';
  String? _selectedMarkerEmail;
  String? _selectedMarkerId;
  bool _isMarkerSelected = false;

  String _passengerName = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _listenForRequests();
  }

  @override
  void dispose() {
    _requestSubscription?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          ));
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await locationController.requestPermission();
    if (status == loc.PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      fetchLocationUpdates();
    } else {
      print('Location permission denied');
    }
  }

  Future<void> _listenForRequests() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    _requestSubscription = FirebaseFirestore.instance
        .collection('Requests')
        .where('driverId', isEqualTo: currentUser?.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((querySnapshot) {
      for (var docChange in querySnapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          var request = docChange.doc.data() as Map<String, dynamic>;
          request['id'] = docChange.doc.id;

          print('New request from passenger: ${request['passengerId']}');
          _showNewRequestDialog(request);
        }
      }
    });
  }

  Future<String> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Unknown';
      }
    } catch (e) {
      print('Error occurred while fetching city name: $e');
    }
    return 'Unknown';
  }

  void _showNewRequestDialog(Map<String, dynamic> request) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(request['passengerId'])
        .get()
        .then((userData) async {
      if (userData.exists) {
        String passengerUsername = userData['username'];
        double passengerLat =
            double.tryParse(userData['lat'].toString()) ?? 0.0;
        double passengerLng =
            double.tryParse(userData['lng'].toString()) ?? 0.0;
        String cityName = await getCityName(passengerLat, passengerLng);

        print('Passenger data: Username: $passengerUsername');

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New Ride Request'),
              content: SingleChildScrollView(
                child: Text(
                    'Kamu memiliki permintaan Rideshare baru dari penumpang $passengerUsername. Location: $cityName'),
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    try {
                      final docSnapshot = await FirebaseFirestore.instance
                          .collection('Requests')
                          .doc(request['id'])
                          .get();
                      if (docSnapshot.exists) {
                        await FirebaseFirestore.instance
                            .collection('Requests')
                            .doc(request['id'])
                            .update({'status': 'seen'});

                        setState(() {
                          _markers.add(
                            Marker(
                              markerId:
                                  MarkerId('guest_${request['passengerId']}'),
                              position: LatLng(passengerLat, passengerLng),
                              infoWindow: InfoWindow(
                                title: "Guest: $passengerUsername",
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue),
                              onTap: () {
                                setState(() {
                                  _selectedMarkerTitle = passengerUsername;
                                  _selectedMarkerSubtitle =
                                      userData['destination'] ?? 'Unknown';
                                  _selectedMarkerEmail = userData['email'];
                                  _selectedMarkerId = request['passengerId'];
                                  _isMarkerSelected = true;
                                  _passengerName = userData['username'];
                                });
                              },
                            ),
                          );
                        });
                      } else {
                        print('Document not found');
                      }
                    } catch (e) {
                      print('Error updating document: $e');
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('User data not found for passengerId: ${request['passengerId']}');
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  Future<void> _searchDestination() async {
    String query = _searchController.text;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng destinationLatLng =
            LatLng(location.latitude, location.longitude);

        String cityName =
            await getCityName(location.latitude, location.longitude);

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          try {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .update({
              'destination': cityName,
            });
            print('Destination updated in Firestore: $cityName');
          } catch (e) {
            print('Error updating destination in Firestore: $e');
          }
        }

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('destination'),
              position: destinationLatLng,
              infoWindow: InfoWindow(title: 'Destination'),
            ),
          );
          _mapController
              .animateCamera(CameraUpdate.newLatLng(destinationLatLng));
        });
      }
    } catch (e) {
      print('Error occurred while searching for destination: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: currentPosition != null
                        ? CameraPosition(
                            target: currentPosition!,
                            zoom: 14.5,
                          )
                        : const CameraPosition(
                            target: sourceLocation,
                            zoom: 14.5,
                          ),
                    markers: _markers.union({
                      if (currentPosition != null)
                        Marker(
                          markerId: const MarkerId("current"),
                          position: currentPosition!,
                        ),
                      Marker(
                        markerId: const MarkerId("source"),
                        position: sourceLocation,
                      ),
                      Marker(
                        markerId: const MarkerId("destination"),
                        position: destination,
                      ),
                    }),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: const Color(0xFF7B61FF),
                        width: 6,
                      ),
                    },
                  ),
            Positioned(
              right: 0,
              left: 0,
              top: 10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukan destinasi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Color(0xff0077B6),
                        ),
                        onPressed: _searchDestination,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide
                            .none, // Optional: Remove the border if you want to use the container's decoration
                      ),
                    ),
                    onSubmitted: (value) => _searchDestination(),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width,
                height: _isMarkerSelected
                    ? MediaQuery.of(context).size.height / 3.2
                    : 0,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                child: _isMarkerSelected
                    ? Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                            ),
                            title: Text(
                              _selectedMarkerTitle,
                              style: TextStyle(
                                  fontFamily: 'Kantumruy',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.directions),
                                SizedBox(width: 4),
                                Text(
                                  _selectedMarkerSubtitle,
                                  style: TextStyle(
                                    fontFamily: 'Kantumruy',
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.message),
                                  onPressed: () {
                                    if (_selectedMarkerEmail != null &&
                                        _selectedMarkerId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            receiverEmail:
                                                _selectedMarkerEmail!,
                                            receiverId: _selectedMarkerId!,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Divider(
                              thickness: 0.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontFamily: 'Kantumruy',
                                  ),
                                ),
                                subtitle: Text(
                                  _selectedMarkerEmail ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Kantumruy',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Notification'),
                                      content: Text(
                                          'Sekarang $_passengerName menjadi penumpang mu.'),
                                      actions: [
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _isMarkerSelected = false;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 119, 182, 0.25),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'Terima Kuy',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff0077B6)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen(
      (loc.LocationData currentLocation) async {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          if (mounted) {
            setState(() {
              currentPosition = LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              );
            });
          }

          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            try {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.uid)
                  .update({
                'lat': currentLocation.latitude,
                'lng': currentLocation.longitude,
              });
              print(
                  'Location updated in Firestore: (${currentLocation.latitude}, ${currentLocation.longitude})');
            } catch (e) {
              print('Error updating location in Firestore: $e');
            }
          }
        }
      },
    );
  }
}
