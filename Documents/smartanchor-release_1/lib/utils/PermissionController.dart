import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartanchor/common/NewWidgets.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/widgets.dart';
import 'DeviceInfoUtils.dart';

class PermissionController extends GetxController {
  // permission status
  bool isPermissionUsable(PermissionStatus status) {
    printWarning('isPermissionUsable called');
    printWarning('PermissionStatus status $status');

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited: // iOS
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional: // iOS
        return false;

      default:
        return false;
    }
  }

  // location permission functions
  Future<PermissionStatus> checkLocationPermission() async {
    printWarning('checkLocationPermission called');

    final status = await Permission.location.status;
    return status;
  }

  Future<PermissionStatus> requestLocationPermission() async {
    printWarning('requestLocationPermission called');

    final status = await Permission.location.request();
    return status;
  }

  Future<void> locationPermissionDeniedPermanent() async {
    printWarning('locationPermissionDeniedPermanent called');
    if (await Permission.location.isPermanentlyDenied) {
      // await Geolocator.openLocationSettings();

      await NewWidgets().showSimpleDialog(
          contentString: "We need location access to mark attendance and show Customer Location on Map with markers. Please allow for location permission.",
          onTapCancel: () {},
          hideCancelButton: true,
          onTapOk: () async {
            Get.back();
            await openAppSettings();
          });

      // if (await canLaunchUrl(Uri.parse('App-Prefs:root=LOCATION_SERVICES'))) {
      //   await launchUrl(Uri.parse('App-Prefs:root=LOCATION_SERVICES'));
      // }
    }
  }

  /// location service functions****************

  Future<bool> isLocationServiceEnabled() async {
    printWarning('isLocationServiceEnabled called');

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  Future<bool> locationServiceAndPermissionEnabled() async {
    bool isServiceEnabled = await isLocationServiceEnabled();
    bool isPermissionEnabled = isPermissionUsable(await checkLocationPermission());
    return isServiceEnabled && isPermissionEnabled;
  }

  Future<void> openLocationSettingsIfDisabled(bool isLocationEnabled) async {
    printWarning('openLocationSettingsIfDisabled called');
    if (!isLocationEnabled) {
      if (Platform.isAndroid) {
        await Geolocator.openLocationSettings();
      } else if (Platform.isIOS) {
        final url = Uri.parse('App-Prefs:root=LOCATION_SERVICES');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    }
  }

  // ---------------

  DeviceInfoUtils deviceInfoUtils = Get.put(DeviceInfoUtils());

  Future<PermissionStatus> storagePermissionStatus() async {
    // check if android or ios
    //if android , android 10/11/12/13 request accordingly/ ios

    if (Platform.isAndroid) {
      String androidVersion = deviceInfoUtils.getAndroidVersion();
      if (androidVersion.contains('10') || androidVersion.contains('9')) {
        return await Permission.storage.status;
      } else if (androidVersion.contains('11') || androidVersion.contains('12')) {
        return await Permission.photos.status;
      } else {
        return await Permission.photos.status;
      }
    } else {
      //ios
      return await Permission.storage.status;
    }
  }

  Future<PermissionStatus> requestStoragePermission() async {
    if (Platform.isAndroid) {
      String androidVersion = deviceInfoUtils.getAndroidVersion();
      if (androidVersion.contains('10') || androidVersion.contains('9')) {
        return await Permission.storage.request();
      } else if (androidVersion.contains('11') || androidVersion.contains('12')) {
        return await Permission.photos.request();
      } else {
        print("android 13");
        return await Permission.photos.request();

        // return await Permission.accessMediaLocation.request();
      }
    } else {
      //ios
      return await Permission.storage.request();
    }
  }

  Future<void> checkAndRequestFilePermission() async {
    var storageStatus = await Permission.photos.status;

    print("stirage permission check ===");
    print(storageStatus);
    if (storageStatus.isPermanentlyDenied) {
      NewWidgets().showSimpleDialog(
          contentString:
              "To Access Files or download files in your device we required this permission without this file storage service will not work. Please allow for storage permission.",
          onTapCancel: () {},
          hideCancelButton: true,
          onTapOk: () async {
            Get.back();
            await openAppSettings();
          });
    } else {
      //todo: add request dialog
      print('asking for storage permission');
      await requestStoragePermission();
    }
  }

  ///------------.
  Future<bool> isStoragePermissionGranted() async {
    return isPermissionUsable(await storagePermissionStatus());
  }

  Future<void> askReadWritePermission() async {
    await checkAndRequestFilePermission();
  }
}
