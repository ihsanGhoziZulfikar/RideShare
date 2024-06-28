import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_share/constant.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location locationController = Location();
  late GoogleMapController _mapController;
  StreamSubscription<QuerySnapshot>? _requestSubscription;

  static const LatLng sourceLocation = LatLng(-6.862417460687757, 107.59372402873836);
  static const LatLng destination = LatLng(-6.889144835635328, 107.5959113186077);

  List<LatLng> polylineCoordinates = [];
  bool _locationPermissionGranted = false;

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _listenForRequests();
  }

  @override
  void dispose() {
    _requestSubscription?.cancel();
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
    if (status == PermissionStatus.granted) {
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

    _requestSubscription = FirebaseFirestore.instance.collection('Requests').where('driverId', isEqualTo: currentUser?.uid).where('status', isEqualTo: 'pending').snapshots().listen((querySnapshot) {
      for (var docChange in querySnapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          var request = docChange.doc.data() as Map<String, dynamic>;
          request['id'] = docChange.doc.id; // Simpan ID dokumen dalam request

          print('New request from passenger: ${request['passengerId']}');
          _showNewRequestDialog(request);
        }
      }
    });
  }

  void _showNewRequestDialog(Map<String, dynamic> request) {
    FirebaseFirestore.instance.collection('Users').doc(request['passengerId']).get().then((userData) {
      if (userData.exists) {
        String passengerUsername = userData['username'];
        double passengerLat = double.tryParse(userData['lat'].toString()) ?? 0.0;
        double passengerLng = double.tryParse(userData['lng'].toString()) ?? 0.0;

        print('Passenger data: Username: $passengerUsername, Lat: $passengerLat, Lng: $passengerLng');

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New Ride Request'),
              content: SingleChildScrollView(
                child: Text('You have a new ride request from passenger $passengerUsername. Location: ($passengerLat, $passengerLng)'),
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    try {
                      // Cek apakah dokumen ada sebelum memperbarui
                      final docSnapshot = await FirebaseFirestore.instance.collection('Requests').doc(request['id']).get();
                      if (docSnapshot.exists) {
                        await FirebaseFirestore.instance.collection('Requests').doc(request['id']).update({
                          'status': 'seen'
                        });

                        // Add guest marker
                        setState(() {
                          _markers.add(
                            Marker(
                              markerId: MarkerId('guest_${request['passengerId']}'),
                              position: LatLng(passengerLat, passengerLng),
                              infoWindow: InfoWindow(
                                title: "Guest: $passengerUsername",
                              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track nebeng'),
      ),
      body: currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: sourceLocation,
                zoom: 14.5,
              ),
              markers: _markers.union({
                Marker(
                  markerId: const MarkerId("current"),
                  position: currentPosition!,
                ),
                // Marker(
                //   markerId: const MarkerId("source"),
                //   position: sourceLocation,
                // ),
                // Marker(
                //   markerId: const MarkerId("destination"),
                //   position: destination,
                // ),
              }),
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
          });
        }
      }
    });
  }
}
