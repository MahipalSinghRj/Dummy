import 'dart:convert';
import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/models/responseModels/secondary_order_model/RetailerDetailsResponse.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/models/responseModels/secondary_order_model/RetailerFieldsResponse.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/models/responseModels/secondary_order_model/RetailersByBeatResponse.dart';
import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_checkout_model/DistributeResponse.dart';

class SecondaryController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  bool isGridItemSelected = false;
  bool selectSecCustomersByBeat = false;
  String? retailerCode;
  String? selectedBu;
  String? selectedState;
  String? selectedCity;
  String? selectedBeat;
  String? selectedWarehouse;
  List<String> selectBuList = [];
  List<String> selectStateList = [];
  List<String> selectCityList = [];
  List<String> beatList = [];
  List<RetailerDetails> retailerDetailsByBeatList = [];
  List<NewRetailersDetails> newRetailersDetailsDataList = [];
  List<Distributor> distributorList =[];

  ///Get Retailer-Fields api
  retailerFieldsFn() async {
    //Add loader
    //Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await retailerFieldsApi().then((value) {
      Get.back();
      try {
        if (value != null) {
          newRetailersDetailsDataList = value.retailersDetailsData ?? [];
          selectedBu = value.bu ?? '';
          selectBuList = selectedBu?.split(',') ?? [];
          selectedState = value.state ?? '';
          selectStateList = selectedState?.split(',') ?? [];
          selectedCity = value.city ?? '';
          selectCityList = selectedCity?.split(',') ?? [];
          beatList = value.beatList ?? [];
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

  Future<RetailerFieldsResponse?> retailerFieldsApi() {
    //TODO : Add these map when data is coming properly
    var map = {"role": globalController.role, "screenName": globalController.customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.retailerFields, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerFieldsResponse retailerFieldsResponse = RetailerFieldsResponse.fromJson(value);
          return retailerFieldsResponse;
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

  ///Retailer by beat apis

  retailersByBeatFn({
    required String beat,
  }) async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await retailersByBeatApi(beat: beat).then((value) {
      Get.back();
      try {
        if (value != null) {
          retailerDetailsByBeatList = value.retailerDetailsData ?? [];
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

  Future<RetailersByBeatResponse?> retailersByBeatApi({
    required String beat,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"beat": beat, "role": globalController.role, "screenName": globalController.customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.retailersByBeat, requestJson).then((value) {
      try {
        if (value != null) {
          RetailersByBeatResponse retailersByBeatResponse = RetailersByBeatResponse.fromJson(value);
          return retailersByBeatResponse;
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

  ///Retailers details api
  //Retailer Details variables
  String address = '';
  String beat = '';
  String lastOrder = '';
  String mobile = '';
  String remark = '';
  String retailerName = '';
  String emailId = '';

  Future<void> retailerDetailsFn({
    required String retailerCode,
  }) async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await retailerDetailsApi(retailerCode: retailerCode).then((value) {
      Get.back();
      try {
        if (value != null) {
          address = value.address ?? '';
          beat = value.beat ?? '';
          lastOrder = value.lastOrder ?? '';
          mobile = value.mobile ?? '';
          remark = value.remark ?? '';
          retailerName = value.retailerName ?? '';
          emailId = value.emailId ?? '';
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

  Future<RetailerDetailsResponse?> retailerDetailsApi({
    required String retailerCode,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"retailerCode": retailerCode, "screenName": globalController.customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.retailerDetails, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerDetailsResponse retailerDetailsResponse = RetailerDetailsResponse.fromJson(value);
          return retailerDetailsResponse;
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

  isSecondaryCustomerInfo({required bool isSelectedInfo}) {
    isGridItemSelected = isSelectedInfo;
    printMe("Is selected : $isGridItemSelected");
    update();
  }

  isSecondaryCustomersByBeat(bool value) {
    selectSecCustomersByBeat = value;
    printMe("Select Customers By Beat value : $selectSecCustomersByBeat");
    update();
  }

  Future<void> retailerDistribute({
    required String retailerCode,
  }) async {
    //Add loader
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await retailerDistributeApi(retailerCode: retailerCode).then((value) {
      Get.back();
      try {
        if (value != null) {
          distributorList = value.distributor!;
          printMe("distributorList : ${distributorList.length}");
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

  Future<DistributeResponse?> retailerDistributeApi({
    required String retailerCode,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {"retailerNo": retailerCode, "screenName":
    globalController.customerScreenName, "role": globalController.role,};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.distributeEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          DistributeResponse retailerDetailsResponse = DistributeResponse.fromJson(value);
          return retailerDetailsResponse;
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
