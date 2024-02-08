import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  final LatLng latLng;

  const MapsScreen({Key? key, required this.latLng}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Set<Marker> markers = {};
  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.7782534, 75.8599281),
    zoom: 16,
  );

  bool isLoading = false;
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: _kGooglePlex,
            liteModeEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId("marker1"),
                position: const LatLng(26.7782534, 75.8599281),
                draggable: true,
                icon: BitmapDescriptor.defaultMarker,
                onDragEnd: (value) {},
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
  }
}
