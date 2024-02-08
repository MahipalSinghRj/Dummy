import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_new-order_model/ProductDetailListResponse.dart';
import '../retailer_calculation_controller/RetailerCalculationController.dart';

class RetailerNewOrderControllerSec extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  RetailerCalculationController _retailerCalculationController = Get.put(RetailerCalculationController());
  List<ProductLists> productLists = [];
  List<ProductLists> focusProductLists = [];
  String? selectDivision;
  String? selectCategory;
  String? selectBrand;
  List<String> selectDivisionList = [];
  List<String> selectCategoryList = [];
  List<String> selectBrandList = [];
  List<ProductLists> selectedDataList = [];
  List<String> yesRetailerSelectProduct = [];
  List<String> noRetailerSelectProduct = [];
  String totalProductCount = '0';
  int currentPage = 1;
  int lastPage = 0;
  int pageSize = 10;
  bool isLoading = false;
  final TextEditingController searchVariantController = TextEditingController();
  int totalCount = 0;
  int totalPages = 0;
  int totalPagesFocus = 0;

  ///Product Detail List Api
  Future<ProductDetailListResponse?> productDetailListFn({
    required String category,
    required String division,
    required int pageNumber,
    required int pageSize,
    required String retailerCode,
    required String subBrand,
    required String searchKey,
    required bool isFocus,
  }) async {
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    isLoading = true;
    update();
    try {
      final value = await productDetailListApi(
          category: category,
          division: division,
          pageNumber: pageNumber,
          pageSize: pageSize,
          retailerCode: retailerCode,
          subBrand: subBrand,
          searchKey: searchKey,
          isFocus: isFocus);

      if (value != null) {
        //Get.back();
        int totalCount = int.tryParse(value.totalProductQuantity.toString()) ?? 0;
        int lastPageNo = 0;
        if (pageSize == 0) {
          lastPageNo = 0;
        } else {
          if (totalCount % pageSize == 0) {
            lastPageNo = (totalCount / pageSize).toInt();
          } else {
            lastPageNo = (totalCount / pageSize).toInt() + 1;
          }
        }

        lastPage = lastPageNo;
        if (isFocus) {
          totalPagesFocus = lastPage;
          //focusProductLists = value.productLists ?? [];
          if (currentPage > 1) {
            focusProductLists.addAll(value.productLists ?? []);
            update();
          } else {
            focusProductLists = value.productLists ?? [];
            update();
          }
        } else {
          totalPages = lastPage;
          if (currentPage > 1) {
            productLists.addAll(value.productLists ?? []);
          } else {
            productLists = value.productLists ?? [];
          }
        }
        selectDivisionList = value.divisionList ?? [];
        selectCategoryList = value.categoryList ?? [];
        selectBrandList = value.brandList ?? [];
        isLoading = false;
        update();
        return value;
      } else {
        Widgets().showToast("Data not found!");
        isLoading = false;
        update();
        return null;
      }
    } catch (e, stackTrace) {
      printErrors("Error: $e");
      printErrors(stackTrace);
      Widgets().showToast("An error occurred while fetching data.");
    }

    isLoading = false;
    update();
    return null;
  }

  Future<ProductDetailListResponse?> productDetailListApi({
    required String category,
    required String division,
    required int pageNumber,
    required int pageSize,
    required String retailerCode,
    required String subBrand,
    required String searchKey,
    required bool isFocus,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "category": category,
      "division": division,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "retailerCode": retailerCode,
      //TODO : Add role with name like : "role": globalController.role.name,
      "role": globalController.role,
      "screenName": globalController.customerScreenName,
      "subBrand": subBrand,
      "searchKey": searchKey,
    };

    var requestJson = jsonEncode(map);

    var url = '';
    if (isFocus) {
      url = ApiConstants.focusProductDetails;
    } else {
      url = ApiConstants.productDetailList;
    }

    return ApiService.postRequest(url, requestJson).then((value) {
      try {
        if (value != null) {
          ProductDetailListResponse productDetailListResponse = ProductDetailListResponse.fromJson(value);
          return productDetailListResponse;
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

  ///Calculation part of select product

  bool isProductSelected(
    ProductLists product,
  ) {
    bool isSelected = false;

    List<ProductLists> itemList = _retailerCalculationController.selectedRetailerProductListItems;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == product.skuCode) {
          isSelected = true;
        }
      }
    }
    return isSelected;
  }

  updateProductSelection(ProductLists product, bool isProductSelected) {
    //update calculation -list
    List<ProductLists> itemList = _retailerCalculationController.selectedRetailerProductListItems;
    if (isProductSelected) {
      //for selection
      if (itemList.isEmpty) {
        itemList.add(product);
      } else {
        bool canBeAdded = true;

        for (var item in itemList) {
          if (item.skuCode == product.skuCode) {
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
          if (item.skuCode == product.skuCode) {
            item.itemCount = 1;
            itemList.remove(item);
            break;
          }
        }
      }
    }

    _retailerCalculationController.setSelectedListItems(itemList);
    _retailerCalculationController.setTotalPrice(initialTotalPrice(itemList));
    update();
  }

  String initialTotalPrice(List<ProductLists> itemList) {
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
    update();
    return totalValue.toStringAsFixed(2);
  }

  deleteProductItem(ProductLists product) {
    List<ProductLists> itemList = _retailerCalculationController.selectedRetailerProductListItems;
    printMe(itemList.length);
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == product.skuCode) {
          item.itemCount = 1;
          itemList.remove(item);
          break;
        }
      }
    }
    printMe(itemList.length);

    _retailerCalculationController.setSelectedListItems(itemList);
    _retailerCalculationController.setTotalPrice(initialTotalPrice(itemList));

    update();
  }

  updateQtyValue(int quantity, ProductLists product) {
    List<ProductLists> itemList = _retailerCalculationController.selectedRetailerProductListItems;
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

    _retailerCalculationController.setSelectedListItems(itemList);
    _retailerCalculationController.setTotalPrice(totalValue.toString());
    update();
  }

  int calculateTotalQty(List<ProductLists> items) {
    int total = 0;
    for (ProductLists item in items) {
      if (item.itemCount != null) {
        total = (total + item.itemCount);
      }
    }
    return total;
  }

  String getTotalOrderQTY() {
    List<ProductLists> itemList = _retailerCalculationController.selectedRetailerProductListItems;
    int totalOrders = 0;
    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        totalOrders += item.itemCount;
      }
    }

    String total = totalOrders.toString();
    return total;
  }

  //Function to load more data when scrolling reaches the end
  ///Load more data when reaching the end
  // void loadMoreData({
  //   required String category,
  //   required String division,
  //   required int pageNumber,
  //   required int pageSize,
  //   required String retailerCode,
  //   required String subBrand,
  //   required bool isFocus,
  // }) {
  //   if (currentPage < lastPage) {
  //     currentPage++;
  //     productDetailListFn(
  //       division: division,
  //       pageNumber: currentPage,
  //       pageSize: pageSize,
  //       retailerCode: retailerCode,
  //       subBrand: subBrand,
  //       searchKey: searchVariantController.text,
  //       isFocus: isFocus,
  //       category: category,
  //     );
  //   } else {
  //     Widgets().showToast("No more data");
  //   }
  // }

  void loadMoreData({
    required String category,
    required String division,
    required int pageNumber,
    required int pageSize,
    required String retailerCode,
    required String subBrand,
    // required bool isFocus,
    required int selectedIndex,
  }) {
    if (currentPage < (selectedIndex == 0 ? totalPages : totalPagesFocus)) {
      currentPage++;
      printMe("Current page : $currentPage");
      printMe("Total page : $totalPages");
      if (selectedIndex == 0) {
        productDetailListFn(
          division: division,
          pageNumber: currentPage,
          pageSize: pageSize,
          retailerCode: retailerCode,
          subBrand: subBrand,
          searchKey: searchVariantController.text,
          isFocus: false,
          category: category,
        );
        update();
      } else {
        productDetailListFn(
          division: division,
          pageNumber: currentPage,
          pageSize: pageSize,
          retailerCode: retailerCode,
          subBrand: subBrand,
          searchKey: searchVariantController.text,
          isFocus: true,
          category: category,
        );
        update();
      }
    } else {
      Widgets().showToast("No more data");
    }
  }

/*
  ///For focus product
  bool isFocusProductSelected(FocusedProductLists focusedProductLists) {
    bool isSelected = false;

    List<FocusedProductLists> itemList = _retailerCalculationController.selectedFocusProductListItems;

    if (itemList.isNotEmpty) {
      for (var item in itemList) {
        if (item.skuCode == focusedProductLists.skuCode) {
          isSelected = true;
        }
      }
    }
    return isSelected;
  }

  updateFocusProductSelection(FocusedProductLists focusedProductLists, bool isProductSelected) {
    //update calculation -list
    List<FocusedProductLists> itemList = _retailerCalculationController.selectedFocusProductListItems;
    if (isProductSelected) {
      //for selection
      if (itemList.isEmpty) {
        itemList.add(focusedProductLists);
      } else {
        bool canBeAdded = true;

        for (var item in itemList) {
          if (item.skuCode == focusedProductLists.skuCode) {
            canBeAdded = false;
          }
        }

        if (canBeAdded) {
          itemList.add(focusedProductLists);
        }
      }
    } else {
      //for deselection

      if (itemList.isNotEmpty) {
        for (var item in itemList) {
          if (item.skuCode == focusedProductLists.skuCode) {
            item.itemCount = 1;
            itemList.remove(item);
            break;
          }
        }
      }
    }

    _retailerCalculationController.setSelectedFocusListItems(itemList);
    _retailerCalculationController.setFocusTotalPrice(initialFocusTotalPrice(itemList));
    update();
  }

  String initialFocusTotalPrice(List<FocusedProductLists> itemList) {
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
    update();
    return totalValue.toString();
  }*/
}
