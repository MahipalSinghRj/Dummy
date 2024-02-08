import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../common/Drawer.dart';
import '../../../common/widgets.dart';
import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../../../utils/ChartsSupportClasses.dart';
import '../../../utils/DateTimeUtils.dart';
import '../models/requestModels/AddEventsForApprovalRequest.dart';
import '../models/responseModels/AddEventsForApprovalResponse.dart';
import '../models/responseModels/GetCustomerDetailsResponse.dart';
import '../models/responseModels/GetEventsAllocationResponse.dart';
import '../models/responseModels/GetUserListDataResponse.dart';

class IndividualUploadController extends GetxController {
  ///Get User list data api
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  List<String> userList = [];
  List<String> userNameList = [];
  List<BeatsEventData> beatsEventDataList = [];
  List<BeatsData> beatsDataDataList = [];

  String totalBeats = "N/A";
  String completedCustomers = "N/A";
  String pendingCustomers = "N/A";
  List<ChartSampleData> createPieChartModelList = [];
  List<ChartSampleData> cartesianChartModelList = [];
  String currentStart = '';
  String currentEnd = '';
  String currentScreenName = '';
  String currentScreenNameToShowInUI = '';

  List<CustomerData> customerData = [];
  CalendarView cView = CalendarView.month;

  // updateSearch() {
  //   searchTextController.text = currentScreenName;
  //   update();
  // }

  updateCurrentScreenNameToShowInUI(String input) {
    currentScreenNameToShowInUI = input;
    update();
  }

  bool isEmptyData() {
    if ((totalBeats == "N/A" &&
            completedCustomers == "N/A" &&
            pendingCustomers == "N/A") ||
        (totalBeats.isEmpty &&
            completedCustomers.isEmpty &&
            pendingCustomers.isEmpty)) {
      return true;
    }

    return false;
  }

  clearData() {
    userList = [];
    userNameList = [];
    beatsEventDataList = [];
    totalBeats = "N/A";
    completedCustomers = "N/A";
    pendingCustomers = "N/A";
    createPieChartModelList = [];
  }

  bool showBodyVisibility = false;

  updateVisibilityToFalse() {
    showBodyVisibility = false;
    update();
  }

  updateVisibilityToTrue() {
    showBodyVisibility = true;
    update();
  }

  setMonthData() {
    currentStart = dateTimeUtils.getStartOfMonth();
    currentEnd = dateTimeUtils.getEndOfMonth();

    update();
  }

  getUserListData(String userListName) async {
    showBodyVisibility = false;
    update();
    Widgets().loadingDataDialog(loadingText: "Loading data, Please wait!");

    try {
      userList = [];
      userNameList = [];
      final value = await getUserListDataApi(userListName);
      Get.back();

      if (value != null && value.userList != null) {
        if (value.userList!.isEmpty) {
          Widgets().showToast("Employees are not assigned to the user");
        }
        userList = value.userList ?? [];
        userNameList = value.userNamesList ?? [];
        printMe("User list is: ${value.userList?.length.toString()}");
        return userList;
      } else {
        Widgets().showToast("Employees are not assigned to the user");

        Widgets().showToast("User list is empty!");
        return [];
      }
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return [];
    }
  }

  getEventsAllocation({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
    required String customerScreenName,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await getEventsAllocationApi(
            month: month,
            year: year,
            currentStart: currentStart,
            currentEnd: currentEnd,
            customerScreenName: customerScreenName)
        .then((value) {
      Get.back();

      try {
        if (value != null) {
          createPieChartModelList = [];

          int? totalCustomersY = int.tryParse(value.totalBeats ?? "0");
          int? pendingCustomersY = int.tryParse(value.pendingCustomers ?? "0");
          int? completedCustomersY =
              int.tryParse(value.completedCustomers ?? "0");

          print("totalCustomersY");
          print(totalCustomersY);
          print(pendingCustomersY);
          print(completedCustomersY);

          createPieChartModelList = createPieChartModel(
              totalCustomersY, pendingCustomersY, completedCustomersY);
          beatsEventDataList = [];
          beatsDataDataList = [];
          cartesianChartModelList = [];
          totalBeats = value.totalBeats ?? '';
          completedCustomers = value.completedCustomers ?? '';
          pendingCustomers = value.pendingCustomers ?? '';
          beatsEventDataList = value.beatsEventData ?? [];
          beatsDataDataList = value.beatsData ?? [];

          showBodyVisibility = true;
          if (!(cView == CalendarView.day)) {
            cartesianChartModelList = cartesianChartModel(
                value.customerOrdered ?? [], value.categories ?? []);
          }

          printMe("Beat list length : ${value.beatsEventData!.length}");
          printMe(
              "Total beat : $totalBeats, Total Completed Customers : $completedCustomers, Total Pending Customers : $pendingCustomers");
        } else {
          Widgets().showToast("Data not found!");
        }
      } catch (e, r) {
        printErrors("Error: $e");
        Get.back();
      }
      update();
    });
  }

  List<ChartSampleData> cartesianChartModel(
    List<String> customerOrdered,
    List<String> categories,
  ) {
    var items = <ChartSampleData>[];

    if (categories.length == customerOrdered.length) {
      for (int i = 0; i < customerOrdered.length; i++) {
        items.add(ChartSampleData(
            x: categories[i].toString(),
            y: int.tryParse(
                  customerOrdered[i],
                ) ??
                0));
      }
    }

    return items;
  }

  List<ChartSampleData> createPieChartModel(
      int? yTotal, int? yPending, int? yCompleted) {
    var items = <ChartSampleData>[
      ChartSampleData(
          x: 'Total Allocated Beats',
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

  ///api calls

  Future<GetUserListDataResponse?> getUserListDataApi(String userListName) {
    //TODO : add this map when response coming properly
    var map = {
      "customerScreenName": userListName,
    };

    // var map = {
    //   "customerScreenName": "a07530",
    // };

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

  //My beat get beats and events
  Future<GetEventsAllocationResponse?> getEventsAllocationApi({
    required String month,
    required String year,
    required String currentStart,
    required String currentEnd,
    required String customerScreenName,
  }) {
    //TODO : Add these map when data is coming properly
    var map = {
      "customerScreenName": customerScreenName,
      "month": month,
      "year": year,
      "currentStart": currentStart,
      "currentEnd": currentEnd,
    };

    // var map = {"customerScreenName": "a07864", "month": "", "year": "", "currentStart": "01/10/2023", "currentEnd": "31/10/2023"};

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

  ///Get customer details
  Future<GetCustomerDetailsResponse?> getCustomerDetails({
    required String beatCode,
    required String employeeScreenName,
  }) async {
    customerData = [];

    Widgets()
        .loadingDataDialog(loadingText: "Please wait while Loading data..");

    await getCustomerDetailsApi(
            beatCode: beatCode, employeeScreenName: employeeScreenName)
        .then((value) {
      Get.back();

      customerData = value?.customerData ?? [];

      return value;

      // Get.back();
    });

    update();
  }

  Future<GetCustomerDetailsResponse?> getCustomerDetailsApi({
    required String beatCode,
    required String employeeScreenName,
  }) {
    // var map = {
    //   "EmployeeScreenName": "a07864",
    //   "beatCode": beatCode,
    // };
    //
    var map = {
      "EmployeeScreenName": employeeScreenName,
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

  List<String> calenderViewList = ["Daily", "Weekly", "Monthly"];
  String? calenderViewSelected = 'Monthly';

  String? calenderViewSelectedBarGraph = 'Monthly';

  bool isDataLoad = false;

  bool isNullData = false;
  String currentYear = '';
  String currentMonth = '';

  updateCalenderView(
    String operation,
  ) {
    print(operation);
    switch (operation) {
      case 'Daily':
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
          update();
        }
        break;

      default:
        {
          currentYear = dateTimeUtils.getCurrentYear();
          currentMonth = dateTimeUtils.getCurrentMonth();
          currentStart = dateTimeUtils.getStartOfMonth();
          currentEnd = dateTimeUtils.getEndOfMonth();
          update();
        }
    }

    print("operation " + operation);
    print("currentYear " + currentYear);
    print("currentMonth " + currentMonth);
    print("currentStart " + currentStart);
    print("currentEnd " + currentEnd);
  }
}
