/// Controller file for admin customerProfile module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerDetailResponse.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerListResponse.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/GetFiltersResponse.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';

class AdminCustomerProfileController extends GetxController {

  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];

  String focusedCustomer='';
  String newCustomer='';
  String totalCustomer='';
  List<CustomerLists> customerLists=[];
  String address='';
  String beat='';
  String city='';
  String creditLimit='';
  String customerCode='';
  String customerName='';
  String noOrder='';
  String orderedValue='';
  String outstanding='';
  String overdue='';
  String phoneNo='';
  String returnOrder='';
  String state='';
  String totalOrdered='';


  ///Method to get all customer list and details of total/new/focused customer

  Future<bool?> getCustomerProfile({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required String role,
    required String screenName,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerProfileApi(fromDate: fromDate, toDate: toDate, bu: bu, state: state, zone: zone, city: city,
        role: role, screenName: screenName).then((value) {
      Get.back();

      try {
        if (value != null) {


          focusedCustomer=value.focusedCustomer!;
          newCustomer=value.newCustomer!;
          totalCustomer=value.totalCustomer!;
          customerLists=value.customerLists!;



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


  ///API call to get all customer list and details of total/new/focused customer

  Future<CustomerListResponse?> getAdminCustomerProfileApi({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required String role,
    required String screenName,

  }) async {
    Map map = {
      "BU": bu,
      "City": city,
      "DateFrom": fromDate,
      "DatetTo": toDate,
      "ScreenName": screenName,
      "States": state,
      "Zone": zone,
      "role": role
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerProfile, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerListResponse customerListResponse = CustomerListResponse.fromJson(value);
          return customerListResponse;
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



  ///Method to get all  list  of bu/state/city/zones

  Future<bool?> getFiltersData(
      {
        required String zone,
        required String state,
        }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getFiltersAPIs( state: state,zone: zone).then((value) {
      Get.back();

      try {
        if (value != null) {
          buList = value.bu!;
          zoneList = value.zone!;
          stateList = value.state!;
          cityList = value.city!;

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


  ///API call to get all  list  of bu/state/city/zones

  Future<GetFiltersResponse?> getFiltersAPIs({
    required String zone,
    required String state,
  }
  ) async {
    Map map = {
      "ScreenName": globalController.customerScreenName,
      "State": "",
      "Zone": "",
      "role": globalController.role};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerFilters, requestJson).then((value) {
      try {
        if (value != null) {
          GetFiltersResponse getFiltersResponse = GetFiltersResponse.fromJson(value);
          return getFiltersResponse;
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


  ///Method to get customer profile detail of each customer

  Future<bool?> getCustomerProfileDetail({
    required String code,

  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerProfileDetailApi(code:code).then((value) {
      Get.back();

      try {
        if (value != null) {
          address=value.address!;
          beat=value.beat!;
          city=value.city!;
          state=value.state!;
          creditLimit=value.creditLimit!;
          outstanding=value.outstanding!;
          overdue=value.overdue!;
          phoneNo=value.phoneNo!;
          totalOrdered=value.totalOrdered!;
          orderedValue=value.orderedValue!;
          noOrder=value.noOrder!;
          returnOrder=value.returnOrder!;


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

  ///API call to get customer profile detail of each customer

  Future<CustomerDetailResponse?> getAdminCustomerProfileDetailApi({
    required String code,

  }) async {
    Map map = {
      "customerNo": code,
      "role": globalController.role,
      "screenName": globalController.customerScreenName
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerDetailProfile, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerDetailResponse customerDetailResponse = CustomerDetailResponse.fromJson(value);
          return customerDetailResponse;
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