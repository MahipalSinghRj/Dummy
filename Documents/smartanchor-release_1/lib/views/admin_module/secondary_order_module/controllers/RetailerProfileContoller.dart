import 'dart:convert';

import 'package:get/get.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../home_module/models/AdminDropdownResponse.dart';
import '../models/RetailerProfileDetailResponse.dart';
import '../models/RetailerProfileResponse.dart';

class RetailerProfileController extends GetxController {
  List<RetailerProfileLists> retailerProfileLists = [];
  String newRetailer = '';
  String totalRetailer = '';

  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];

  String address = '';
  String beat = '';
  String city = '';
  String state = '';
  String creditLimit = '';
  String outstanding = '';
  String overdue = '';
  String phoneNumber = '';
  String powerDealer = '';
  String iaqDealer = '';
  String lightingDealer = '';
  int totalOrderedItems = 0;
  int orderValue = 0;
  int noOrderCount = 0;
  String shopName = '';

  Future<bool?> getRetailerProfile({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerProfileApi(
            fromDate: fromDate,
            toDate: toDate,
            bu: bu,
            state: state,
            zone: zone,
            city: city,
            role: role,
            screenName: screenName,
            searchString: searchString)
        .then((value) {
      // Get.back();

      try {
        if (value != null) {
          retailerProfileLists = value.retailerProfileLists!;
          newRetailer = value.newRetailer!;
          totalRetailer = value.totalRetailerVisited!;

          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  Future<RetailerProfileResponse?> getAdminRetailerProfileApi({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    Map map = {
      "bu": bu,
      "city": city,
      "fromDate": fromDate,
      "pageNumber": 1,
      "pageSize": 4,
      "role": role,
      "screenName": screenName,
      "searchString": searchString,
      "state": state,
      "toDate": toDate,
      "zone": zone
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerProfile, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerProfileResponse getRetailerProfileResponse =
              RetailerProfileResponse.fromJson(value);
          return getRetailerProfileResponse;
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

  Future<bool?> getAdminData(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminAPIs(
            bu: bu,
            state: state,
            city: city,
            brand: brand,
            category: category,
            division: division,
            zone: zone)
        .then((value) {
      // Get.back();

      try {
        if (value != null) {
          buList = value.bu!;
          zoneList = value.zone!;
          stateList = value.state!;
          divisionList = value.division!;
          categoryList = value.category!;
          cityList = value.city!;

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  Future<AdminDropdownResponse?> getAdminAPIs(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {
    Map map = {
      "bu": bu,
      "zone": zone,
      "state": state,
      "division": division,
      "category": category,
      "brand": brand,
      "city": city
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBuListEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AdminDropdownResponse getStatesForCustomersResponse =
              AdminDropdownResponse.fromJson(value);
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

  Future<bool?> getRetailerProfileDetail({
    required String code,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerProfileDetailApi(code: code).then((value) {
      //   Get.back();

      try {
        if (value != null) {
          address = value.address!;
          beat = value.beat!;
          city = value.city!;
          state = value.state!;
          creditLimit = value.creditLimit!;
          outstanding = value.outstanding!;
          overdue = value.overdue!;
          phoneNumber = value.mobileNo!;
          powerDealer = value.powerDealer!;
          iaqDealer = value.iaqDealer!;
          lightingDealer = value.lightingDealer!;
          totalOrderedItems = value.totalOrderItems!;
          orderValue = value.orderValue!;
          noOrderCount = value.noOrderCount!;
          shopName = value.shopName!;
          print('sagar');
          print(address);
          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  Future<RetailerProfileDetailResponse?> getAdminRetailerProfileDetailApi({
    required String code,
  }) async {
    Map map = {"retailerCode": code};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerProfileDetail, requestJson).then(
        (value) {
      try {
        if (value != null) {
          RetailerProfileDetailResponse getRetailerProfileDetailResponse =
              RetailerProfileDetailResponse.fromJson(value);
          return getRetailerProfileDetailResponse;
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

  Future<bool?> getRetailerList({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required int pageNumber,
    required int pageSize,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    //Widgets().loadingDataDialog(loadingText: "Loading data...");

    await getAdminRetailerListApi(
            fromDate: fromDate,
            toDate: toDate,
            bu: bu,
            state: state,
            zone: zone,
            city: city,
            role: role,
            screenName: screenName,
            searchString: searchString)
        .then((value) {
      //  Get.back();

      try {
        if (value != null) {
          retailerProfileLists = value.retailerProfileLists!;

          update();

          return true;
        } else {
          Widgets().showToast("Data not found!");
          return false;
        }
      } catch (e) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  Future<RetailerProfileResponse?> getAdminRetailerListApi({
    required String fromDate,
    required String toDate,
    required String bu,
    required String zone,
    required String state,
    required String city,
    required String role,
    required String screenName,
    required String searchString,
  }) async {
    /*Map map = {
      "bu": bu,
      "city": city,
      "fromDate": fromDate,
      "pageNumber": 1,
      "pageSize": 4,
      "role": role,
      "screenName": screenName,
      "searchString": searchString,
      "state": state,
      "toDate": toDate,
      "zone": zone
    };*/

    Map map = {
      "bu": bu,
      "city": city,
      "fromDate": fromDate,
      "pageNumber": 1,
      "pageSize": 10,
      "role": role,
      "screenName": screenName,
      "searchString": searchString,
      "state": state,
      "toDate": toDate,
      "zone": zone
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminRetailerProfile, requestJson).then((value) {
      try {
        if (value != null) {
          RetailerProfileResponse getRetailerProfileResponse =
              RetailerProfileResponse.fromJson(value);
          return getRetailerProfileResponse;
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
