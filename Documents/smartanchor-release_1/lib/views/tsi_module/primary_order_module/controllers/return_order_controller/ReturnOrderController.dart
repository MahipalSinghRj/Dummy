import 'dart:convert';
import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/new_order_model/SubmitNewOrderResponse.dart';
import '../../models/responseModels/return_order_model/ReturnOrderWithDropDownResponse.dart';
import '../../models/responseModels/return_order_model/ReturnOrderbyIdResponse.dart';

class ReturnOrderController extends GetxController {
  CalculationController _calculationController = Get.put(CalculationController());
  List<String> categoriesList = [];
  List<String> subcategoriesList = [];
  List<ReturnOrderByIdListData> productsList = [];
  List<ReturnOrderByIdListData> newProductsList = [];
  int dealerBoardGroupValue = 0;
  int pSampleBoardGroupValue = 0;

  ///Return Orders with dropdowns

  getReturnOrdersWithDropdown() async {
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getReturnOrdersWithDropdownApi().then((value) {
      Get.back();

      try {
        if (value != null) {
          categoriesList = value.catgeory!;
          subcategoriesList = value.subBrand!;
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }

      update();
    });
  }

  Future<GetReturnOrderwithDropDownResponse?> getReturnOrdersWithDropdownApi() {
    //TODO : Add these map when data is coming properly

    return ApiService.postRequest(ApiConstants.returnOrdersWithDropDown, '').then((value) {
      try {
        if (value != null) {
          GetReturnOrderwithDropDownResponse getReturnOrderwithDropDownResponse = GetReturnOrderwithDropDownResponse.fromJson(value);
          return getReturnOrderwithDropDownResponse;
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

  ///------------------------------------------------------------------------------------
  ///Return Order By Id api
  returnOrderById({
    required String customerCode,
    required String buName,
    required String category,
    required String subBrand,
  }) async {
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await returnOrderByIdApi(
      customerCode: customerCode,
      buName: buName,
      category: category,
      subBrand: subBrand,
    ).then((value) {
      //Get.back();

      try {
        if (value != null) {
          productsList = [];
          productsList = value.returnOrderByIdListData!;
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }

      update();
    });
  }

  Future<ReturnOrderByIdResponse?> returnOrderByIdApi({required String customerCode, required String buName, required String category, required String subBrand}) {
    //TODO : Add these map when data is coming properly

    var map = {"CustomerCode": customerCode, "buName": buName, "SubBrand": subBrand, "Category": category};
    //var map = {"CustomerCode": "1211114", "buName": buName, "SubBrand": subBrand, "Category": category};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.returnOrderbyid, requestJson).then((value) {
      try {
        if (value != null) {
          ReturnOrderByIdResponse returnOrderByIdResponse = ReturnOrderByIdResponse.fromJson(value);
          return returnOrderByIdResponse;
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

  Future<SubmitNewOrderResponse?> submitReturnOrder({
    required Map submitDetailsMap,
  }) async {
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");

    try {
      var value = await submitReturnOrderApi(submitDetailsMap: submitDetailsMap);
      if (value != null) {
        Get.back();
        return value;
      } else {
        Widgets().showToast("Data not found!");
      }
    } catch (e) {
      printErrors("Error: $e");
      Widgets().showToast("Something went wrong.");
    }

    Get.back();
    return null;
  }

  Future<SubmitNewOrderResponse?> submitReturnOrderApi({
    required Map submitDetailsMap,
  }) {
    var map = submitDetailsMap;
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.submitReturnOrder, requestJson).then((value) {
      try {
        if (value != null) {
          SubmitNewOrderResponse submitNewOrderResponse = SubmitNewOrderResponse.fromJson(value);
          return submitNewOrderResponse;
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

  //==================================================================
  //Select product

  int calculateReturnTotalQty(List<ReturnOrderByIdListData> items) {
    int total = 0;
    for (ReturnOrderByIdListData item in items) {
      if (item.itemCount != null) {
        total = (total + item.itemCount);
      }
    }
    return total;
  }

  bool isReturnProductSelected(ReturnOrderByIdListData product) {
    bool isSelected = false;

    List<ReturnOrderByIdListData> itemList = _calculationController.selectedReturnProductList;

    if (itemList.isNotEmpty) {
      printMe("Is selected : ${product.isSelected}");
      for (var item in itemList) {
        if (item.sKUCode == product.sKUCode) {
          isSelected = true;
        }
      }
    }
    return isSelected;
  }

  updateProductSelection(ReturnOrderByIdListData product, bool isProductSelected) {
    List<ReturnOrderByIdListData> itemList = _calculationController.selectedReturnProductList;

    if (isProductSelected) {
      if (itemList.isEmpty) {
        itemList.add(product);
      } else {
        bool canBeAdded = true;

        for (var item in itemList) {
          if (item.sKUCode == product.sKUCode) {
            canBeAdded = false;
          }
        }

        if (canBeAdded) {
          itemList.add(product);
        }
      }
    } else {
      //for deselection

      if (itemList.isNotEmpty) {
        for (var item in itemList) {
          if (item.sKUCode == product.sKUCode) {
            item.itemCount = 1;
            itemList.remove(item);
            break;
          }
        }
      }
    }

    _calculationController.setSelectedReturnListItems(itemList);
    _calculationController.setReturnTotalPrice(initialTotalPrice(itemList));
    update();
  }

  String initialTotalPrice(List<ReturnOrderByIdListData> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.dLP != null) {
          double dlp = double.tryParse(item.dLP.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }
    printMe("Total Value : $totalValue");

    return totalValue.toString();
  }

  updateReturnQtyValue(int quantity, ReturnOrderByIdListData product) {
    List<ReturnOrderByIdListData> itemList = _calculationController.selectedReturnProductList;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.sKUCode == product.sKUCode) {
          item.itemCount = quantity;

          if (item.dLP != null) {
            double dlp = double.tryParse(item.dLP.toString() ?? '1.0 ') ?? 1.0;
            item.totalPrice = dlp * item.itemCount;
          }
          break;
        }
      }
    }
    double totalValue = 0.0;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.dLP != null) {
          double dlp = double.tryParse(item.dLP.toString()) ?? 1.0;
          int qty = item.itemCount;
          totalValue += dlp * qty;
        }
      }
    }

    _calculationController.setSelectedReturnListItems(itemList);
    _calculationController.setReturnTotalPrice(totalValue.toString());
    update();
  }

  String getReturnTotalOrderQTY() {
    List<ReturnOrderByIdListData> itemList = _calculationController.selectedReturnProductList;
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += item.itemCount;
      }
    }

    String total = totalOrders.toString();
    return total;
  }

  deleteReturnProductItem(ReturnOrderByIdListData product) {
    List<ReturnOrderByIdListData> itemList = _calculationController.selectedReturnProductList;
    printMe(itemList.length);
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.sKUCode == product.sKUCode) {
          item.itemCount = 1;
          itemList.remove(item);
          break;
        }
      }
    }
    printMe(itemList.length);

    _calculationController.setSelectedReturnListItems(itemList);
    _calculationController.setReturnTotalPrice(initialTotalPrice(itemList));

    update();
  }
}
