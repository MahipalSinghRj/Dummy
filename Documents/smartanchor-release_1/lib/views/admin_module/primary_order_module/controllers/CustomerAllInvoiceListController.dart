/// Controller file for admin customerAllInvoices module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerAllInvoiceListResponse.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';

class AdminCustomerInvoiceListController extends GetxController {
  List<String> buList = [];
  List<InvoiceLists> invoiceLists=[];


  ///Method to get all invoice list of customer

  Future<bool?> getCustomerAllInvoiceListList({
    required String code,
    required String role,
    required String screenName,
    required String fromDate,
    required String toDate,
    required String bu,

  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerAllInvoiceListApi(role: role, screenName: screenName, code: code,fromDate: fromDate,toDate: toDate,bu: bu).then((value) {
      Get.back();

      try {
        if (value != null) {
          if (value.errorMessage == null) {
            buList = value.buList!;
            invoiceLists = value.invoiceLists!;
            update();

            return true;
          }
          else {
            Widgets().showToast(value.errorMessage!);
            return false;
          }
        }
          else {
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


  ///API call to get all invoice list of customer

  Future<CustomerAllInvoiceListResponse?> getAdminCustomerAllInvoiceListApi({
    required String code,
    required String role,
    required String screenName,
    required String fromDate,
    required String toDate,
    required String bu,

  }) async {
    Map map = {
      "bu": bu,
      "customerNo": code,
      "fromDate": fromDate,
      "toDate": toDate,
      "role": role,
      "screenName": screenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerAllInvoiceList, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerAllInvoiceListResponse customerAllInvoiceListResponse = CustomerAllInvoiceListResponse.fromJson(value);
          return customerAllInvoiceListResponse;
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
