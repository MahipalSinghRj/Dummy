/// Controller file for admin customerReturnOrder module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';
import '../models/CustomerReturnOrderDetailResponse.dart';
import '../models/CustomerReturnOrderListResponse.dart';

class AdminCustomerReturnOrderController extends GetxController {
  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];
  List<GraphDetails> graphDetails = [];
  List<OrderDetails> orderDetails = [];
  String returnOrderCount = '';
  String totalCustomerVisited = '';

  String orderDate = '';
  String orderId = '';
  String orderQuantity = '';
  String orderStatus = '';
  String productCount = '';
  List<ProductDetails> productDetails = [];
  int totalValue=0;

  ///Method to get all return orders list of customer

  Future<bool?> getCustomerReturnOrderList({
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

    await getAdminCustomerReturnOrderApi(fromDate: fromDate, toDate: toDate, bu: bu, state: state, zone: zone, city: city, role: role, screenName: screenName)
        .then((value) {
      Get.back();

      try {
        if (value != null) {
          returnOrderCount = value.returnOrderCount!;
          totalCustomerVisited = value.totalCustomerVisited!;
          orderDetails = value.orderDetails!;
          graphDetails = value.graphDetails!;
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


  ///API call to get all return orders list of customer

  Future<CustomerReturnOrderListResponse?> getAdminCustomerReturnOrderApi({
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

    return ApiService.postRequest(ApiConstants.getAdminCustomerReturnOrders, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerReturnOrderListResponse customerReturnOrderListResponse = CustomerReturnOrderListResponse.fromJson(value);
          return customerReturnOrderListResponse;
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



  ///Method to get list of bu,zones,city,states

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

  ///API call to get list of bu,zones,city,states

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

  ///Method to get detail of single return order based on orderId

  Future<bool?> getCustomerReturnOrderDetail({
    required String orderId,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerReturnOrderDetailApi(orderId: orderId).then((value) {
      Get.back();

      try {
        if (value != null) {
          orderDate = value.orderDate!;
          orderStatus = value.orderStatus!;
          orderQuantity = value.orderQuantity!;
          productDetails = value.productDetails!;
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


  ///API call to get detail of single return order based on orderId

  Future<CustomerReturnOrderDetailResponse?> getAdminCustomerReturnOrderDetailApi({
    required String orderId,
  }) async {
    return ApiService.getRequest(ApiConstants.getAdminCustomerReturnOrderDetail, orderId).then((value) {
      try {
        if (value != null) {
          CustomerReturnOrderDetailResponse customerReturnOrderDetailResponse = CustomerReturnOrderDetailResponse.fromJson(value);
          return customerReturnOrderDetailResponse;
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


  ///Method to calculate total value of return orders

  calculateTotalValue(){

    for(int i=0;i<productDetails.length;i++){
      int price=0;
      if(productDetails[i].totalPrice==''){
        price=0;
      }
      else{
        price=int.parse(productDetails[i].totalPrice!);
      }
      totalValue=totalValue+price;
      print('sagr');
      print(totalValue);
      update();
    }
  }

}
