import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../models/RetailerNewOrderDetailResponse.dart';
import '../models/RetailerNewOrderListResponse.dart';

class RetailerNewOrderController extends GetxController {

  int orderCount =0;
  int totalVisitedRetailer =0;
  List<NewOrderLists> newOrderLists=[];
  String address='';
  String adharNo='';
  String beat='';
  String city='';
  String creditLimit='';
  String district='';
  String geoCordinator='';
  String gstNo='';
  String mobileNo='';
  List<NewOrderDetailsLists> newOrderDetailsLists=[];
  String outstanding='';
  String overdue='';
  String panNo='';
  String pincode='';
  String proprietorName='';
  String shopName='';
  String state='';

  int totalValue=0;



  Future<bool?> getRetailerNewOrders({
    required String fromDate,
    required String toDate,
    required String orderId,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");
    await getAdminRetailerNewOrdersApi(
            fromDate: fromDate,
            toDate: toDate,
            pageNumber: pageNumber,
            pageSize: pageSize,
            screenName: screenName,
            searchString: searchString,
            orderId: orderId,
            role: role)
        .then((value) {
     // Get.back();

      try {
        if (value != null) {
          newOrderLists=value.newOrderLists!;
          orderCount=value.orderCount!;
          totalVisitedRetailer=value.totalVisitedRetailers!;
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

  Future<RetailerNewOrderListResponse?> getAdminRetailerNewOrdersApi(
      {required String fromDate,
      required String toDate,
      required int pageNumber,
      required int pageSize,
      required String screenName,
      required String searchString,
      required String orderId,
      required String role}) async {
    Map map = {"fromDate": fromDate, "orderId":orderId, "pageNumber": pageNumber,
      "pageSize": pageSize, "role": role, "screenName": screenName, "searchString":searchString, "toDate":toDate};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerNewOrders, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerNewOrderListResponse retailerNewOrderListResponse = RetailerNewOrderListResponse.fromJson(value);
          return retailerNewOrderListResponse;
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



  Future<bool?> getRetailerNewOrderDetail({
    required String orderId,

  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerNewOrderDetailApi(orderId:orderId).then((value) {
    //  Get.back();

      try {
        if (value != null) {

          address=value.address!;
          shopName=value.shopName!;
          newOrderDetailsLists=value.newOrderDetailsLists!;
          beat=value.beat!;
          city=value.city!;
          state=value.state!;
          creditLimit=value.creditLimit!;
          outstanding=value.outstanding!;
          overdue=value.overdue!;
          mobileNo=value.mobileNo!;


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

  Future<RetailerNewOrderDetailResponse?> getAdminRetailerNewOrderDetailApi({
    required String orderId,

  }) async {
    Map map = {
      "orderId":orderId
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerNewOrderDetail, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerNewOrderDetailResponse retailerNewOrderDetailResponse = RetailerNewOrderDetailResponse.fromJson(value);
          return retailerNewOrderDetailResponse;
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

  calculateTotalValue(){

    for(int i=0;i<newOrderDetailsLists.length;i++){
      int price=0;
      if(newOrderDetailsLists[i].rlp==''){
        price=0;
      }
      else{
        price=int.parse(newOrderDetailsLists[i].rlp!);
      }
      totalValue=totalValue+price;

      update();
    }
  }



  Future<bool?> getRetailerNewOrdersList({
    required String fromDate,
    required String toDate,
    required String orderId,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerNewOrdersListApi(
        fromDate: fromDate,
        toDate: toDate,
        pageNumber: pageNumber,
        pageSize: pageSize,
        screenName: screenName,
        searchString: searchString,
        orderId: orderId,
        role: role)
        .then((value) {
   //   Get.back();

      try {
        if (value != null) {
          newOrderLists=value.newOrderLists!;

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

  Future<RetailerNewOrderListResponse?> getAdminRetailerNewOrdersListApi(
      {required String fromDate,
        required String toDate,
        required int pageNumber,
        required int pageSize,
        required String screenName,
        required String searchString,
        required String orderId,
        required String role}) async {
    Map map = {"fromDate": fromDate, "orderId":orderId, "pageNumber": pageNumber,
      "pageSize": pageSize, "role": role, "screenName": screenName, "searchString":searchString, "toDate":toDate};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerNewOrders, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerNewOrderListResponse retailerNewOrderListResponse = RetailerNewOrderListResponse.fromJson(value);
          return retailerNewOrderListResponse;
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
