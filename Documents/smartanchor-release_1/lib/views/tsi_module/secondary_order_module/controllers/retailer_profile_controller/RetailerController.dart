import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/ui/retailer_profile_module/RetailerOTPScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../configurations/ApiConstants.dart';
import '../../../../../services/ApiService.dart';
import '../../models/responseModels/retailer_profile_model/RetailerListResponseModal.dart';
import '../../models/responseModels/retailer_profile_model/SingleRetailerProfileDetailsResponse.dart';

class RetailerController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  bool isLoading = false;
  int pageNo = 1;
  int pageSize = 10;
  int lastPage = 0;
  TextEditingController searchController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  SingleRetailerProfileDetailResponse? singleRetailerProfileDetails;

  List<RetailerListItem> retailerList = [];
  List<RetailerListItem> filteredRetailerList = [];

// Function to load more data when scrolling reaches the end
  void loadMoreData() {
    if (pageNo < lastPage) {
      pageNo++;
      fetchRetailersList();
    } else {
      Widgets().showToast("No more data");
    }
  }

  fetchRetailersList() async {
    isLoading = true;
    update();

    final value = await retailerProfileListAPI(screenName: globalController.customerScreenName);

    if (value != null) {
      lastPage = value.lastPage;

      if (pageNo > 1) {
        retailerList.addAll(value.items);
      } else {
        retailerList = value.items;
      }
      // retailerList = value.items;
      // filteredRetailerList.addAll(retailerList);
    }

    isLoading = false;
    update();
    return value;
  }

  Future<RetailersListResponseModal?> retailerProfileListAPI({required String screenName}) {
    return ApiService.getRequest(
      ApiConstants.getRetailerList(screenName, pageSize, pageNo),
    ).then((value) {
      try {
        if (value != null) {
          RetailersListResponseModal retailerListResponse = RetailersListResponseModal.fromJson(value);

          return retailerListResponse;
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

  getSingleRetailerProfileDetail({required String code}) async {
    isLoading = true;
    update();

    try {
      final response = await ApiService.getRequest(
        ApiConstants.getSingleRetailerProfileDetails(code),
      );
      if (response != null) {
        SingleRetailerProfileDetailResponse singleRetialerResponse = SingleRetailerProfileDetailResponse.fromJson(response);

        singleRetailerProfileDetails = singleRetialerResponse;
      } else {
        singleRetailerProfileDetails = null;
      }
    } catch (e) {
      printMe("Exception Occur  :  $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> openMapWithAddress(String address) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  // filterItemsByName() {
  //   // Filter items based on the search query
  //   filteredRetailerList = retailerList
  //       .where((item) =>
  //           item.customerName.toLowerCase().contains(searchController.text.toLowerCase()) ||
  //           item.mobileNo.toLowerCase().contains(searchController.text.toLowerCase()) ||
  //           item.address.toLowerCase().contains(searchController.text.toLowerCase()))
  //       .toList();

  //   update();
  // }

  Future<bool> verifyUserSendOTP(String retailerCode) async {
    isLoading = true;
    update();

    try {
      final mapRequest = {
        "otpValue": "",
        "requestType": "Generate", //Generate or Verify
        "retailerCode": retailerCode,
        "role": globalController.role,
        "screenName": globalController.customerScreenName
      };

      final mapJson = jsonEncode(mapRequest);

      final response = await ApiService.postRequest(ApiConstants.genrateOtpToVerifyRetailer, mapJson);
      if (response != null) {
        final result = response["message"] ?? '';
        if (result == "Generated") {
          Widgets().showToast("OTP sent");
          isLoading = false;
          update();
          bool result = await Get.to(() => RetailerVerifyOTPScreen(
                retailerCode: retailerCode,
              ));

          return result;
        }
      } else {
        Widgets().showToast("OTP Not sent");
      }
    } catch (e) {
      printMe("Exception Occur  :  $e");
    } finally {
      isLoading = false;
      update();
    }

    return false;
  }

  Future<bool?> verifyUserValidateOTP(String retailerCode) async {
    isLoading = true;
    update();

    try {
      final mapRequest = {
        "otpValue": otpController.text,
        "requestType": "Verify", //Generate or Verify
        "retailerCode": retailerCode,
        "role": globalController.role,
        "screenName": globalController.customerScreenName
      };

      final mapJson = jsonEncode(mapRequest);

      final response = await ApiService.postRequest(ApiConstants.genrateOtpToVerifyRetailer, mapJson);
      if (response != null) {
        final result = response["message"] ?? '';
        if (result == "NotVerified") {
          isLoading = false;
          Widgets().showToast("OTP Not Varified");
          update();
          return null;
        } else {
          isLoading = false;
          update();
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      printMe("Exception Occur  :  $e");
    } finally {
      isLoading = false;
      update();
    }

    return false;
  }
}
