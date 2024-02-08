import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/models/responseModels/preview_order_model/GetProductCategoryResponse.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/no_order_model/GetReasonsResponse.dart';

class PreviewOrderController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  RxBool isBottomSheetClosed = false.obs;

  ///------------------------------------------------------------------------------------------------
  ///Get Product Category api & Select info
  List<GetProductCategoryList> getProductCategoryListItems = [];
  List<GetProductCategoryList> selectedValues = [];
  String? itemName;
  String? sfaProductUploadId;
  String fileName = '';
  var base64;
  var base64Sign;
  var extension;
  List<String> reasonsList = [];
  String? selectedReason;
  String? selectedShipmentPriority;
  List<String> shipmentValueList = ["High", "Medium", "Low"];

  int dealerBoardGroupValue = 0;
  int pSampleBoardGroupValue = 0;

  List<String> yesRetailerSelectProduct = [];
  List<String> noRetailerSelectProduct = [];

  updateSelectedValuesList(int index, int groupValue, String sfaProductUploadId) {
    for (int i = 0; i < selectedValues.length; i++) {
      if (i == index) {
        selectedValues[i].groupValue = groupValue;
        printMe("SFA id : $sfaProductUploadId");
        printMe("Selected group value is : ${selectedValues[i].groupValue}");
      }
    }
    update();
  }

  Future<List<GetProductCategoryList?>> getProductCategory({
    required String businessUnit,
  }) async {
    // Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    try {
      final value = await getProductCategoryApi(businessUnit: businessUnit);
      Get.back();
      if (value != null) {
        getProductCategoryListItems = value.getProductCategoryList ?? [];
        selectedValues = value.getProductCategoryList ?? [];
        printMe("Get Product Category List Items : $getProductCategoryListItems");
        return getProductCategoryListItems;
      } else {
        Widgets().showToast("Data not found!");
        return getProductCategoryListItems;
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
    }
    //Get.back();
    update();
    return getProductCategoryListItems;
  }

  Future<GetProductCategoryResponse?> getProductCategoryApi({
    required String businessUnit,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"bu": businessUnit};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getProductCategory, requestJson).then((value) {
      try {
        if (value != null) {
          GetProductCategoryResponse getProductCategoryResponse = GetProductCategoryResponse.fromJson(value);
          return getProductCategoryResponse;
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

//-----------------------------------------------------------------------------------

  getReasons() async {
    // Add loader
    // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await getReasonsAPI().then((value) {
      Get.back();

      try {
        if (value != null) {
          reasonsList = value.items?.toSet().toList() ?? [];
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

  Future<GetReasonsResponse?> getReasonsAPI() {
    //TODO : Add these map when data is coming properly

    return ApiService.getRequest(ApiConstants.getReasons).then((value) {
      try {
        if (value != null) {
          GetReasonsResponse getReasonsResponse = GetReasonsResponse.fromJson(value);
          return getReasonsResponse;
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

  getReasonsData(String value) {
    selectedReason = value;
    update();
  }

  getShipmentData(String value) {
    selectedShipmentPriority = value;
    update();
  }
}
