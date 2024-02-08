import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';
import '../models/RetailerNoOrderDetailResponse.dart';
import '../models/RetailerNoOrderListResponse.dart';

class RetailerNoOrderController extends GetxController {
  String noOrderCount = '';
  List<NoOrderLists> noOrderLists = [];
  String totalRetailerVisited = '';
  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];
  String address = '';
  String adharNo = '';
  String beat = '';
  String city = '';
  String creditLimit = '';
  String district = '';
  String errorMessage = '';
  String fileName = '';
  String fileUrl = '';
  String geoCordinator = '';
  String gstNo = '';
  String mobileNo = '';
  String outstanding = '';
  String overdue = '';
  String panNo = '';
  String pincode = '';
  String proprietorName = '';
  String reason = '';
  String remarks = '';
  String shopName = '';
  String state = '';
  List<NoOrderGraphLists> noOrderGraphLists = [];

  Future<bool?> getRetailerNoOrderList({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerNoOrderListApi(
            fromDate: fromDate,
            toDate: toDate,
            bu: bu,
            state: state,
            zone: zone,
            city: city,
            pageNumber: pageNumber,
            pageSize: pageSize,
            role: role,
            screenName: screenName,
            searchString: searchString)
        .then((value) {
    //  Get.back();

      try {
        if (value != null) {
          noOrderCount = value.noOrderCount!;
          totalRetailerVisited = value.totalRetailerVisited!;
          noOrderLists = value.noOrderLists!;
          noOrderGraphLists = value.noOrderGraphLists!;

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

  Future<RetailerNoOrderListResponse?> getAdminRetailerNoOrderListApi({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    Map map = {
      "bu": bu,
      "city": city,
      "fromDate": fromDate,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "role": role,
      "screenName": screenName,
      "searchString": searchString,
      "state": state,
      "toDate": toDate,
      "zone": zone
    };

    printMe("Sec no order - $map");

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.getAdminRetailerNoOrders, requestJson)
        .then((value) {
      try {
        if (value != null) {
          RetailerNoOrderListResponse retailerNoOrderListResponse =
              RetailerNoOrderListResponse.fromJson(value);
          return retailerNoOrderListResponse;
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

  Future<bool?> getAdminData(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminAPIs(
            bu: bu,
            state: state,
            city: city,
            brand: brand,
            category: category,
            division: division,
            zone: zone)
        .then((value) {
   //   Get.back();

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

  Future<AdminDropdownResponse?> getAdminAPIs(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    Map map = {
      "bu": bu,
      "zone": zone,
      "state": state,
      "division": division,
      "category": category,
      "brand": brand,
      "city": city
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBuListEndpoint, requestJson)
        .then((value) {
      try {
        if (value != null) {
          AdminDropdownResponse getStatesForCustomersResponse =
              AdminDropdownResponse.fromJson(value);
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

  Future<bool?> getRetailerNoOrderDetail({
    required String orderId,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerNoOrderDetailApi(orderId: orderId).then((value) {
     // Get.back();

      try {
        if (value != null) {
          address = value.address!;
          shopName = value.shopName!;
          beat = value.beat!;
          city = value.city!;
          state = value.state!;
          creditLimit = value.creditLimit!;
          outstanding = value.outstanding!;
          overdue = value.overdue!;
          mobileNo = value.mobileNo!;
          reason = value.reason!;
          remarks = value.remarks!;
          fileName = value.fileName!;

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

  Future<RetailerNoOrderDetailResponse?> getAdminRetailerNoOrderDetailApi({
    required String orderId,
  }) async {
    Map map = {"noOrderId": orderId};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.getAdminRetailerNoOrderDetail, requestJson)
        .then((value) {
      try {
        if (value != null) {
          RetailerNoOrderDetailResponse retailerNoOrderDetailResponse =
              RetailerNoOrderDetailResponse.fromJson(value);
          return retailerNoOrderDetailResponse;
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

  Future<bool?> getRetailerNoOrderListwithSearch({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerNoOrderListApiwithSearch(
            fromDate: fromDate,
            toDate: toDate,
            bu: bu,
            state: state,
            zone: zone,
            city: city,
            pageNumber: pageNumber,
            pageSize: pageSize,
            role: role,
            screenName: screenName,
            searchString: searchString)
        .then((value) {
    //  Get.back();

      try {
        if (value != null) {
          noOrderLists = value.noOrderLists!;

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

  Future<RetailerNoOrderListResponse?>
      getAdminRetailerNoOrderListApiwithSearch({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    Map map = {
      "bu": bu,
      "city": city,
      "fromDate": fromDate,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "role": role,
      "screenName": screenName,
      "searchString": searchString,
      "state": state,
      "toDate": toDate,
      "zone": zone
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.getAdminRetailerNoOrders, requestJson)
        .then((value) {
      try {
        if (value != null) {
          RetailerNoOrderListResponse retailerNoOrderListResponse =
              RetailerNoOrderListResponse.fromJson(value);
          return retailerNoOrderListResponse;
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
