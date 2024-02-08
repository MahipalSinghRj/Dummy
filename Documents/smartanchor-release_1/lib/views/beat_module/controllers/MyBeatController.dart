import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../common/widgets.dart';
import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../../../utils/ChartsSupportClasses.dart';
import '../../../utils/DateTimeUtils.dart';
import '../models/requestModels/AddEventsForApprovalRequest.dart';
import '../models/responseModels/AddEventsForApprovalResponse.dart';
import '../models/responseModels/GetCustomerAddressResponse.dart';
import '../models/responseModels/GetCustomerDetailsResponse.dart';
import '../models/responseModels/GetEventsAllocationResponse.dart';
import '../models/responseModels/GetUserListDataResponse.dart';

class MyBeatController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  //---------------------------------------------------------------------
  ///Get event allocation api
  List<BeatsEventData> beatsEventDataList = [];
  List<BeatsData> beatsDataDataList = [];
  String? totalBeats = "N/A";
  String? completedCustomers = "N/A";
  String? pendingCustomers = "N/A";
  List<ChartSampleData> createPieChartModelList = [];
  List<ChartSampleData> cartesianChartModelList = [];

  List<String> calenderViewList = ["Day", "Weekly", "Monthly"];
  String? calenderViewSelected = 'Monthly';

  String? calenderViewSelectedBarGraph = 'Monthly';

  bool isDataLoad = false;
  CalendarView cView = CalendarView.month;

  bool isNullData = false;
  String currentYear = '';
  String currentMonth = '';
  String currentStart = '';
  String currentEnd = '';

  bool isFirstTime = true;

  updateInFirstTime() {
    isFirstTime = false;
    update();
  }

  CalendarView updateCalenderView(
    String operation,
  ) {
    print(operation);
    switch (operation) {
      case 'Day':
        {
          cView = CalendarView.day;
          update();
        }
        break;
      case 'Weekly':
        {
          cView = CalendarView.week;
          update();
        }
        break;
      case 'Monthly':
        {
          cView = CalendarView.month;
          update();
        }
        break;
      default:
        {
          cView = CalendarView.month;
          update();
        }
        break;
    }
    return cView;
  }

  updateCurrentDates(
    String operation,
    String currentYearString,
    String currentMonthString,
    String currentStartString,
    String currentEndString,
  ) {
    switch (operation) {
      case 'Daily':
      case 'Weekly':
      case 'Monthly':
        {
          currentYear = currentYearString;
          currentMonth = currentMonthString;
          currentStart = currentStartString;
          currentEnd = currentEndString;
        }
        break;

      default:
        {
          currentYear = dateTimeUtils.getCurrentYear();
          currentMonth = dateTimeUtils.getCurrentMonth();
          currentStart = dateTimeUtils.getStartOfMonth();
          currentEnd = dateTimeUtils.getEndOfMonth();
        }

        update();
    }

    print("operation " + operation);
    print("currentYear " + currentYear);
    print("currentMonth " + currentMonth);
    print("currentStart " + currentStart);
    print("currentEnd " + currentEnd);
  }

  getEventsAllocation({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
  }) async {
    //Add loader

    await getEventsAllocationApi(
            month: month,
            year: year,
            currentStart: currentStart,
            currentEnd: currentEnd)
        .then((value) {
      Get.back();
      isNullData = false;

      try {
        if (value != null) {
          if (value.errorMessage != null) {
            Widgets().showToast(value.errorMessage.toString());
          }

          createPieChartModelList = [];

          int? totalCustomersY = int.tryParse(value.totalCustomers ?? "0");
          int? pendingCustomersY = int.tryParse(value.pendingCustomers ?? "0");
          int? completedCustomersY =
              int.tryParse(value.completedCustomers ?? "0");

          createPieChartModelList = createPieChartModel(
              totalCustomersY, pendingCustomersY, completedCustomersY);

          beatsEventDataList = [];
          beatsDataDataList = [];
          cartesianChartModelList = [];
          totalBeats = value.totalBeats ?? '';
          completedCustomers = value.completedCustomers ?? '';
          pendingCustomers = value.pendingCustomers ?? '';
          beatsEventDataList = value.beatsEventData ?? [];

          beatsEventDataList.forEach(
              (e) => print("Event Date : ${e.start} ${e.end}  ${e.title}"));
          beatsDataDataList = value.beatsData ?? [];

          cartesianChartModelList = cartesianChartModel(
              value.customerOrdered ?? [], value.categories ?? []);

          printMe("Beat list length : ${value.beatsEventData!.length}");
          printMe("Beat Data length : ${value.beatsData!.length}");
          printMe(
              "Total beat : $totalBeats, Total Completed Customers : $completedCustomers, Total Pending Customers : $pendingCustomers");
          isDataLoad = true;
        } else {
          Widgets().showToast("Data not found!");
          isDataLoad = false;
          isNullData = true;
        }
      } catch (e, r) {
        printErrors("Error: $e");
        print(r);
        print("_________-");
        Get.back();
      }
      // Get.back();
      update();
    });
  }

  //My beat get beats and events
  Future<GetEventsAllocationResponse?> getEventsAllocationApi({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "month": month,
      "year": year,
      "currentStart": currentStart,
      "currentEnd": currentEnd,
    };

    //var map = {"customerScreenName": "a07864", "month": "", "year": "", "currentStart": "01/10/2023", "currentEnd": "31/10/2023"};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getEventsAllocation, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetEventsAllocationResponse myBeatResponseModel =
              GetEventsAllocationResponse.fromJson(value);
          return myBeatResponseModel;
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

//-----------------------------------------------------------------------------------
  ///Add event for approval
  addEventsForApproval({
    required List<EventsData> eventsData,
    required String submittedBy,
    required String submittedTo,
    required String month,
    required String year,
  }) {
    //Add loader
    addEventsForApprovalApi(
      eventsData: eventsData,
      submittedBy: submittedBy,
      submittedTo: submittedTo,
      month: month,
      year: year,
    ).then((value) {
      Get.back();
      Widgets().showToast(value!.errorMessage.toString());
    });
  }

  //Add evens for approval
  Future<AddEventsForApprovalResponse?> addEventsForApprovalApi({
    required List<EventsData> eventsData,
    required String submittedBy,
    required String submittedTo,
    required String month,
    required String year,
  }) {
    AddEventsForApprovalRequest addEventsForApprovalRequest =
        AddEventsForApprovalRequest();
    addEventsForApprovalRequest.eventsData = eventsData;
    addEventsForApprovalRequest.screenName =
        globalController.customerScreenName;
    addEventsForApprovalRequest.submittedBy = submittedBy;
    addEventsForApprovalRequest.submittedTo = submittedTo;
    addEventsForApprovalRequest.month = month;
    addEventsForApprovalRequest.year = year;

    var requestJson = jsonEncode(addEventsForApprovalRequest.toJson());

    return ApiService.postRequest(
            ApiConstants.addEventsForApproval, requestJson)
        .then((value) {
      try {
        if (value != null) {
          AddEventsForApprovalResponse addEventsForApprovalResponse =
              AddEventsForApprovalResponse.fromJson(value);
          return addEventsForApprovalResponse;
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

  //-----------------------------------------------------------------------------------
  ///Get User list data api
  List<String> userList = [];

  getUserListData(String userListName) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    // Widgets().loadingDataDialog(loadingText: "User list data is fetching!");

    try {
      final value = await getUserListDataApi();
      // Get.back();

      if (value != null) {
        userList = value.userList ?? [];
        printMe("User list is: ${value.userList?.length.toString()}");
        return userList;
      } else {
        Widgets().showToast("User list is empty!");
        return [];
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return [];
    }
  }

  Future<GetUserListDataResponse?> getUserListDataApi() {
    //TODO : add this map when response coming properly
    // var map = {
    //   "customerScreenName": globalController.customerScreenName,
    // };

    var map = {
      "customerScreenName": globalController.customerScreenName,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getUserListData, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetUserListDataResponse getUserListDataResponse =
              GetUserListDataResponse.fromJson(value);
          return getUserListDataResponse;
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

  //---------------------------------------------------------------------------------
  List<CustomerData> customerData = [];

  int openTileIndex = -1;

  void handleTileTapped(int index) {
    if (openTileIndex == index) {
      openTileIndex = -1;
    } else {
      openTileIndex = index;
    }

    update();
  }

  List<ChartSampleData> createPieChartModel(
      int? yTotal, int? yPending, int? yCompleted) {
    var items = <ChartSampleData>[
      ChartSampleData(
          x: 'Total Allocated Customers',
          y: yTotal ?? 0,
          text: generateStatusText(yCompleted, yPending, yTotal, 'total'),
          pointColor: Colors.yellow),
      ChartSampleData(
          x: 'Pending Customers',
          y: yPending ?? 0,
          text: generateStatusText(yCompleted, yPending, yTotal, 'pending')),
      ChartSampleData(
          x: 'Completed Customers',
          y: yCompleted ?? 0,
          text: generateStatusText(
            yCompleted,
            yPending,
            yTotal,
            'completed',
          )),
    ];

    return items;
  }

  getPieChartColors() {
    return [
      const Color(0xff619DFF),
      const Color(0xffFFB538),
      const Color(0xff46DDCC),
    ];
  }

  String generateStatusText(
      int? completed, int? pending, int? yTotal, String flag) {
    if (completed == null && pending == null && yTotal == null) {
      return 'No data available for $flag';
    }
    int total = (completed ?? 0) + (pending ?? 0) + (yTotal ?? 0);
    if (flag.toLowerCase() == 'completed' && completed != null) {
      double percentage = (completed / total) * 100;
      return 'Completed \n ${percentage.toStringAsFixed(2)}%';
    } else if (flag.toLowerCase() == 'pending' && pending != null) {
      double percentage = (pending / total) * 100;
      return 'Pending \n ${percentage.toStringAsFixed(2)}%';
    } else if (flag.toLowerCase() == 'total' && yTotal != null) {
      double percentage = (yTotal / total) * 100;
      return 'Total \n ${percentage.toStringAsFixed(2)}%';
    } else {
      return 'Invalid flag: $flag';
    }
  }

  ///Get customer details
  Future<GetCustomerDetailsResponse?> getCustomerDetails({
    required String beatCode,
  }) async {
    customerData = [];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets()
          .loadingDataDialog(loadingText: "Please wait while Loading data..");
    });
    return await getCustomerDetailsApi(beatCode: beatCode).then((value) {
      Get.back();

      customerData = value?.customerData ?? [];
      update();
      return value;

      // Get.back();
    });
  }

  Future<GetCustomerDetailsResponse?> getCustomerDetailsApi(
      {required String beatCode}) {
    var map = {
      "EmployeeScreenName": globalController.customerScreenName,
      "beatCode": beatCode,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getCustomerMapping, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetCustomerDetailsResponse getCustomerDetailsResponse =
              GetCustomerDetailsResponse.fromJson(value);
          return getCustomerDetailsResponse;
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

  ///Get customer address api
  List<CustomerMap> customerMapList = [];

  getCustomerAddress({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
  }) {
    //Add loader
    getCustomerAddressApi(
            month: month,
            year: year,
            currentStart: currentStart,
            currentEnd: currentEnd)
        .then((value) {
      Get.back();
      try {
        if (value != null) {
          customerMapList = value.customerMap ?? [];
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

  Future<GetCustomerAddressResponse?> getCustomerAddressApi({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "month": month,
      "year": year,
      "currentStart": currentStart,
      "currentEnd": currentEnd,
    };

    //var map = {"customerScreenName": "a07864", "month": "11", "year": "2023", "currentStart": "08/11/2023", "currentEnd": "30/11/2023"};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getCustomerAddress, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetCustomerAddressResponse getCustomerAddressResponse =
              GetCustomerAddressResponse.fromJson(value);
          return getCustomerAddressResponse;
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

  List<ChartSampleData> cartesianChartModel(
    List<String> customerOrdered,
    List<String> categories,
  ) {
    print("customerOrdered.length");
    print(customerOrdered.length);
    print("categories length");

    print(categories.length);
    var items = <ChartSampleData>[];

    if (categories.length == customerOrdered.length) {
      for (int i = 0; i < customerOrdered.length; i++) {
        items.add(ChartSampleData(
            x: categories[i].toString(),
            y: int.tryParse(
                  customerOrdered[i],
                ) ??
                0,
            secondSeriesYValue: double.tryParse(pendingCustomers ?? "0") ?? 0));
      }
    }

    return items;
  }
}
