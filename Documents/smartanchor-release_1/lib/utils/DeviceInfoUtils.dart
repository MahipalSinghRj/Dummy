import 'dart:io';

import 'package:get/get.dart';

class DeviceInfoUtils extends GetxController {
  String getAndroidVersion() {
    if (Platform.isAndroid) {
      return Platform.operatingSystemVersion;
    }
    return '';
  }
}
