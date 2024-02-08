import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/beat_module/models/responseModels/GetActionEventApprovalDataResponse.dart';

import '../../../common/widgets.dart';
import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../global/common_controllers/GlobalController.dart';
import '../../../services/ApiService.dart';
import '../models/responseModels/GetUserListDataResponse.dart';

class Option01Controller extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());

  List<ApprovalData> approvalData = [];
  List<String> headerList = [];
  List<String> userList = [];
  List<String> userListForSearch = [];
  List<String> userListForSearchOnlyCode = [];

  String selectedEmployee = '';
  String fromDate = '';
  String toDate = '';

  fnClear() {
    dateFromController.text = '';
    dateToController.text = '';
    searchTextController.text = '';
  }

  employeeSetter(String input) {
    selectedEmployee = input;
    update();
  }

  fromDateSetter(String input) {
    fromDate = input;
    update();
  }

  toDateSetter(String input) {
    toDate = input;
    update();
  }

  //---------------------------------------------------------------------------------------
  ///Get event action data api
  getActionEventApprovalData({
    required String dateFrom,
    required String dateTo,
    required String employeeCode,
  }) async {
    Widgets().loadingDataDialog(loadingText: "Loading data, Please wait!");

    await getActionEventApprovalDataApi(dateFrom: dateFrom, dateTo: dateTo, employeeCode: employeeCode).then((value) {
      Get.back();

      if (value != null) {
        approvalData = value.approvalData ?? [];
        headerList = value.headerList ?? [];
        userList = value.userList ?? [];
      }
    });

    update();
  }

  getUserListData() async {
    update();
    await Future.delayed(const Duration(milliseconds: 2000));
    Widgets().loadingDataDialog(loadingText: "Loading data, Please wait!");

    try {
      final value = await getUserListDataApi();
      Get.back();

      if (value != null) {
        userListForSearch = value.userNamesList ?? [];
        userListForSearchOnlyCode = value.userList ?? [];
        printMe("User list is: ${value.userList?.length.toString()}");
        return userListForSearch;
      } else {
        Widgets().showToast("User list is empty!");
        return [];
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return [];
    }
  }

//-----------------
  Future<GetUserListDataResponse?> getUserListDataApi() {
    //TODO : add this map when response coming properly
    var map = {
      "customerScreenName": globalController.customerScreenName,
    };

    /*var map = {
      "customerScreenName": "a07530",
    };*/

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getUserListData, requestJson).then((value) {
      try {
        if (value != null) {
          GetUserListDataResponse getUserListDataResponse = GetUserListDataResponse.fromJson(value);
          return getUserListDataResponse;
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

  //Get action event approval data
  Future<GetActionEventApprovalDataResponse?> getActionEventApprovalDataApi({
    required String dateFrom,
    required String dateTo,
    required String employeeCode,
  }) {
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "employeeCode": employeeCode,
    };

    //var map = {"customerScreenName": "a07530", "dateFrom": "01/11/2023", "dateTo": "10/11/2023", "employeeCode": ""};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getActionEventApprovalData, requestJson).then((value) {
      try {
        if (value != null) {
          GetActionEventApprovalDataResponse getActionEventApprovalDataResponse = GetActionEventApprovalDataResponse.fromJson(value);
          return getActionEventApprovalDataResponse;
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
