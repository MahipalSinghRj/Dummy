import 'dart:convert';

import 'package:get/get.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_previous_order_model/PreviousOrderDetailsResponse.dart';
import '../../models/responseModels/retailer_previous_order_model/ViewPreviousOrderResponse.dart';
import '../retailer_calculation_controller/RetailerCalculationController.dart';

class RetailerPreviousOrderController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());

  RetailerCalculationController _retailerCalculationController = Get.put(RetailerCalculationController());
  List<PreviousOrderDetail> previousOrderDetailList = [];
  String? orderDate;
  String? orderQty;
  String? status;
  double totalUnitPrice = 0.0;
  int initialTotalQuantity = 0;
  List<String> yesRetailerSelectProduct = [];
  List<String> noRetailerSelectProduct = [];

  ///Get Retailer Previous order Grid data
  Future<bool> previousOrderDetailsFn({
    required String endDate,
    required String orderID,
    required String retailerCode,
    required String startDate,
  }) async {
    // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    try {
      final response = await previousOrderDetailsApi(
        endDate: endDate,
        orderID: orderID,
        retailerCode: retailerCode,
        startDate: startDate,
      );

      if (response != null) {
        Get.back();
        previousOrderDetailList = response.previousOrderDetail ?? [];
        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
    }

    update();
    return false;
  }

  Future<PreviousOrderDetailsResponse?> previousOrderDetailsApi({
    required String endDate,
    required String orderID,
    required String retailerCode,
    required String startDate,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "endDate": endDate,
      "orderID": orderID,
      "retailerCode": retailerCode,
      "startDate": startDate,
      'screenName': globalController.customerScreenName,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.previousOrderDetails, requestJson).then((value) {
      try {
        if (value != null) {
          PreviousOrderDetailsResponse previousOrderDetailsResponse = PreviousOrderDetailsResponse.fromJson(value);
          return previousOrderDetailsResponse;
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

  ///retailer previous order details api
  List<OrderDetailProductList> orderDetailsProductList = [];

  Future<bool> viewPreviousOrderFn({
    required String orderID,
    required String retailerCode,
  }) async {
    // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    try {
      final response = await viewPreviousOrderApi(
        orderID: orderID,
        retailerCode: retailerCode,
      );

      if (response != null) {
        Get.back();
        orderDetailsProductList = response.orderDetailProductList ?? [];
        orderDate = response.orderDate;
        orderQty = response.totalQuantity;
        status = response.status;
        printMe("Status is : ${response.status}");
        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        Get.back();
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
    }

    update();
    return false;
  }

  Future<ViewPreviousOrderResponse?> viewPreviousOrderApi({
    required String orderID,
    required String retailerCode,
  }) {
    var map = {"orderID": orderID, "retailerCode": retailerCode};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.viewPreviousOrder, requestJson).then((value) {
      try {
        if (value != null) {
          ViewPreviousOrderResponse viewPreviousOrderResponse = ViewPreviousOrderResponse.fromJson(value);
          return viewPreviousOrderResponse;
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

  ///Calculation part of Retailer previous order
  deletePreviousProductItem(OrderDetailProductList product) {
    List<OrderDetailProductList> itemList = orderDetailsProductList;
    printMe("Selected list length : ${itemList.length}");
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == product.skuCode) {
          item.itemCount = 1;
          itemList.remove(item);
          update();
          break;
        }
      }
    }
    printMe(itemList.length);

    _retailerCalculationController.setSelectedPreviousListItems(itemList);
    _retailerCalculationController.setPreviousTotalPrice(initialPreviousTotalPrice(itemList));

    update();
  }

/*
  String initialPreviousTotalPrice(List<OrderDetailProductList> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.rlp != null) {
          double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }
    printMe("Total Value : $totalValue");

    return totalValue.toString();
  }*/

/*  updatePreviousQtyValue(int quantity, OrderDetailProductList product) {
    List<OrderDetailProductList> itemList = orderDetailsProductList;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == product.skuCode) {
          item.itemCount = quantity;
          if (item.rlp != null) {
            double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
            item.totalPrice = dlp * item.itemCount;
          }
          break;
        }
      }
    }
    double totalValue = 0.0;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.rlp != null) {
          double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }

    _retailerCalculationController.setSelectedPreviousListItems(itemList);
    _retailerCalculationController.setPreviousTotalPrice(initialPreviousTotalPrice(itemList));
    update();
  }*/

  /*  String getTotalOrderQTY() {
    List<OrderDetailProductList> itemList = orderDetailsProductList;
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += int.tryParse(item.quantity.toString())!;
        printMe("Total order qty ; $totalOrders");
      }
    }

    String total = totalOrders.toString();
    return total;
  }*/

  String initialPreviousTotalPrice(List<OrderDetailProductList> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.rlp != null) {
          double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
          //int qty = item.itemCount;
          int qty = (int.tryParse(item.quantity.toString()) ?? 0);
          totalValue += dlp * qty;
        }
      }
    }
    printMe("Total Value : $totalValue");

    return totalValue.toStringAsFixed(2);
  }

  updatePreviousQtyValue(int quantity, OrderDetailProductList product) {
    List<OrderDetailProductList> itemList = orderDetailsProductList;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == product.skuCode) {
          item.quantity = int.tryParse(quantity.toString()).toString();
          //item.quantity = double.tryParse(quantity.toString()).toString();
          item.itemCount = quantity;
          if (item.rlp != null) {
            double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
            item.totalPrice = dlp * (int.tryParse(item.quantity.toString()) ?? 0);
          }
          break;
        }
      }
    }
    double totalValue = 0.0;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.rlp != null) {
          double dlp = double.tryParse(item.rlp.toString()) ?? 1.0;
          //int qty = item.itemCount;
          int qty = (int.tryParse(item.quantity.toString()) ?? 0);
          totalValue += dlp * qty;
        }
      }
    }

    _retailerCalculationController.setSelectedPreviousListItems(itemList);
    _retailerCalculationController.setPreviousTotalPrice(initialPreviousTotalPrice(itemList));
    update();
  }

  double calculateTotalUnitPrice(List<OrderDetailProductList> productDetails) {
    for (int i = 0; i < productDetails.length; i++) {
      double unitPrice = double.parse(productDetails[i].rlp.toString());
      totalUnitPrice += unitPrice;
    }
    _retailerCalculationController.setPreviousTotalPrice(initialPreviousTotalPrice(productDetails));

    update();
    return totalUnitPrice;
  }

  String getTotalOrderQTY() {
    List<OrderDetailProductList> itemList = orderDetailsProductList;
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += int.tryParse(item.quantity.toString())!;
        printMe("Total order qty ; $totalOrders");
      }
    }

    String total = totalOrders.toString();
    return total;
  }
}
