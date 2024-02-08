import 'dart:convert';

import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/order_detail_model/OrderDetailsByIdResponse.dart';

class OrderDetailByIdController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  CalculationController calculationController = Get.put(CalculationController());
  int count1 = 1;

  ///------------------------------------------------------------------------------------------------
  ///Previous Orders By Filter api
  List<ProductDetailsbodies>? productDetailsbodies = [];
  String? orderDate;
  String? orderId;
  String? orderQty;
  String? statusFlag;
  String? orderNumber;

  Future<bool?> orderDetailsById({
    required String orderCartId,
    required String bu,
    required String customerCode,
  }) async {
    // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    try {
      var value = await orderDetailsByIdApi(orderCartId: orderCartId, bu: bu, customerCode: customerCode);
      Get.back();
      if (value != null) {
        orderDate = value.orderDate;
        orderId = value.orderId;
        orderQty = value.orderQty;
        statusFlag = value.sTATUSFLAG;
        productDetailsbodies = value.productDetailsbodies ?? [];
        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return false;
    }
  }

  Future<OrderDetailsByIdResponse?> orderDetailsByIdApi({
    required String orderCartId,
    required String bu,
    required String customerCode,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "OrderCartId": orderCartId,
      "bu": bu,
      "customerCode": customerCode,
    };
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.OrderDetailsbyId, requestJson).then((value) {
      try {
        if (value != null) {
          OrderDetailsByIdResponse orderDetailsByIdResponse = OrderDetailsByIdResponse.fromJson(value);
          return orderDetailsByIdResponse;
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
