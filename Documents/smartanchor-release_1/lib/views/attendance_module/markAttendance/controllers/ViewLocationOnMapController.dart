import 'dart:async';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/DateTimeUtils.dart';
import '../../../../utils/PermissionController.dart';

class ViewLocationOnMapController extends GetxController {
  String address = '';
  Position? position;
  bool showMarker = false;
  String currentTime = '';
  File? attendanceImage;

  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(26.7782534, 75.8599281),
    zoom: 16,
  );

  GoogleMapController? mapController;

  //-----------------------------------
  LatLng latLng = const LatLng(0.0, 0.0);

  Set<Marker> markers = {};

  updateLocationAttributes() async {
    position = await getCurrentLocation();
    update();

    address = await getAddressFromLatLng(position!.latitude, position!.longitude) ?? "Address Not Captured";
    latLng = LatLng(position!.latitude, position!.longitude);
    showMarker = true;
    cameraPosition = getCameraPosition(position!);
    Get.back();

    update();
    await updatemarker();
  }

  updatemarker() async {
    markers = {
      Marker(
        markerId: const MarkerId("Your Location"),
        position: latLng,
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        onDragEnd: (value) {},
      ),
    };

    if (markers.isNotEmpty) {
      mapController!.moveCamera(CameraUpdate.newLatLng(markers.first.position));
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> dataFetch() async {
    // mapController = GoogleMapController();
    print("on data fetch called");
    currentTime = dateTimeUtils.formattedDateTimeNow();
    update();
    await updateLocationAttributes();
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    printMe("${position.latitude}   ${position.longitude}");
    return position;
  }

  CameraPosition getCameraPosition(Position position) {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16,
    );
    update();
    return cameraPosition;
  }

  Future<String?> getAddressFromLatLng(lat, lng) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(lat, lng);
      Placemark placeMark = p[0];

      List<String?> addressComponents = [
        // placeMark.name,
        placeMark.street,
        placeMark.subLocality,
        placeMark.subAdministrativeArea,
        placeMark.locality,
        placeMark.administrativeArea,
        placeMark.postalCode,
        placeMark.country,
      ];

      String addressString = addressComponents.where((component) => component != null).join(', ');
      print(addressString);

      return addressString;
    } catch (e, r) {
      print(e);
      print(r);
    }
    return null;
  }

  //////////////permissions and services
  PermissionController permissionController = Get.put(PermissionController());

  Future<void> checkLocationPermissionAndService() async {
    try {
      final status = await Permission.location.status;

      if (permissionController.isPermissionUsable(status)) {
        // Permission is granted or limited, check location service
        final isLocationEnabled = await permissionController.isLocationServiceEnabled();

        if (isLocationEnabled) {
          // Location service is enabled
          print('Location service is enabled.');
        } else {
          // Location service is disabled, open settings
          await permissionController.openLocationSettingsIfDisabled(isLocationEnabled);
        }
      } else if (status == PermissionStatus.permanentlyDenied) {
        // Permission is permanently denied, open app settings
        await permissionController.locationPermissionDeniedPermanent();
      } else {
        // Request location permission
        final newStatus = await permissionController.requestLocationPermission();

        if (permissionController.isPermissionUsable(newStatus)) {
          // Permission granted or limited, check location service
          final isLocationEnabled = await permissionController.isLocationServiceEnabled();

          if (isLocationEnabled) {
            // Location service is enabled
            print('Location service is enabled.');
          } else {
            // Location service is disabled, open settings
            await permissionController.openLocationSettingsIfDisabled(isLocationEnabled);
          }
        } else if (newStatus == PermissionStatus.permanentlyDenied) {
          // Permission is permanently denied, open app settings
          await permissionController.locationPermissionDeniedPermanent();
        }
      }
    } catch (e, r) {
      print(e);
      print(r);
    } // Check the location permission status
  }

  Future<LatLng?> getAddressLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      Location first = locations.first;

      double latitude = first.latitude;
      double longitude = first.longitude;

      return LatLng(latitude, longitude);
    } catch (e) {
      print('Error getting location from address: $e');
      return null;
    }
  }

  Future<void> openMapWithAddress(String address) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
