import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../debug/printme.dart';
import '../../models/responseModels/retailer_new-order_model/ProductDetailListResponse.dart';
import '../../models/responseModels/retailer_previous_order_model/ViewPreviousOrderResponse.dart';

class RetailerCalculationController extends GetxController {
  final selectedItemBox = GetStorage();

  //Retailer New order
  ///This is getter to get total price of item in UI
  String get totalPrice => selectedItemBox.read('totalPrice') ?? "";

  ///This is getter to save initial item when we select first time
  // List<ProductLists> get selectedRetailerProductListItems {
  //   final selectedItems = selectedItemBox.read('selectedRetailerProductListItems');
  //   return selectedItems != null && selectedItems.isNotEmpty ? selectedItems : [];
  // }

  List<ProductLists> get selectedRetailerProductListItems {
    final selectedItems = selectedItemBox.read('selectedRetailerProductListItems') ?? [];

    if (selectedItems == null) {
      return [];
    } else if (selectedItems is List<ProductLists>) {
      return selectedItems.isNotEmpty ? selectedItems : [];
    } else {
      return selectedItems != null && selectedItems.isNotEmpty ? List.castFrom(selectedItems.map((e) => ProductLists.fromJson(e)).toList()) : [];
    }
  }

  ///This is setter to save total price globally
  setTotalPrice(String totalPrice) async {
    if (totalPrice.isNotEmpty) {
      await selectedItemBox.write('totalPrice', totalPrice);
      update();
    }
  }

  ///This function saves selected item
  ///Its takes a list in arguments
  setSelectedListItems(List<ProductLists> selectedListItems) async {
    printMe("Selected item length : ${selectedListItems.length}");
    if (selectedListItems.isNotEmpty) {
      await selectedItemBox.write('selectedRetailerProductListItems', selectedListItems);
    } else {
      await selectedItemBox.write('selectedRetailerProductListItems', []);
    }
    update();
  }

  ///This is getter function to save all the available items in cart
  String get cartItemCount => selectedRetailerProductListItems.length.toString();

  ///This function takes a key and remove all the saved item locally
  removeSelectedProductListItems({required String key}) async {
    await selectedItemBox.remove(key);
    update();
  }

  //Retailer Previous order
  ///This is getter to get total price of item in UI
  String get totalPreviousOrderPrice => selectedItemBox.read('totalPreviousOrderPrice') ?? "";

  ///This is getter to save initial item when we select first time
  List<OrderDetailProductList> get selectedPreviousProductListOD => selectedItemBox.read('selectedPreviousProductListOD') ?? [];

  ///This is setter to save total price globally
  setPreviousTotalPrice(String totalPreviousOrderPrice) async {
    if (totalPreviousOrderPrice.isNotEmpty) {
      await selectedItemBox.write('totalPreviousOrderPrice', totalPreviousOrderPrice);

      update();
    }
  }

  ///This function saves selected item
  ///Its takes a list in arguments
  setSelectedPreviousListItems(List<OrderDetailProductList> selectedPreviousListItems) async {
    printMe("Selected item length : ${selectedPreviousListItems.length}");
    if (selectedPreviousListItems.isNotEmpty) {
      await selectedItemBox.write('selectedPreviousProductListOD', selectedPreviousListItems);
    }
    update();
  }

  ///This function takes a key and remove all the saved item locally
  removePreviousSelectedProductList({required String key}) async {
    await selectedItemBox.remove(key);
    update();
  }
}
