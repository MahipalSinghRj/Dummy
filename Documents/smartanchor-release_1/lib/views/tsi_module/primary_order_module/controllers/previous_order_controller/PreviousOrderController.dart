import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/order_detail_controller/OrderDetailByIdController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/order_detail_model/OrderDetailsByIdResponse.dart';
import '../../models/responseModels/previous_order_model/PreviousOrdersByFilterResponse.dart';

class PreviousOrderController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  CalculationController _calculationController = Get.put(CalculationController());
  OrderDetailByIdController _orderDetailByIdController = Get.put(OrderDetailByIdController());
  int? itemCounts;
  bool isInitialTotalUnitPrice = false;
  int dealerBoardGroupValue = 0;
  int pSampleBoardGroupValue = 0;
  double totalUnitPrice = 0.0;
  int currentPage = 1;
  int pageLimit = 10;
  int lastPage = 0;
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();

  ///------------------------------------------------------------------------------------------------
  ///Previous Orders By Filter api
  List<PreviousOrderItems> previousOrderItemsList = [];
  bool isDataAvailable = false;

  // Function to load more data when scrolling reaches the end
  void loadMoreData(String customerCode) {
    if (currentPage < lastPage) {
      currentPage++;
      previousOrdersByFilter(
        customerCode: customerCode,
        dateFromFilter: dateFromController.text.toString(),
        dateToFilter: dateToController.text.toString(),
        orderNoFilter: orderIdController.text,
      );
    } else {
      Widgets().showToast("No more data");
    }
    update();
  }

  Future<bool?> previousOrdersByFilter({
    required String customerCode,
    required String dateFromFilter,
    required String dateToFilter,
    required String orderNoFilter,
  }) async {
    // previousOrderItemsList = [];
    // Add loader
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    });
    await previousOrdersByFilterApi(
      customerCode: customerCode,
      dateFromFilter: dateFromFilter,
      dateToFilter: dateToFilter,
      orderNoFilter: orderNoFilter,
    ).then((value) {
      Get.back();
      try {
        if (value != null) {
          lastPage = value.lastPage ?? 0;

          if (currentPage > 1) {
            previousOrderItemsList.addAll(value.previousOrderItems ?? []);
          } else {
            previousOrderItemsList = value.previousOrderItems ?? [];
          }
          // previousOrderItemsList = value.previousOrderItems ?? [];
          isDataAvailable = true;
          update();
          return true;
        } else {
          Widgets().showToast("Data not found!");
          isDataAvailable = false;
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        return null;
      }
    });
    update();
    return null;
  }

  Future<PreviousOrdersByFilterResponse?> previousOrdersByFilterApi({
    required String customerCode,
    required String dateFromFilter,
    required String dateToFilter,
    required String orderNoFilter,
  }) {
    // //TODO : Add these map when data is coming properly
    // var map = {
    //   "customerCode": customerCode,
    //   "dateFromFilter": dateFromFilter,
    //   "dateToFilter": dateToFilter,
    //   "page": 1,
    //   "pageSize": 50,
    //   "screenName": globalController.customerScreenName
    // };
//This map request changed on 24-01-2024 and added new orderNoFilter
    var map = {
      "customerCode": customerCode,
      "dateFromFilter": dateFromFilter,
      "dateToFilter": dateToFilter,
      "orderNoFilter": orderNoFilter,
      "page": currentPage,
      "pageSize": pageLimit,
      "screenName": globalController.customerScreenName,
    };
    //602350022813

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.previousOrdersByFilter, requestJson).then((value) {
      try {
        if (value != null) {
          PreviousOrdersByFilterResponse previousOrdersByFilterResponse = PreviousOrdersByFilterResponse.fromJson(value);
          return previousOrdersByFilterResponse;
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

  //======================================================================================

/*  String initialPreviousTotalPrice(List<ProductDetailsbodies> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.unitPriceList != null) {
          double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }
    printMe("Total Value : $totalValue");

    return totalValue.toString();
  }*/

/*  String getTotalOrderQTY() {
    List<ProductDetailsbodies> itemList = _orderDetailByIdController.productDetailsbodies ?? [];
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += item.itemCount;
        //totalOrders += int.tryParse(item.productQty.toString())!;
        printMe("Total order qty ; $totalOrders");
      }
    }

    String total = totalOrders.toString();
    return total;
  }*/

/*  updatePreviousQtyValue(int quantity, ProductDetailsbodies product) {
    List<ProductDetailsbodies> itemList = _orderDetailByIdController.productDetailsbodies ?? [];
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          item.itemCount = quantity;

          if (item.unitPriceList != null) {
            double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
            item.totalPrice = dlp * item.itemCount;
          }
          break;
        }
      }
    }
    double totalValue = 0.0;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.unitPriceList != null) {
          double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }

    _calculationController.setSelectedPreviousListItems(itemList);
    _calculationController.setPreviousTotalPrice(totalValue.toString());
    update();
  }*/

  String initialPreviousTotalPrice(List<ProductDetailsbodies> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.unitPriceList != null) {
          double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
          //int qty = item.itemCount;
          int qty = (int.tryParse(item.punchedQty.toString()) ?? 0);
          int sq = (int.tryParse(item.sQ.toString()) ?? 0);
          totalValue += dlp * qty * sq;
        }
      }
    }
    printMe("Total Value : $totalValue");

    return totalValue.toStringAsFixed(2);
  }

  String getTotalOrderQTY() {
    List<ProductDetailsbodies> itemList = _orderDetailByIdController.productDetailsbodies ?? [];
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        //totalOrders += item.itemCount;
        totalOrders += int.tryParse(item.punchedQty.toString())!;
        printMe("Total order qty ; $totalOrders");
      }
    }

    String total = totalOrders.toString();
    return total;
  }

  updatePreviousQtyValue(int quantity, ProductDetailsbodies product) {
    List<ProductDetailsbodies> itemList = _orderDetailByIdController.productDetailsbodies ?? [];
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          item.punchedQty = int.tryParse(quantity.toString()).toString();
          item.itemCount = quantity;

          if (item.unitPriceList != null) {
            double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
            //item.totalPrice = dlp * item.itemCount;
            item.totalPrice = dlp * (int.tryParse(item.punchedQty.toString()) ?? 0);
          }
          break;
        }
      }
    }
    double totalValue = 0.0;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.unitPriceList != null) {
          double dlp = double.tryParse(item.unitPriceList.toString()) ?? 1.0;
          double sq = double.tryParse(item.sQ.toString()) ?? 1.0;
          int qty = item.itemCount;

          totalValue += dlp * qty * sq;
        }
      }
    }

    _calculationController.setSelectedPreviousListItems(itemList);
    _calculationController.setPreviousTotalPrice(totalValue.toString());
    update();
  }

  deletePreviousProductItem(ProductDetailsbodies product) {
    List<ProductDetailsbodies> itemList = _orderDetailByIdController.productDetailsbodies ?? [];
    printMe("Selected order detail list length : ${itemList.length}");
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          item.itemCount = 1;
          itemList.remove(item);
          update();
          break;
        }
      }
    }
    printMe("Selected order detail list length new : ${itemList.length}");
    _calculationController.setSelectedPreviousListItems(itemList);
    _calculationController.setPreviousTotalPrice(initialPreviousTotalPrice(itemList));

    update();
  }

  double calculateTotalUnitPrice(List<ProductDetailsbodies> productDetails) {
    for (int i = 0; i < productDetails.length; i++) {
      double unitPrice = double.parse(productDetails[i].unitPriceList.toString());
      totalUnitPrice += unitPrice;
    }
    _calculationController.setPreviousTotalPrice(initialPreviousTotalPrice(productDetails));

    update();
    return totalUnitPrice;
  }
}
