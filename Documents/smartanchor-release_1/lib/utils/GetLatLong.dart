import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../debug/printme.dart';

class GetLatLong extends GetxController {
  Future<String?> getLongitude() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      printMe("Position : $position");
      printMe("longitude : ${position.longitude}");

      return position.longitude.toString();
    } catch (e) {
      printMe("Error getting location: $e");
    }
    return null;
  }

  Future<String?> getLatitude() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      printMe("Position : $position");
      printMe("latitude : ${position.latitude}");

      return position.latitude.toString();
    } catch (e) {
      printMe("Error getting location: $e");
    }
    return null;
  }
}
