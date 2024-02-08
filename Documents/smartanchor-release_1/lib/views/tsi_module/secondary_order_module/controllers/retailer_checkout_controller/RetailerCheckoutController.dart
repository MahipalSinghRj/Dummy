import 'dart:convert';

import 'package:get/get.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_checkout_model/SaveOrderResponse.dart';

class RetailerCheckOutController extends GetxController {
  ///Get Retailer checkout save order api
  Future<SaveOrderResponse?> saveOrderFn({
    required Map submitDetailsMap,
  }) async {
    try {
      final response = await saveOrderApi(submitDetailsMap: submitDetailsMap);

      if (response != null) {
        printMe("Value is older : ${response.message}");
        return response;
      } else {
        Widgets().showToast("Data not found!");
        return null;
      }
    } catch (e) {
      printErrors("Error: $e");
    }

    update();
    return null;
  }

  Future<SaveOrderResponse?> saveOrderApi({
    required Map submitDetailsMap,
  }) {
    var map = submitDetailsMap;

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.saveOrder, requestJson).then((value) {
      try {
        if (value != null) {
          printErrors("Value is : $value");
          SaveOrderResponse saveOrderResponse = SaveOrderResponse.fromJson(value);
          return saveOrderResponse;
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
