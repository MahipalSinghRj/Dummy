import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../services/ApiService.dart';
import '../models/ActivityTrackerResponse.dart';
import '../models/AdminDropdownResponse.dart';
import '../models/AttendenceAdminResponse.dart';
import '../models/BeatStatusResponse.dart';
import '../models/BusinessAchivementResponse.dart';
import '../models/PrimarySecondaryResponse.dart';
import '../models/ProductPerformanceResponse.dart';
import '../models/RetailersResponse.dart';
import '../models/TopCustomersAdminResponse.dart';

class AdminHomeController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());

  List<String> buList = [];
  List<String> zoneList = [];
  List<String> stateList = [];
  List<String> divisionList = [];
  List<String> categoryList = [];
  List<String> cityList = [];
  String? selectedSalesBUFilter = '';

  var newCustomers;
  var newRetailers;
  var primaryOrderCount;
  var secondaryOrderCount;
  var totalPrimarySales;

  List<String> categoriesBeatList = [];
  List<int> completedCustomersBeatList = [];
  List<int> pendingCustomersBeatList = [];
  var totalAllocatedBeats;
  var totalBeats;

  List<String> primaryCategoriesList= [];
  List<double> primaryOrdersList= [];
  List<String> secondaryCategoriesList= [];
  List<double> secondaryOrdersList= [];

  List<BusinessData> businessData = [];
  List<String> labelList = [];

  List<Retailers> retailers = [];

  List<TopCustomersAdmin> topCustomers = [];

  int? totalAbsentEmployees;
  int? totalLateComers;
  int? totalPresentEmployees;

  List<BusinessProductData> businessProductData = [];
  List<String> filterList = [];
  List<String>? labelListProduct = [];

  String selectedActivityFilter = "MONTHLY";
  String selectedBeatFilter = "MONTHLY";
  String selectedPrimarySecFilter = "MONTHLY";
  String selectedAttandanceFilter = "MONTHLY";
  String selectedBusinessAchievementsFilter = "2023";


  int selectedToggleIndex = 0;

  bool isLoading = false;

  Future<bool?> getAdminData(
      {required String bu,
      required String zone,
      required String state,
      required String division,
      required String category,
      required String brand,
      required String city}) async {

   // Widgets().loadingDataDialog(loadingText: "Loading data...");

    isLoading = true;
    update();

    await getAdminAPIs(
            bu: bu, state: state, city: city, brand: brand, category: category, division: division, zone: zone)
        .then((value) {
     // Get.back();
isLoading = false;
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
          AdminDropdownResponse getStatesForCustomersResponse = AdminDropdownResponse.fromJson(value);
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

  Future<bool?> getActivityTracker(
      {required String stateName,
      required String cityName,
      required String zoneName,
      required String buName,
      required String filterType}) async {

    isLoading = true;
    update();

    await getActivityTrackerAPI(
            stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {

          isLoading=false;

      try {
        if (value != null) {
          newCustomers = value.newCustomers;
          newRetailers = value.newRetailers;
          primaryOrderCount = value.primaryOrderCount;
          secondaryOrderCount = value.secondaryOrderCount;
          totalPrimarySales = value.totalPrimarySales;
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

  Future<ActivityTrackerResponse?> getActivityTrackerAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": filterType //  MONTHLY WEEKLY YEARLY TODAY
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminActivityTrackerEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          ActivityTrackerResponse response = ActivityTrackerResponse.fromJson(value);
          return response;
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

  Future<bool?> getBeatStatus(
      {required String stateName,
      required String cityName,
      required String zoneName,
      required String buName,
      required String filterType}) async {

    isLoading = true;
    update();

    await getBeatStatusAPI(
            stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {

  isLoading = false;
      try {
        if (value != null) {
          categoriesBeatList =value.categoriesList!;
          completedCustomersBeatList =value.completedCustomersList!;
          pendingCustomersBeatList =value.pendingCustomersList!;
           totalAllocatedBeats =value.totalAllocatedBeats;
           totalBeats = value.totalBeats;
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

  Future<BeatStatusResponse?> getBeatStatusAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": filterType //  MONTHLY WEEKLY YEARLY TODAY
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminDashboardBeatsEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          BeatStatusResponse response = BeatStatusResponse.fromJson(value);
          return response;
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

  Future<bool?> getPrimarySecondary(
      {required String stateName,
        required String cityName,
        required String zoneName,
        required String buName,
        required String filterType}) async {

    isLoading = true;
    update();
    await getPrimarySecondaryAPI(
        stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {

      isLoading = false;
      primaryCategoriesList =[];
      primaryOrdersList =[];
      secondaryCategoriesList =[];
      secondaryOrdersList =[];

      try {
        if (value != null) {
          primaryCategoriesList =value.primaryCategoriesList! ;
          primaryOrdersList= value.primaryOrdersList!;
          secondaryCategoriesList = value.secondaryCategoriesList!;
          secondaryOrdersList = value.secondaryOrdersList!;
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

  Future<PrimarySecondaryResponse?> getPrimarySecondaryAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": filterType //  MONTHLY WEEKLY YEARLY TODAY
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminDashboardPrimarySecondaryEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          PrimarySecondaryResponse response = PrimarySecondaryResponse.fromJson(value);
          return response;
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

  Future<bool?> getBusinessAchivement(
      {required String stateName,
        required String cityName,
        required String zoneName,
        required String buName,
        required String filterType}) async {

    isLoading = true;
    update();

    await getBusinessAchivementAPI(
        stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {

      isLoading = false;
      try {
        if (value != null) {
          businessData = value.businessData!;
          labelList = value.labelList!;
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

  Future<BusinessAchivementResponse?> getBusinessAchivementAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": filterType //  MONTHLY WEEKLY YEARLY TODAY
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminDashboardBusinessAchivementEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          BusinessAchivementResponse response = BusinessAchivementResponse.fromJson(value);
          return response;
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

  Future<RetailersResponse?> getRetailer(
      {required String stateName,
        required String cityName,
        required String zoneName,
        required String buName,
        required String filterType}) async {

    isLoading = true;
    update();
    await getRetailerAPI(
        stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {

      isLoading = false;
      try {
        if (value != null) {
          retailers = value.retailers!;
          return value;
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

  Future<RetailersResponse?> getRetailerAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": '' //  MONTHLY WEEKLY YEARLY TODAY
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminDashboardRetailersEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          RetailersResponse response = RetailersResponse.fromJson(value);
          return response;
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

  Future<bool?> getCustomer(
      {required String stateName,
        required String cityName,
        required String zoneName,
        required String buName,
        required String filterType}) async {

    isLoading = true;
    update();
    await getCustomerAPI(
        stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName, filterType: filterType)
        .then((value) {
      isLoading = false;

      try {
        if (value != null) {
          topCustomers = value.topCustomers!;
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

  Future<TopCustomersAdminResponse?> getCustomerAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "filterType": ''
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminDashboardTopCustomersEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          TopCustomersAdminResponse response = TopCustomersAdminResponse.fromJson(value);
          return response;
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

  Future<bool?> getAdminAttendence(
      {required String stateName,
        required String cityName,
        required String zoneName,
        required String buName,
        required String filterType,
        required String division,
        required String brand,
        required String category}) async {

    isLoading = true;
    update();
    await getAdminAttendenceAPI(
        stateName: stateName, cityName: cityName, zoneName: zoneName, buName: buName,
        filterType: filterType, division: division, brand: brand, category: category)
        .then((value) {
      isLoading = false;

      try {
        if (value != null) {
          totalAbsentEmployees = value.totalAbsentEmployees;
           totalLateComers= value.totalLateComers;
          totalPresentEmployees = value.totalPresentEmployees;
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

  Future<AttendenceAdminResponse?> getAdminAttendenceAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
    required String division,
    required String brand,
    required String category,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "category": category,
      "brand": brand,
      "division": division,
      "filterType": filterType
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminAttendenceGraphEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          AttendenceAdminResponse response = AttendenceAdminResponse.fromJson(value);
          return response;
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

  Future<bool?> getProductPerformance(
      {required String stateName,
      required String cityName,
      required String zoneName,
      required String buName,
      required String filterType,
      required String division,
      required String brand,
      required String category}) async {

    isLoading = true;
    update();
    await getProductPerformanceAPI(
            stateName: stateName,
            cityName: cityName,
            zoneName: zoneName,
            buName: buName,
            filterType: filterType,
            division: division,
            brand: brand,
            category: category)
        .then((value) {

      isLoading = false;
      try {
        if (value != null) {
          businessProductData = value.businessData!;
          filterList = value.filterList??[];
          labelListProduct = value.labelList;
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

  Future<ProductPerformanceResponse?> getProductPerformanceAPI({
    required String stateName,
    required String cityName,
    required String zoneName,
    required String buName,
    required String filterType,
    required String division,
    required String brand,
    required String category,
  }) async {
    Map map = {
      "customerScreenName": globalController.customerScreenName,
      "stateName": stateName,
      "cityName": cityName,
      "zoneName": zoneName,
      "buName": buName,
      "category": category,
      "brand": brand,
      "division": division,
      "filterType": filterType
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getAdminProductPerformanceEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          ProductPerformanceResponse response = ProductPerformanceResponse.fromJson(value);
          return response;
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

  isSelectedActivityFilter({required String filter}) {
    selectedActivityFilter = filter;
    update();
  }

  isSelectedBeatFilter({required String filter}) {
    selectedBeatFilter = filter;
    update();
  }

  isSelectedPrimarySecFilter({required String filter}) {
    selectedPrimarySecFilter = filter;
    update();
  }

  isSelectedAttandanceFilter({required String filter}) {
    selectedAttandanceFilter = filter;
    update();
  }

  isSelectedBusinessAchievementsFilter({required String filter}) {
    selectedBusinessAchievementsFilter = filter;
    update();
  }


  isSelectedToggleIndex({required int index}) {
    selectedToggleIndex = index;
    update();
  }

  isSelectedSalesBuFilter({required String filter}) {
    selectedSalesBUFilter = filter;
    update();
  }
}
