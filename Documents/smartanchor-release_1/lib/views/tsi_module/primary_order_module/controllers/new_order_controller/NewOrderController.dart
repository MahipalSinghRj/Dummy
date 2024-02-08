import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/DiscountPriceResponse.dart';
import '../../models/responseModels/new_order_model/DropdownFilterResponse.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/new_order_model/SubmitNewOrderResponse.dart';
import '../calculationController/CalculationController.dart';

class NewOrderController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  String? selectedBuValue;
  String? selectDivisionValue;
  String? selectCategoryValue;
  String? selectBrandValue;
  int currentPage = 1;
  int pageSize = 20;
  int totalCount = 0;
  int totalPages = 0;
  int totalPagesFocus = 0;
  final TextEditingController searchVariantController = TextEditingController();

  ///------------------------------------------------------------------------------------
  ///New order filter api
  List<ProductByBUItems> focusProductList = [];

  // focusedProduct({
  //   required String customerCode,
  //   required String selectBU,
  // }) async {
  //   //Add loader
  //   Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
  //   await focusedProductApi(
  //     customerCode: customerCode,
  //     selectBU: selectBU,
  //   ).then((value) {
  //     Get.back();
  //
  //     try {
  //       if (value != null) {
  //         focusProductList = value.productByBUItems ?? [];
  //       } else {
  //         Widgets().showToast("Data not found!");
  //       }
  //     } catch (e) {
  //       printErrors("Error: $e");
  //       Get.back();
  //     }
  //     Get.back();
  //     update();
  //   });
  // }
  //
  // Future<ProductByBUResponse?> focusedProductApi({
  //   required String selectBU,
  //   required String customerCode,
  // }) {
  //   //TODO : Add these map when data is coming properly
  //   var map1 = {
  //     "ScreenName": globalController.customerScreenName,
  //     "CustomerCode": customerCode,
  //     "selectBU": selectBU,
  //     "selectDivision": "",
  //     "selectCategory": "",
  //     "selectBrand": "",
  //     "page": 1,
  //     "pageSize": 1
  //   };
  //
  //   var map = {
  //     "BU": selectBU,
  //     "customerCode": customerCode,
  //     "end": 5,
  //     "productMasterSearchContext": {
  //       "productFilter_category": "",
  //       "productFilter_colorMake": "",
  //       "productFilter_division": "",
  //       "productFilter_productType": "",
  //       "productFilter_specificatonRating": "",
  //       "productFilter_subBrand": ""
  //     },
  //     "start": 0
  //   };
  //
  //   var requestJson = jsonEncode(map);
  //
  //   return ApiService.postRequest(ApiConstants.focusedProduct, requestJson).then((value) {
  //     try {
  //       if (value != null) {
  //         ProductByBUResponse productByBUResponse = ProductByBUResponse.fromJson(value);
  //         return productByBUResponse;
  //       } else {
  //         return null;
  //       }
  //     } catch (exception, stackTrace) {
  //       printErrors("ExceptionHandling at parsing  api request : $exception");
  //       printErrors("Stacktrace : ");
  //       printErrors(stackTrace);
  //
  //       return null;
  //     }
  //   }, onError: (e) {
  //     return null;
  //   });
  // }

  focusedProduct({
    required String customerCode,
    required String selectBU,
  }) async {
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await focusedProductApi(
      customerCode: customerCode,
      selectBU: selectBU,
    ).then((value) {
      Get.back();
      try {
        if (value != null) {
          if (currentPage == 1) {
            focusProductList = value.productByBUItems ?? [];

            if (focusProductList.isNotEmpty) {
              totalCount = int.tryParse(focusProductList.first.totalsize.toString()) ?? 0;
              if (totalCount % pageSize == 0) {
                totalPagesFocus = (totalCount / pageSize).toInt();
              } else {
                totalPagesFocus = (totalCount / pageSize).toInt() + 1;
              }
            }
          } else {
            focusProductList.addAll(value.productByBUItems ?? []);
          }

          update();
          return true;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      Get.back();
      update();
    });
  }

  Future<ProductByBUResponse?> focusedProductApi({
    required String selectBU,
    required String customerCode,
  }) {
    var map = {
      "BU": selectBU,
      "customerCode": customerCode,
      "end": currentPage * pageSize,
      "productMasterSearchContext": {
        "productFilter_category": "",
        "productFilter_colorMake": "",
        "productFilter_division": "",
        "productFilter_productType": "",
        "productFilter_specificatonRating": "",
        "productFilter_subBrand": ""
      },
      "start": (currentPage - 1) * pageSize
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.focusedProduct, requestJson).then((value) {
      try {
        if (value != null) {
          ProductByBUResponse productByBUResponse = ProductByBUResponse.fromJson(value);
          return productByBUResponse;
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

  ///New api of New order filter
  ///New order filter api
  List<String>? selectBrand = [];
  List<String>? selectCategory = [];
  List<String>? selectDivision = [];

  Future<bool?> dropdownFilter() async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await dropdownFilterApi().then((value) {
      Get.back();
      try {
        if (value != null) {
          selectBrand = value.selectBrand ?? [];
          selectCategory = value.selectCategory ?? [];
          selectDivision = value.selectDivision ?? [];
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
    return null;
  }

  Future<DropdownFilterResponse?> dropdownFilterApi() {
    var map = {"userScreenName": globalController.customerScreenName};
    //var map = {"userScreenName": "a06247"};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.dropdownFilter, requestJson).then((value) {
      try {
        if (value != null) {
          DropdownFilterResponse dropdownFilterResponse = DropdownFilterResponse.fromJson(value);
          return dropdownFilterResponse;
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

  //--------------------------------------------------------------------------------------------
  ///Product By Bu api
  List<ProductByBUItems> productByBUItems = [];

  Future<bool?> productByBU({
    required String bu,
    required String customerCode,
    required int end,
    required int start,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    try {
      var value = await productByBUApi(
        bu: bu,
        customerCode: customerCode,
        division: selectDivisionValue ?? '',
        category: selectCategoryValue ?? '',
        subBrand: selectBrandValue ?? '',
        start: start,
        end: end,
      );

      Get.back();

      if (value != null) {
        if (currentPage == 1) {
          productByBUItems = value.productByBUItems ?? [];

          if (productByBUItems.isNotEmpty) {
            totalCount = int.tryParse(productByBUItems.first.totalsize.toString()) ?? 0;
            if (totalCount % pageSize == 0) {
              totalPages = (totalCount / pageSize).toInt();
            } else {
              totalPages = (totalCount / pageSize).toInt() + 1;
            }
          }
        } else {
          productByBUItems.addAll(value.productByBUItems ?? []);
        }

        update();
        return true;
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
    }
    update();
    return null;
  }

  //=================================================================================
  Future<ProductByBUResponse?> productByBUApi({
    required String bu,
    required String customerCode,
    required String division,
    required String category,
    required String subBrand,
    required int end,
    required int start,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "BU": bu,
      "customerCode": customerCode,
      "end": end,
      "start": start,
      "productMasterSearchContext": {
        "productFilter_division": division,
        "productFilter_category": category,
        "productFilter_subBrand": subBrand,
        "productFilter_productType": "",
        "productFilter_specificatonRating": "",
        "productFilter_colorMake": ""
      }
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.productByBU, requestJson).then((value) {
      try {
        if (value != null) {
          ProductByBUResponse productByBUResponse = ProductByBUResponse.fromJson(value);
          return productByBUResponse;
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

  //=====================================================

  // List<ProductByBUItems> productByBUItemsFilter = [];
  //
  // Future<bool?> productByBUFilter({
  //   required String bu,
  //   required String customerCode,
  //   required String division,
  //   required String category,
  //   required String subBrand,
  //   required BuildContext context,
  //   required int end,
  //   required int start,
  // }) async {
  //   productByBUItems = [];
  //
  //   try {
  //     // Add loader
  //     Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
  //     // Call the API and wait for the response
  //     final value = await productByBUApi(
  //       bu: bu,
  //       customerCode: customerCode,
  //       division: selectDivisionValue ?? '',
  //       category: selectCategoryValue ?? '',
  //       subBrand: selectBrandValue ?? '',
  //       start: start,
  //       end: end,
  //     );
  //
  //     if (value != null) {
  //       Get.back();
  //       productByBUItems = value.productByBUItems ?? [];
  //       update();
  //       return true;
  //     } else {
  //       Widgets().showToast("Data not found!");
  //       return false;
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     printErrors("Error: $e");
  //     Widgets().showToast("An error occurred while fetching data.");
  //   }
  //
  //   update();
  //   return false;
  // }

  Future<SubmitNewOrderResponse?> submitNewOrder({
    required Map submitDetailsMap,
  }) async {
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");

    try {
      var value = await submitNewOrderApi(submitDetailsMap: submitDetailsMap);

      if (value != null) {
        Get.back();
        return value;
      } else {
        Widgets().showToast("Submit order Data not found!");
      }
    } catch (e) {
      printErrors("Error: $e");
      Widgets().showToast("Something went wrong.");
    }

    Get.back();
    return null;
  }

  Future<SubmitNewOrderResponse?> submitNewOrderApi({
    required Map submitDetailsMap,
  }) {
    var map = submitDetailsMap;
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.submitNewOrder, requestJson).then((value) {
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

  //--------------------------------------------------------------------------------
  CalculationController _calculationController = Get.put(CalculationController());

  List<ProductByBUItems> selectedDataList = [];

  int calculateTotalQty(List<ProductByBUItems> items) {
    int total = 0;
    for (ProductByBUItems item in items) {
      if (item.itemCount != null) {
        total = (total + item.itemCount);
      }
    }
    return total;
  }

// take a bool that is initially true for the new order navigation but when first item selected it
// will become false and rest of the function will work properly
  bool isProductSelected(ProductByBUItems product) {
    bool isSelected = false;

    List<ProductByBUItems> itemList = _calculationController.selectedProductListItems;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          isSelected = true;
        }
      }
    }
    return isSelected;
  }

  updateProductSelection(ProductByBUItems product, bool isProductSelected) {
    //update calculation -list

    List<ProductByBUItems> itemList = _calculationController.selectedProductListItems;
    if (isProductSelected) {
      //for selection
      if (itemList.isEmpty) {
        itemList.add(product);
      } else {
        bool canBeAdded = true;

        for (var item in itemList) {
          if (item.productMasterId == product.productMasterId) {
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
          if (item.productMasterId == product.productMasterId) {
            item.itemCount = 1;
            itemList.remove(item);
            break;
          }
        }
      }
    }

    _calculationController.setSelectedListItems(itemList);
    _calculationController.setTotalPrice(initialTotalPrice(itemList));
    update();
  }

  String initialTotalPrice(List<ProductByBUItems> itemList) {
    double totalValue = 0.0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.dLP != null) {
          double dlp = double.tryParse(item.dLP.toString()) ?? 1.0;
          int qty = item.itemCount;
          //int sq = int.parse(item.sQ ?? "0");
          int sq = int.tryParse(item.sQ ?? "0") ?? 0;

          printMe("SQ : ${item.sQ}");

          totalValue += dlp * qty * sq;
        }
      }
    }
    printMe("Total Value : ${totalValue.toStringAsFixed(2)}");

    return totalValue.toStringAsFixed(2);
  }

  updateQtyValue(int quantity, ProductByBUItems product) {
    List<ProductByBUItems> itemList = _calculationController.selectedProductListItems;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          item.itemCount = quantity;

          if (item.dLP != null) {
            double dlp = double.tryParse(item.dLP.toString()) ?? 1.0;
            double sq = double.tryParse(item.sQ.toString()) ?? 1.0;
            item.totalPrice = dlp * item.itemCount * sq;
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
          double sq = double.tryParse(item.sQ.toString()) ?? 1.0;
          totalValue += dlp * qty * sq;
        }
      }
    }

    _calculationController.setSelectedListItems(itemList);
    _calculationController.setTotalPrice(totalValue.toStringAsFixed(2));
    update();
  }

  String getTotalOrderQTY() {
    List<ProductByBUItems> itemList = _calculationController.selectedProductListItems;
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += item.itemCount;
      }
    }

    String total = totalOrders.toString();
    return total;
  }

  deleteProductItem(ProductByBUItems product) {
    List<ProductByBUItems> itemList = _calculationController.selectedProductListItems;
    printMe(itemList.length);
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.productMasterId == product.productMasterId) {
          item.itemCount = 1;
          itemList.remove(item);
          break;
        }
      }
    }
    printMe(itemList.length);

    _calculationController.setSelectedListItems(itemList);
    _calculationController.setTotalPrice(initialTotalPrice(itemList));

    update();
  }

  //=====================================================================
  selectDivisionFn(String selectDivision, String value) {
    selectDivision = value;
    update();
  }

  Future<DiscountPriceResponse?> getDiscountPrice({
    required String cartid,
  }) async {
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");

    try {
      var value = await getDiscountPriceApi(cartid: cartid);

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

  Future<DiscountPriceResponse?> getDiscountPriceApi({
    required String cartid,
  }) {
    var map = {"cartid": cartid};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.discountnTaxOrderValue, requestJson).then((value) {
      try {
        if (value != null) {
          DiscountPriceResponse response = DiscountPriceResponse.fromJson(value);
          printMe("Value : $value");
          return response;
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

  ///================================================================

  //New order search product

  List<ProductByBUItems> productSearchItemList = [];

  productSearch({
    required String buName,
    required String customerCode,
    required String searchString,
  }) async {
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");

    try {
      var value = await productSearchApi(buName: buName, customerCode: customerCode, searchString: searchString);

      if (value != null) {
        Get.back();
        productSearchItemList = [];
        productSearchItemList = value.productByBUItems ?? [];
        update();
        return productSearchItemList;
      } else {
        Widgets().showToast("Data not found!");
      }
    } catch (e) {
      printErrors("Error: $e");
      Widgets().showToast("Something went wrong.");
    }
    update();

    Get.back();
    return null;
  }

  Future<ProductByBUResponse?> productSearchApi({
    required String buName,
    required String customerCode,
    required String searchString,
  }) {
    var map = {
      "BuName": buName,
      "customerCode": customerCode,
      "searchString": searchString,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.ProductSearch, requestJson).then((value) {
      try {
        if (value != null) {
          ProductByBUResponse productSearchResponse = ProductByBUResponse.fromJson(value);
          return productSearchResponse;
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

  ///Load more data when reaching the end
  void loadMoreData({
    required String bu,
    required String customerCode,
    required int selectedIndex,
  }) {
    if (currentPage < (selectedIndex == 0 ? totalPages : totalPagesFocus)) {
      currentPage++;
      printMe("Current page : $currentPage");
      printMe("Total page : $totalPages");
      if (selectedIndex == 0) {
        productByBU(
          bu: bu,
          customerCode: customerCode,
          start: (currentPage - 1) * pageSize,
          end: currentPage * pageSize,
        );
        update();
      } else {
        focusedProduct(customerCode: customerCode, selectBU: bu);
        update();
      }
    } else {
      Widgets().showToast("No more data");
    }
  }
}
