import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../services/ApiService.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../../admin_module/home_module/bottomNavigation/LandingPageAdmin.dart';
import '../../../home_module/BottomNavigation/LandingPage.dart';
import '../../models/ClockInOutApiResponse.dart';

class MarkAttendanceController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtilsController = Get.put(DateTimeUtils());
  ViewLocationOnMapController viewLocationOnMapController =
      Get.put(ViewLocationOnMapController());

  clockInOut(
    String address,
    String image,
    String latitude,
    bool login,
    String longitude,
    String remark,
    String time,
  ) {
    var map = {
      "address": address,
      "latitude": latitude,
      "login": globalController.isClockIn ? false : true,
      "longitude": longitude,
      "mimeType": "image/png",
      "remark": remark.isEmpty ? "" : remark,
      //todo : add dynamic value for screen name
      "screenName": globalController.customerScreenName,
      "time": time,
      "image": image
    };

    Widgets().loadingDataDialog(loadingText: "Data Uploading, Please wait...");

    clockInOutApi(map).then((value) {
      Get.back();
      if (value != null) {
        if (value.status != null) {
          Widgets().showToast(value.status.toString());
          //todo : confirm status to save clockin
          if (value.status.toString().toLowerCase() ==
                  'logged in Successfully'.toString().toLowerCase() ||
              value.status.toString().toLowerCase() ==
                  'LogedIn Already or loged in after 12 o clock'
                      .toString()
                      .toLowerCase()) {
            globalController.saveLoginState(isClockIn: true);
            update();
          } else if (value.status.toString().toLowerCase() ==
                  'logged out successfully'.toString().toLowerCase() ||
              value.status.toString().toLowerCase() ==
                  'logged out already'.toString().toLowerCase()) {
            globalController.saveLoginState(isClockIn: false);
            update();
          } else {
            globalController.saveLoginState(isClockIn: false);
            printMe("Unexpected status received: ${value.status}");
          }
        }
        //todo: handling with proper values
        //todo: update isclockin here

        if (globalController.role == "ASM" ||
            globalController.role == "ZSM" ||
            globalController.role == "Admin" ||
            globalController.role == "NSM") {
          // new admin
          Get.offAll(() => const LandingPageAdmin(selectedItemIndex: 0));
        } else {
          Get.offAll(() => const LandingPage(selectedItemIndex: 0));
        }
      }
      update();
    });
  }

  Future<ClockInOutApiResponse?> clockInOutApi(
    Map map,
  ) {
    var requestJson = jsonEncode(map);
    print(requestJson);
    return ApiService.postRequest(ApiConstants.clockInOutApi, requestJson).then(
        (value) {
      try {
        if (value != null) {
          ClockInOutApiResponse passwordResetResponse =
              ClockInOutApiResponse.fromJson(value);
          return passwordResetResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }
}
