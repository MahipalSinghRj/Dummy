/// Controller file for admin customerNewOrder module (all functions and api are called here)

import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/models/CustomerNewOrderDetailResponse.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../models/CustomerNewOrderListResponse.dart';

class AdminCustomerNewOrderController extends GetxController {
  int newOrderCount = 0;
  String orderSales = '';
  List<Orders> orders = [];
  int totalCustomerVisited = 0;

  String discount = '';
  String orderDate = '';
  String orderQTY = '';
  String orderStatus = '';
  List<ProductLists> productLists = [];
  String tax = '';
  String totalOrderValueAfterDiscount = '';
  String totalOrderValueBeforeDiscount = '';

  double totalValue = 0;

  ///Method to get all new orders list of customer

  Future<bool?> getCustomerNewOrders({
    required String fromDate,
    required String toDate,
    required String orderId,
    required String screenName,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerNewOrdersApi(
      fromDate: fromDate,
      toDate: toDate,
      screenName: screenName,
      orderId: orderId,
    ).then((value) {
      Get.back();

      try {
        if (value != null) {
          print('ErrormESSAGE');
          print(value.errorMessage);
          if (value.errorMessage == null) {
            totalCustomerVisited = value.totalCustomerVisited!;
            newOrderCount = value.newOrderCount!;
            orderSales = value.orderSales!;
            orders = value.orders!;
            update();
            return true;
          } else {
            Widgets().showToast(value.errorMessage!);
            return false;
          }
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

  ///API call to get all new orders list  of customer

  Future<CustomerNewOrderListResponse?> getAdminCustomerNewOrdersApi({
    required String fromDate,
    required String toDate,
    required String screenName,
    required String orderId,
  }) async {
    Map map = {"screenName": screenName, "orderId": orderId, "fromDate": fromDate, "toDate": toDate};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminCustomerNewOrders, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerNewOrderListResponse customerNewOrderListResponse = CustomerNewOrderListResponse.fromJson(value);
          return customerNewOrderListResponse;
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

  ///Method to get  new orders details of single order of customer

  Future<bool?> getCustomerNewOrderDetail({
    required int orderId,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await getAdminCustomerNewOrderDetailApi(orderId: orderId).then((value) {
      Get.back();

      try {
        if (value != null) {
          productLists = value.productLists!;
          orderQTY = value.orderQTY!;
          orderStatus = value.orderStatus!;
          totalOrderValueAfterDiscount = value.totalOrderValueAfterDiscount!;
          orderDate = value.orderDate!;
          tax = value.tax!;
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

  ///API Call to get  new orders details of single order of customer

  Future<CustomerNewOrderDetailResponse?> getAdminCustomerNewOrderDetailApi({
    required int orderId,
  }) async {
    return ApiService.getRequest(ApiConstants.getAdminCustomerNewOrderDetail, orderId.toString()).then((value) {
      try {
        if (value != null) {
          CustomerNewOrderDetailResponse customerNewOrderDetailResponse = CustomerNewOrderDetailResponse.fromJson(value);
          return customerNewOrderDetailResponse;
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

  /// Method to calculate total value of new ordered items

  calculateTotalValue() {

    printMe("TAX : $tax");
    if(tax.isEmpty){
      tax ="0";
    }

    printMe("TAX--> : $tax");
    printMe("totalOrderValueAfterDiscount--> : $totalOrderValueAfterDiscount");
    totalValue = double.parse(totalOrderValueAfterDiscount) + double.parse(tax);
    printMe("totalValue--> : $totalValue");
    update();
  }
}
