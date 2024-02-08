import 'package:get/get.dart';
import 'dart:convert';
import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/new_order_model/SubmitNewOrderResponse.dart';
import '../../models/responseModels/no_order_model/GetReasonsResponse.dart';

class NoOrderController extends GetxController {
  var base64;
  String fileName = '';
  var extension;
  String? selectedReason;

  List<String> reasonsList = [];

  GlobalController globalController = Get.put(GlobalController());

  getReasons() async {
    //Add loader
    // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getReasonsAPI().then((value) {
      Get.back();

      try {
        if (value != null) {
          reasonsList = value.items!;
          print("Reason list : ${reasonsList.length}");
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

  ///------------------------------------------------------------------------------------
  ///Submit no order api
  Future<SubmitNewOrderResponse?> submitNoOrder({
    required String reason,
    required String buName,
    required String customerCode,
    required String file,
    required String lattitude,
    required String longtitude,
    required String mimeType,
    required String remarks,
  }) async {
    try {
      // Add loader
      Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");

      // Call the API and wait for the response
      final value = await submitNoOrderApi(
        reason: reason,
        buName: buName,
        customerCode: customerCode,
        file: file,
        lattitude: lattitude,
        longtitude: longtitude,
        mimeType: mimeType,
        remarks: remarks,
      );

      Get.back();

      if (value != null) {
        return value;
      } else {
        Widgets().showToast("Data not found!");
        return null;
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return null;
    } finally {
      update();
    }
  }

  //TODO : add Response class model of submit no order api
  Future<SubmitNewOrderResponse?> submitNoOrderApi({
    required String reason,
    required String buName,
    required String customerCode,
    required String file,
    required String lattitude,
    required String longtitude,
    required String mimeType,
    required String remarks,
  }) {
    var map = {
      "Reason": reason,
      "buName": buName,
      "customerCode": customerCode,
      "file": file,
      "lattitude": lattitude,
      "longtitude": longtitude,
      "mimeType": mimeType,
      "remarks": remarks,
      "screenName": globalController.customerScreenName
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.submitNoOrder, requestJson).then((value) {
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

  //------------------------------------------------------------------
  getReasonData(String value) {
    selectedReason = value;
    update();
  }
}
