import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomeGoogleMapScreen extends StatefulWidget {
  const CustomeGoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<CustomeGoogleMapScreen> createState() => _CustomeGoogleMapScreenState();
}

class _CustomeGoogleMapScreenState extends State<CustomeGoogleMapScreen> {
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025));
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    try {
      _controller.complete(controller);
    } catch (e) {
      print("Map Exception Here ====>>>> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
      ),
    );
  }
}
