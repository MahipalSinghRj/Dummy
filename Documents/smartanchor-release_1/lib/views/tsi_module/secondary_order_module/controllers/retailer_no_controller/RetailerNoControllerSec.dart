import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_no_order_model/NoOrderResponse.dart';

class RetailerNoOrderControllerSec extends GetxController {
  final TextEditingController commentController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());

  var base64;
  String fileName = '';
  var extension;
  String? selectedReason;
  var baseFile;
  var mimeTypeFile = '';

  ///Get Retailer no order api
  Future<bool> noOrderFn({
    required String attachmentBase64,
    required String bu,
    required String latitude,
    required String longitude,
    required String mimeType,
    required String reason,
    required String remark,
    required String retailerCode,
  }) async {
    try {
      final response = await noOrderApi(
        attachmentBase64: attachmentBase64,
        bu: bu,
        latitude: latitude,
        longitude: longitude,
        mimeType: mimeType,
        reason: reason,
        remark: remark,
        retailerCode: retailerCode,
      );

      if (response != null) {
        printMe("Message is : ${response.message}");
        return true;
      } else {
        Widgets().showToast("Data not found!");
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
    }

    update();
    return false;
  }

  Future<NoOrderResponse?> noOrderApi({
    required String attachmentBase64,
    required String bu,
    required String latitude,
    required String longitude,
    required String mimeType,
    required String reason,
    required String remark,
    required String retailerCode,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "attachmentBase64": attachmentBase64,
      "bu": bu,
      "latitude": latitude,
      "longitude": longitude,
      "mimeType": mimeType,
      "reason": reason,
      "remark": remark,
      "retailerCode": retailerCode,
      "role": globalController.role,
      "screenName": globalController.customerScreenName
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.noOrder, requestJson).then((value) {
      try {
        if (value != null) {
          NoOrderResponse noOrderResponse = NoOrderResponse.fromJson(value);
          return noOrderResponse;
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

  bool validationSubmitNoOrder() {
    if (baseFile == null) {
      baseFile = '';
    } else {
      mimeTypeFile = "image/png";
    }

    if (selectedReason == null) {
      Widgets().showToast("Please select reason");
      return false;
    }

    // if (baseFile.toString().isEmpty) {
    //   Widgets().showToast("Please add attachment");
    //   return false;
    // }

    /*if (commentController.text.toString().isEmpty) {
      Widgets().showToast("Please add remarks");
      return false;
    }*/
    return true;
  }
}
