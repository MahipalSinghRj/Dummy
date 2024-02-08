import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../debug/printme.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/order_detail_model/OrderDetailsByIdResponse.dart';
import '../../models/responseModels/return_order_model/ReturnOrderbyIdResponse.dart';

class CalculationController extends GetxController {
  final selectedItemBox = GetStorage();

  ///================================================================================///

  //New order
  String get totalPrice => selectedItemBox.read('totalPrice') ?? "";

  //List<ProductByBUItems> get selectedProductListItems => selectedItemBox.read('selectedProductListItems') ?? [];

  // List<ProductByBUItems> get selectedProductListItems {
  //   final selectedItems = selectedItemBox.read('selectedProductListItems');
  //   return selectedItems != null && selectedItems.isNotEmpty ? selectedItems : [];
  // }

  List<ProductByBUItems> get selectedProductListItems {
    final selectedItems = selectedItemBox.read('selectedProductListItems') ?? [];

    if (selectedItemBox == null) {
      return [];
    } else if (selectedItems is List<ProductByBUItems>) {
      return selectedItems.isNotEmpty ? selectedItems : [];
    } else {
      return selectedItems != null && selectedItems.isNotEmpty ? List.castFrom(selectedItems.map((e) => ProductByBUItems.fromJson(e)).toList()) : [];
    }
  }

  setTotalPrice(String totalPrice) async {
    if (totalPrice.isNotEmpty) {
      await selectedItemBox.write('totalPrice', totalPrice);
      update();
    }
  }

  setSelectedListItems(List<ProductByBUItems> selectedListItems) async {
    printMe("Selected item length : ${selectedListItems.length}");
    if (selectedListItems.isNotEmpty) {
      await selectedItemBox.write('selectedProductListItems', selectedListItems);
    } else {
      await selectedItemBox.write('selectedProductListItems', []);
    }
    update();
  }

  String get cartItemCount => selectedProductListItems.length.toString();

  removeSelectedProductListItems({required String key}) async {
    await selectedItemBox.remove(key);
    update();
  }

  ///================================================================================///

  //Return order
  String get totalReturnPrice => selectedItemBox.read('totalReturnPrice') ?? "";

  //List<ReturnOrderByIdListData> get selectedReturnProductList => selectedItemBox.read('selectedReturnProductList') ?? [];

  List<ReturnOrderByIdListData> get selectedReturnProductList {
    final selectedItems = selectedItemBox.read('selectedReturnProductList');
    return selectedItems != null && selectedItems.isNotEmpty ? selectedItems : [];
  }

  setReturnTotalPrice(String totalReturnPrice) async {
    if (totalReturnPrice.isNotEmpty) {
      await selectedItemBox.write('totalReturnPrice', totalReturnPrice);

      update();
    }
  }

  setSelectedReturnListItems(List<ReturnOrderByIdListData> selectedReturnListItems) async {
    printMe("Selected item length : ${selectedReturnListItems.length}");
    if (selectedReturnListItems.isNotEmpty) {
      await selectedItemBox.write('selectedReturnProductList', selectedReturnListItems);
    }
    update();
  }

  String get returnCartItemCount => selectedReturnProductList.length.toString();

  ///====================================================================================

  //Previous order
  String get totalPreviousOrderPrice => selectedItemBox.read('totalPreviousOrderPrice') ?? "";
  List<ProductDetailsbodies> get selectedPreviousProductList => selectedItemBox.read('selectedPreviousProductList') ?? [];

  setPreviousTotalPrice(String totalPreviousPrice) async {
    if (totalPreviousPrice.isNotEmpty) {
      await selectedItemBox.write('totalPreviousOrderPrice', totalPreviousPrice);

      update();
    }
  }

  setSelectedPreviousListItems(List<ProductDetailsbodies> selectedPreviousListItems) async {
    printMe("Selected item length : ${selectedPreviousListItems.length}");
    if (selectedPreviousListItems.isNotEmpty) {
      await selectedItemBox.write('selectedPreviousProductList', selectedPreviousListItems);
    }
    update();
  }

  String get previousCartItemCount => selectedPreviousProductList.length.toString();
}
