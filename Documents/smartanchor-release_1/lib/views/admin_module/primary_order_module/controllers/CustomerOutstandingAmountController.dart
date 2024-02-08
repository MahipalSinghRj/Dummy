/// Controller file for admin customerOutStandingAmount module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../models/CustomerOustandingAmountListResponse.dart';

class AdminCustomerOutstandingAmountController extends GetxController {
  List<OutstandingList> outstandingList = [];
  String totalCreditLimit = '';
  String totalOutstanding = '';
  String totalOverdue = '';


  ///Method to get outStandingAmount list of customer

  Future<bool?> getCustomerOutstandingAmountList({
    required String code,
    required String role,
    required String screenName,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerOutstandingAmountApi(role: role, screenName: screenName, code: code).then((value) {
      Get.back();

      try {
        if (value != null) {
          outstandingList = value.outstandingList!;
          totalCreditLimit = value.totalCreditLimit!;
          totalOutstanding = value.totalOutstanding!;
          totalOverdue = value.totalOverdue!;
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


  ///API call to get outStandingAmount list of customer

  Future<CustomerOutsandingAmountResponse?> getAdminCustomerOutstandingAmountApi({
    required String code,
    required String role,
    required String screenName,
  }) async {
    Map map = {"customerCode": code, "role": role, "screenName": screenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomeroutStandingAmount, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerOutsandingAmountResponse customerOutsandingAmountResponse = CustomerOutsandingAmountResponse.fromJson(value);
          return customerOutsandingAmountResponse;
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
