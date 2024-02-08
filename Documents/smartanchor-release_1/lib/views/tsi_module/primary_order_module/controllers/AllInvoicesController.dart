import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/models/requestModels/allInvoiceModel/AllInvoiceRequest.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../models/responseModels/AllInvoicesModelClass.dart';
import '../models/responseModels/allInvoiceModel/AllInvoiceResponse.dart';
import '../models/responseModels/primary_order_model/GetStatesForCustomersResponse.dart';

class AllInvoicesController extends GetxController {
  bool isLoading = false;
  AllInvoiceResponseModal? allInvoicesModal;
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  List<String> availableBu = [];

  String? selectedBu;
  int pageCount = 1;
  int pageSize = 5;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    dateFromController.text = dateTimeUtils.formatDateTime(DateTime.now());
    dateToController.text = dateTimeUtils.formatDateTime(DateTime.now());

    // await fetchAllInvoices();
  }

  List<AllInvoicesListModelClass> dataList = [
    AllInvoicesListModelClass(
        businessUnit: 'Lighting',
        transactionType: 'Invoice',
        date: '12/05/2023',
        referenceNo: '76610011222',
        salesOrder: '31215421'),
    AllInvoicesListModelClass(
        businessUnit: 'Switches',
        transactionType: 'Invoice 1',
        date: '10/05/2022',
        referenceNo: '4545455454',
        salesOrder: '2115454'),
  ];
  List<Item> selectedItems = [];
  List<AllInvoicesListModelClass> selectedItems2 = [];

  fetchAllInvoices(
      {required String customerNo,
      int page = 1,
      bool disableLoading = false}) async {
    if (selectedBu == null || selectedBu!.isEmpty) {
      Widgets().showToast("Please Select BU");
      return;
    }
    pageCount = page;
    if (!disableLoading) {
      isLoading = true;
      update();
    }

    final map = AllInvoiceRequestModal(
        bu: selectedBu ?? '',
        customerNo: customerNo,
        // customerNo: "1020032",
        page: pageCount,
        pageSize: pageSize,
        filter: (dateFromController.text.isNotEmpty &&
                dateFromController.text.isNotEmpty)
            ? Filter(
                startDate: dateFromController.text,
                toDate: dateToController.text)
            : null);

    final value = await fetchAllInvoicesAPI(map.toJson());
    if (value != null) {
      if (pageCount == 1) {
        allInvoicesModal = value;
      } else {
        allInvoicesModal!.items.addAll(value.items);
      }
    }
    if (!disableLoading) {
      isLoading = false;
      update();
    }
    return value;
  }

  Future<AllInvoiceResponseModal?> fetchAllInvoicesAPI(
      Map<String, dynamic> map) {
    final data = jsonEncode(map);
    return ApiService.postRequest(ApiConstants.getAllInvoicesForCustomer, data)
        .then((value) {
      try {
        if (value != null) {
          AllInvoiceResponseModal allInvoices =
              AllInvoiceResponseModal.fromJson(value);
          return allInvoices;
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

  getBUForCustomers() async {
    availableBu = [];
    isLoading = true;
    update();
    await getBUForCustomersAPI(
            customerScreenName: globalController.customerScreenName)
        .then((value) {
      try {
        if (value != null) {
          final businessUnit = value.bu!;
          availableBu = businessUnit.split(',');
          if (availableBu.isNotEmpty) {
            selectedBu = availableBu.first;
          }
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
    });

    isLoading = true;
    update();
  }

  Future<GetStatesForCustomersResponse?> getBUForCustomersAPI(
      {required String customerScreenName}) {
    var map = {"userScreenName": customerScreenName};

    //var map = {"userScreenName": "a07864"};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.getStatesForCustomers, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetStatesForCustomersResponse getStatesForCustomersResponse =
              GetStatesForCustomersResponse.fromJson(value);
          return getStatesForCustomersResponse;
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
