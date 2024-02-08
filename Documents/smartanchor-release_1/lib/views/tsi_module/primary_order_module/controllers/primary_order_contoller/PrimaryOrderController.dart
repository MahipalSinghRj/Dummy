import 'dart:convert';

import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/models/responseModels/primary_order_model/GetBeatsResponse.dart';

import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/primary_order_model/CustomerUnderTsiResponse.dart';
import '../../models/responseModels/primary_order_model/GetCustomerInfoResponse.dart';
import '../../models/responseModels/primary_order_model/GetCustomersByBeatsResponse.dart';
import '../../models/responseModels/primary_order_model/GetCustomersByStateResponse.dart';
import '../../models/responseModels/primary_order_model/GetStatesForCustomersResponse.dart';
import '../../models/responseModels/primary_order_model/GetWarehouseForCustomerResponse.dart';
import '../../models/responseModels/primary_order_model/OrderTypeListResponse.dart';
import '../../models/responseModels/primary_order_model/PaymentTermListResponse.dart';

class PrimaryOrderController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());

  bool isGridItem = false;
  bool isGridItemSelected = false;
  List<String> statesList = [];
  List<String> buList = [];
  String businessUnit = '';
  String? selectedWarehouse;
  bool selectCustomersByBeat = false;

  boolCustomersByBeat(bool value) {
    selectCustomersByBeat = value;
    printMe("Select Customers By Beat value : $selectCustomersByBeat");
    update();
  }

  getStatesForCustomers() async {
    statesList = [];
    buList = [];
    businessUnit = '';
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getStatesForCustomersApi().then((value) {
      Get.back();

      try {
        if (value != null) {
          statesList = value.states!.toSet().toList();
          businessUnit = value.bu!;
          buList = businessUnit.split(',');
          printMe("State list and BU list $statesList, $businessUnit");
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

  Future<GetStatesForCustomersResponse?> getStatesForCustomersApi() {
    var map = {"userScreenName": globalController.customerScreenName};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getStatesForCustomers, requestJson).then((value) {
      try {
        if (value != null) {
          GetStatesForCustomersResponse getStatesForCustomersResponse = GetStatesForCustomersResponse.fromJson(value);
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

  ///Get customers by state api
  List<String> citiesList = [];
  List<CustomerInfos> customerInfoList = [];
  String customerTileColor = '';

  getCustomersByState({required String stateName}) async {
    citiesList = [];
    customerInfoList = [];
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getCustomersByStateApi(stateName: stateName).then((value) {
      Get.back();

      try {
        if (value != null) {
          citiesList = value.cities!.toSet().toList();
          customerInfoList = value.customerInfos ?? [];
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      //Get.back();
      update();
    });
  }

  Future<GetCustomersByStateResponse?> getCustomersByStateApi({required String stateName}) {
    var map = {
      "screenName": globalController.customerScreenName,
      "state": stateName,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getCustomersByState, requestJson).then((value) {
      try {
        if (value != null) {
          GetCustomersByStateResponse getCustomersByStateResponse = GetCustomersByStateResponse.fromJson(value);
          return getCustomersByStateResponse;
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

  List<WareHouseData> wareHouseDataList = [];
  List<String> wareHouseName = [];
  String locationId = '';
  String organizationId = '';
  String organizationName = '';
  Future<bool?> getWarehouseForCustomer({
    required String bu,
    required String customerCode,
  }) async {
    try {
      // Add loader
      // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
      final value = await getWarehouseForCustomerApi(
        bu: bu,
        customerCode: customerCode,
      );

      if (value != null) {
        wareHouseDataList = [];
        wareHouseDataList = value.wareHouseData ?? [];
        if (wareHouseDataList.isNotEmpty) {
          selectedWarehouse = wareHouseDataList[0].organizationName;
        }
        wareHouseName = wareHouseDataList.map((wareHouse) => wareHouse.organizationName ?? '').toList();

        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
      Widgets().showToast("An error occurred while fetching data.");
    }

    update();
    return false;
  }

  Future<GetWarehouseForCustomerResponse?> getWarehouseForCustomerApi({
    required String bu,
    required String customerCode,
  }) {
    var map = {"bu": bu, "customerCode": customerCode};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getWarehouseForCustomer, requestJson).then((value) {
      try {
        if (value != null) {
          GetWarehouseForCustomerResponse getWarehouseForCustomerResponse = GetWarehouseForCustomerResponse.fromJson(value);
          return getWarehouseForCustomerResponse;
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

  ///Get customer info api
  String? address;
  String? creditLimit;
  String? mobileNo;
  String? outstanding;
  String? overdue;
  String? code;
  String? lastOrderDate;
  String? remarks;
  String? customerName = '';
  String? customerCode = '';

  Future<bool?> getCustomerInfo({required String customerCode, required String businessUnit}) async {
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    try {
      address = '';
      creditLimit = '';
      mobileNo = '';
      outstanding = '';
      overdue = '';
      code = '';
      lastOrderDate = '';
      remarks = '';
      customerName = '';
      this.customerCode = '';
      final value = await getCustomerInfoApi(customerCode: customerCode, businessUnit: businessUnit);
      Get.back();

      if (value != null) {
        address = value.address ?? "";
        creditLimit = value.creditLimit ?? "";
        this.customerCode = value.customerCode ?? '';
        customerName = value.customerName ?? "";
        mobileNo = value.mobileNo ?? "";
        outstanding = value.outstanding ?? "";
        overdue = value.overdue ?? "";
        code = value.customerCode ?? '';
        lastOrderDate = value.lastOrderDate ?? '';
        remarks = value.remarks ?? '';
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

  Future<GetCustomerInfoResponse?> getCustomerInfoApi({required String customerCode, required String businessUnit}) {
    var map = {
      "customerCode": customerCode,
      "bu": businessUnit,
    };
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getCustomerInfo, requestJson).then((value) {
      printMe("API Response: $value");

      try {
        if (value != null) {
          GetCustomerInfoResponse getCustomerInfoResponse = GetCustomerInfoResponse.fromJson(value);
          return getCustomerInfoResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      printErrors("API Error: $e");
      return null;
    });
  }

  ///Get Beats api
  List<String> getBeatsList = [];
  getBeats({
    required String role,
    required String state,
    required String selectedCity,
  }) async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getBeatsApi(role: role, selectedCity: selectedCity, state: state).then((value) {
      Get.back();
      try {
        if (value != null) {
          getBeatsList = value.getBeatsList ?? [];
          printMe("Get beats : $value");
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

  Future<GetBeatsResponse?> getBeatsApi({
    required String role,
    required String state,
    required String selectedCity,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"role": globalController.role, "screenName": globalController.customerScreenName, "city": selectedCity, "state": state};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBeats, requestJson).then((value) {
      try {
        if (value != null) {
          GetBeatsResponse getBeatsResponse = GetBeatsResponse.fromJson(value);
          return getBeatsResponse;
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

  ///Get Customers By Beats api
  List<CustomerSearchWithBeats> getCustomersByBeatList = [];
  getCustomersByBeat({
    required String beatCode,
    required String buName,
  }) async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await getCustomersByBeatsApi(beatCode: beatCode, buName: buName).then((value) {
      Get.back();
      try {
        if (value != null) {
          getCustomersByBeatList = value.customerSearchWithBeatsList ?? [];
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      Get.back();
      update();
    });
  }

  Future<GetCustomersByBeatsResponse?> getCustomersByBeatsApi({
    required String beatCode,
    required String buName,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"beatCode": beatCode, "buName": "", "page": 1, "pageSize": 10};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getCustomersByBeats, requestJson).then((value) {
      try {
        if (value != null) {
          GetCustomersByBeatsResponse getCustomersByBeatsResponse = GetCustomersByBeatsResponse.fromJson(value);
          return getCustomersByBeatsResponse;
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

  ///Payment and order type api
  List<OrderTypeList>? orderTypeListItems = [];

  orderTypeList({
    required String businessUnit,
    required String customerCode,
  }) async {
    orderTypeListItems = [];
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await orderTypeListApi(
      businessUnit: businessUnit,
      customerCode: customerCode,
    ).then((value) {
      Get.back();
      try {
        if (value != null) {
          orderTypeListItems = value.orderTypeList ?? [];
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      Get.back();
      update();
    });
  }

  Future<OrderTypeListResponse?> orderTypeListApi({
    required String businessUnit,
    required String customerCode,
  }) {
    var map = {"bu": businessUnit, "customerCode": customerCode};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.orderTypeList, requestJson).then((value) {
      try {
        if (value != null) {
          OrderTypeListResponse orderTypeListResponse = OrderTypeListResponse.fromJson(value);
          return orderTypeListResponse;
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

  ///Payment and order type api
  List<PaymentTermList>? paymentTermListItems = [];

  paymentTermList() async {
    paymentTermListItems = [];
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await paymentTermListApi().then((value) {
      Get.back();
      try {
        if (value != null) {
          paymentTermListItems = value.paymentTermList ?? [];
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

  Future<PaymentTermListResponse?> paymentTermListApi() {
    var map = {"userScreenName": globalController.customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.paymentTermList, requestJson).then((value) {
      try {
        if (value != null) {
          PaymentTermListResponse paymentTermListResponse = PaymentTermListResponse.fromJson(value);
          return paymentTermListResponse;
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

  //Customer under TSI api
  List<CustomerNameAndCodeList> customerNameAndCodeList = [];

  Future<bool> customerUnderTsi() async {
    printMe("Called customer under tsi");
    try {
      // Add loader
      // Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
      var value = await customerUnderTsiApi();
      Get.back();

      if (value != null) {
        customerNameAndCodeList = value.customerNameAndCodeList ?? [];
        update();
        return true;
      } else {
        Widgets().showToast("Data not found!");
        update();
        return false;
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return false;
    } finally {
      update();
    }
  }

  Future<CustomerUnderTsiResponse?> customerUnderTsiApi() {
    var map = {"ScreenName": globalController.customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.customerUnderTsi, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerUnderTsiResponse customerUnderTsiResponse = CustomerUnderTsiResponse.fromJson(value);
          return customerUnderTsiResponse;
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

  isSelectedCustomerInfo({required bool isSelectedInfo}) {
    isGridItemSelected = isSelectedInfo;
    update();
  }
}
