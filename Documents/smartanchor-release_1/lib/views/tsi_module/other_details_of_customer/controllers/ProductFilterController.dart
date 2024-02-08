import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../primary_order_module/models/responseModels/new_order_model/DropdownFilterResponse.dart';
import '../models/ProductFilterResponse.dart';

class ProductFilterController extends GetxController {
  String? selectDivisionValue;
  String? selectCategoryValue;
  String? selectBrandValue;
  List<String> selectBrand = [];
  List<String> selectCategory = [];
  List<String> selectDivision = [];

  Future<bool?> productFilterApiFn({
    required String businessUnit,
    required String brand,
    required String category,
    required String division,
  }) async {
    try {
      // Add loader
      Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
      final value = await productFilterApi(brand: brand, businessUnit: businessUnit, category: category, division: division);
      Get.back();
      update();

      if (value != null) {
        selectDivision = value.division ?? [];
        selectCategory = value.category ?? [];
        selectBrand = value.brand ?? [];
        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        Get.back();
        return false;
      }
    } catch (e, stacktrace) {
      printErrors("Error: $e");
      printErrors("Stack trace Error: $stacktrace");
      Get.back();
      return null;
    }
  }

  Future<ProductFilterResponse?> productFilterApi({
    required String businessUnit,
    required String brand,
    required String category,
    required String division,
  }) {
    var map = {"brand": brand, "bu": businessUnit, "category": category, "division": division};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.productFilter, requestJson).then((value) {
      try {
        if (value != null) {
          ProductFilterResponse productFilterResponse = ProductFilterResponse.fromJson(value);
          return productFilterResponse;
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
