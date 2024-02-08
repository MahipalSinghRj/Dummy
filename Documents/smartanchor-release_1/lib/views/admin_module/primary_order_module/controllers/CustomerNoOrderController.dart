/// Controller file for admin customerNoOrder module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerNoOrderDetailResponse.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerNoOrderListResponse.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';

class AdminCustomerNoOrderController extends GetxController {
  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];

  String noOrderCount='';
  List<NoOrderDetails> noOrderDetails=[];
  List<GraphDetails> graphDetails=[];
  String totalCustomerVisited='';


  String fileName='';
  String fileUrl='';
  String noOrderId='';
  String reason='';
  String remarks='';


  ///Method to get all no orders list of customer

  Future<bool?> getCustomerNoOrderList({
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

    await getAdminCustomerNoOrderApi(fromDate: fromDate, toDate: toDate, bu: bu, state: state, zone: zone, city: city, role: role, screenName: screenName).then((value) {
      Get.back();

      try {
        if (value != null) {
          noOrderCount=value.noOrderCount!;
          totalCustomerVisited=value.totalCustomerVisited!;
          noOrderDetails=value.noOrderDetails!;
          graphDetails=value.graphDetails!;
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

  ///API call to get all new orders list of customer

  Future<CustomerNoOrderListResponse?> getAdminCustomerNoOrderApi({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required String role,
    required String screenName,
  }) async {
    Map map = {"bu": bu, "city": city, "dateFrom": fromDate, "dateTo": toDate, "role": role, "screenName": screenName, "state": state, "zone": zone};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerNoOrders, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerNoOrderListResponse customerNoOrderListResponse = CustomerNoOrderListResponse.fromJson(value);
          return customerNoOrderListResponse;
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

  ///Method to get list of bu,city,zones,states

  Future<bool?> getAdminData(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminAPIs(bu: bu, state: state, city: city, brand: brand, category: category, division: division, zone: zone).then((value) {
      Get.back();

      try {
        if (value != null) {
          buList = value.bu!;
          zoneList = value.zone!;
          stateList = value.state!;
          divisionList = value.division!;
          categoryList = value.category!;
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


  ///API call to get list of bu,city,zones,states

  Future<AdminDropdownResponse?> getAdminAPIs(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    Map map = {"bu": bu, "zone": zone, "state": state, "division": division, "category": category, "brand": brand, "city": city};

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


  ///Method to get detail of single no order

  Future<bool?> getCustomerNoOrderDetail({
    required String orderId,

  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerNoOrderDetailApi(orderId:orderId).then((value) {
      Get.back();

      try {
        if (value != null) {

          reason=value.reason!;
          remarks=value.remarks!;
          fileName=value.fileName!;



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


  ///API call to get detail of single no order based on orderId

  Future<CustomerNoOrderDetailResponse?> getAdminCustomerNoOrderDetailApi({
    required String orderId,

  }) async {
    Map map = {
      "noOrderId": orderId
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerNoOrderDetail, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerNoOrderDetailResponse customerNoOrderDetailResponse = CustomerNoOrderDetailResponse.fromJson(value);
          return customerNoOrderDetailResponse;
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
