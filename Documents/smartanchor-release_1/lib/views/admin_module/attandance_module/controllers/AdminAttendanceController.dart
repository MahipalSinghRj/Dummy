/// Controller file for admin attendance module (all functions and api are called here)
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/views/admin_module/attandance_module/models/AdminTrackEmployeeResponse.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';
import '../models/AdminAttendanceResponse.dart';
import '../models/AdminFilteredAttendanceResponse.dart';

class AdminAttendanceController extends GetxController {
  List<EmpDetails> empDetails = [];
  List<String> placeList = [];

  int totalAbsent = 0;
  int totalLate = 0;
  int totalPresent = 0;

  List<String> buList = [];

  List<EmloyeeDetailsFilter> empDetailsFilter = [];

  List<Coordinates> coordinates = [];

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(26.7782534, 75.8599281),
    zoom: 16,
  );

  ///Method to get all employee list and details of absent/present/late employees
  Future<bool?> getAdminAttendance({required String date}) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminAttendanceApi(date: date).then((value) {
      Get.back();

      try {
        if (value != null) {
          if (value.employeeList!.empDetails != null) {
            empDetails = value.employeeList!.empDetails!;
          }
          placeList = value.placeList!;

          totalAbsent = value.totalAbsent!;
          totalLate = value.totalLate!;
          totalPresent = value.totalPresent!;
          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  ///API call to get all employee list and details of absent/present/late employees

  Future<AdminAttendanceResponse?> getAdminAttendanceApi({
    required String date,
  }) async {
    Map map = {"screenName": globalController.customerScreenName, "role": globalController.role, "date": date};
    printMe("Map passing : $map");
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminAttendanceEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AdminAttendanceResponse adminAttendanceResponse = AdminAttendanceResponse.fromJson(value);
          return adminAttendanceResponse;
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

  ///Method to get all employee list and details of absent/present/late employees based on filters like(from date,toDate,bu,zone,state,city )

  Future<bool?> getFilteredAdminAttendance({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminFilteredAttendanceApi(fromdate: fromDate, toDate: toDate, bu: bu, state: state, zone: zone, city: city).then((value) {
      Get.back();

      try {
        if (value != null) {
          if (value.employeeList!.empDetails != null) {
            empDetailsFilter = value.employeeList!.empDetails!;
          }else{
            empDetailsFilter =[];
          }
          totalAbsent = value.totalAbsent!;
          totalLate = value.totalLate!;
          totalPresent = value.totalPresent!;
          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  ///API call to get all employee list and details of absent/present/late employees based on filters like(from date,toDate,bu,zone,state,city )

  Future<AdminFilteredAttendanceResponse?> getAdminFilteredAttendanceApi({
    required String fromdate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
  }) async {
    Map map = {
      "bu": bu,
      "city": city,
      "dateFrom": fromdate,
      "dateTo": toDate,
      "role": globalController.role,
      "screenName": globalController.customerScreenName,
      "state": state,
      "zone": zone
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminFilteredAttendanceEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AdminFilteredAttendanceResponse getAdminFilteredAttendanceResponse = AdminFilteredAttendanceResponse.fromJson(value);
          return getAdminFilteredAttendanceResponse;
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

  ///Method to get list of bu to show in filters dropdown

  Future<bool?> getAdminData() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminAPIs().then((value) {
      Get.back();

      try {
        if (value != null) {
          buList = value.bu!;

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  ///API call to get list of bu to show in filters dropdown

  Future<AdminDropdownResponse?> getAdminAPIs() async {
    Map map = {"bu": "", "zone": "", "state": "", "division": "", "category": "", "brand": "", "city": ""};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBuListEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AdminDropdownResponse getStatesForCustomersResponse = AdminDropdownResponse.fromJson(value);
          return getStatesForCustomersResponse;
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

  ///Method to track employee to get employee location

  Future<bool?> getAdminTrackEmployee({
    required String code,
    required String date,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminTrackEmployeeAPI(
      date: date,
      code: code,
    ).then((value) {
      Get.back();

      try {
        if (value != null) {
          coordinates = value.coordinates!;

          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  ///API call to track employee to get employee location

  Future<AdminTrackEmployeeResponse?> getAdminTrackEmployeeAPI({
    required String code,
    required String date,
  }) async {
    Map map = {"date": date, "empCode": code};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminTrackEmployeeEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AdminTrackEmployeeResponse getAdminTrackEmployeeResponse = AdminTrackEmployeeResponse.fromJson(value);
          return getAdminTrackEmployeeResponse;
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
