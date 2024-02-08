import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/models/CustomerProfileDetailsResonse.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/models/CustomerProfileResponse.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/models/CustomerProfileResponse.dart'
    as cf;
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../configurations/ApiConstants.dart';
import '../../../../../../debug/printme.dart';
import '../../../../../../services/ApiService.dart';

class CustomerProfileController extends GetxController {
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  CustomerProfileListResponse? customerProfiles;
  List<cf.Item> filteredCustomerProfileData = [];

  CustomerProfileDetailsResponse customerProfileDetails =
      CustomerProfileDetailsResponse(
          address: '',
          beat: '',
          buName: '',
          city: '',
          creditLimit: '',
          latitude: '',
          longitude: '',
          customerCode: '',
          customerName: '',
          masterId: '',
          noOrderCount: '',
          orderCount: '',
          outstanding: '',
          overdue: '',
          phoneNo: '',
          returnOrderCount: '',
          state: '',
          totalOrderValue: '');
  GlobalController globalController = Get.put(GlobalController());
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  int pageCount = 1;
  int pageLimit = 10;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageCount = 1;
    pageLimit = 10;
    searchController.addListener(() async {
      // filterProfiles(searchController.text);
      pageCount = 1;
      await fetchCustomerList();
    });
    // fetchCustomerList();
  }

  void filterProfiles(String query) {
    filteredCustomerProfileData = customerProfiles!.items.where((value) {
      return value.customerName.toLowerCase().contains(query.toLowerCase()) ||
          value.customerCode.toLowerCase().contains(query.toLowerCase());
    }).toList();
    update();
  }

  fetchCustomerList({int page = 1}) async {
    pageCount = page;
    isLoading = true;
    update();

    var map = {
      "ScreenName": globalController.customerScreenName,
      "page": pageCount,
      "pageSize": pageLimit,
      "searchContext": searchController.text
    };

    final value = await customerProfileListAPI(map);

    if (value != null) {
      if (pageCount == 1) {
        customerProfiles = value;
        filteredCustomerProfileData = customerProfiles!.items;
      } else {
        customerProfiles!.items.addAll(value.items);
        filteredCustomerProfileData = customerProfiles!.items;
      }
    }

    isLoading = false;
    update();
    return value;
  }

  Future<CustomerProfileListResponse?> customerProfileListAPI(
    Map map,
  ) {
    var requestJson = jsonEncode(map);
    print(requestJson);
    return ApiService.postRequest(
            ApiConstants.getCustomerProfileList, requestJson)
        .then((value) {
      try {
        if (value != null) {
          CustomerProfileListResponse customerProfileList =
              CustomerProfileListResponse.fromJson(value);
          return customerProfileList;
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

  onRefresh() async {
    await fetchCustomerList();
  }

  onLoading() async {
    pageCount = 2;

    await fetchCustomerList();
    refreshController.refreshCompleted();

    update();
  }

  getCustomerDetailsByMasterId(String masterId) async {
    isLoading = true;
    update();

    var map = {"MasterId": masterId};

    final value = await customerProfileDetailsByMasterIdAPI(map);

    if (value != null) {
      customerProfileDetails = value;
    }
    isLoading = false;
    update();
    return customerProfileDetails;
  }

  Future<CustomerProfileDetailsResponse?> customerProfileDetailsByMasterIdAPI(
      Map map) async {
    var requestJson = jsonEncode(map);
    print(requestJson);
    return ApiService.postRequest(
            ApiConstants.getCustomerProfileDetails, requestJson)
        .then((value) {
      try {
        if (value != null) {
          CustomerProfileDetailsResponse customerProfileDetails =
              CustomerProfileDetailsResponse.fromJson(value);
          return customerProfileDetails;
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

  Future<void> openMapWithAddress(String address) async {
    final googleUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
