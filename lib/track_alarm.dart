import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  //late GoogleMapController mapController;
  //final Set<Marker> markers = {};

  // final CameraPosition initialPosition = CameraPosition(
  //   target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
  //   zoom: 10.0,
  // );

  @override
  void initState() {
    super.initState();
   // _startTracking();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tracking Example')),
      // body: GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   initialCameraPosition: initialPosition,
      //   markers: markers,
      //   myLocationEnabled: true,
      //   zoomControlsEnabled: true,
      // ),
    );
  }
}
