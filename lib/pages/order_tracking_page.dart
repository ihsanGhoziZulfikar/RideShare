import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_share/constant.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationController = Location();
  late GoogleMapController _mapController;

  static const LatLng sourceLocation = LatLng(-6.862417460687757, 107.59372402873836);
  static const LatLng destination = LatLng(-6.889144835635328, 107.5959113186077);

  List<LatLng> polylineCoordinates = [];
  bool _locationPermissionGranted = false;

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
      setState(() {});
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
      // Handle the case when the user denies the permission
      print('Location permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track order'),
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
              markers: {
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
              },
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
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      return result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(polylineId: id, color: Colors.deepPurple, points: polylineCoordinates, width: 5);

    setState(() {
      polylines[id] = polyline;
    });
  }
}
