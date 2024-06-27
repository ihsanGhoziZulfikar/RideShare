import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class DriverTrackingPage extends StatefulWidget {
  DriverTrackingPage({Key? key}) : super(key: key);

  @override
  _DriverTrackingPageState createState() => _DriverTrackingPageState();
}

class _DriverTrackingPageState extends State<DriverTrackingPage> {
  late GoogleMapController _mapController;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-6.917464, 107.619123), // Bandung, West Java, Indonesia
    zoom: 8.0,
  );

  final LatLng _startPoint = LatLng(-6.917464, 107.619123);
  final LatLng _endPoint = LatLng(-6.836283, 108.227014);

  final Set<Polyline> _polylines = {
    Polyline(
      polylineId: PolylineId('route1'),
      points: [
        LatLng(-6.917464, 107.619123),
        LatLng(-6.836283, 108.227014),
      ],
      color: Colors.blue,
      width: 5,
    ),
  };

  final Set<Marker> _markers = {};

  final TextEditingController _searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchAndNavigate() async {
    String address = _searchController.text;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng target = LatLng(location.latitude, location.longitude);

        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 15),
        ));

        setState(() {
          _markers.clear();
          _markers.add(Marker(
            markerId: MarkerId(target.toString()),
            position: target,
            infoWindow: InfoWindow(title: address),
          ));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter location',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchAndNavigate,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: false,
            polylines: _polylines,
            markers: _markers,
            onTap: (coordinate) {
              _mapController.animateCamera(CameraUpdate.newLatLng(coordinate));
              setState(() {});
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.2,
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
                  )
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ),
                    title: Text('Marqueze'),
                    subtitle: Text('Adik Marquez'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            // Handle message button press
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            // Handle call button press
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        leading: Image.network('https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', width: 50),
                        title: Text('E 3536 WR'),
                        subtitle: Text('BMW X1'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('Nebeng Kuy'),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                            'Nebeng Kuy',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xfff0077B6)),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
