import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

class AddBeatController extends GetxController {
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  List<String> userList = [];
  List<String> userNameList = [];
  List<BeatsEventData> beatsEventDataList = [];
  List<BeatsEventData> localBeatsEventDataList = [];
  List<BeatsData> beatsDataDataList = [];

  String totalBeats = "N/A";
  String completedCustomers = "N/A";
  String pendingCustomers = "N/A";
  List<ChartSampleData> createPieChartModelList = [];
  List<ChartSampleData> cartesianChartModelList = [];
  String currentStart = '';
  String currentEnd = '';
  String currentScreenName = '';

  List<CustomerData> customerData = [];
  CalendarView cView = CalendarView.month;
  List<EventsData> beatCalData = [];

  List<EventsData> addToCalenderList = [];
  List<EventsData> addToCalenderListDuplicateList = [];

  addApiDataToCalender(List<BeatsEventData> beatsEventDataList) {
    //refresh it with every event data update i.e, api call
    addToCalenderList = [];
    addToCalenderListDuplicateList = [];
    if (beatsEventDataList.isNotEmpty) {
      for (var item in beatsEventDataList) {
        addToCalenderList.add(
            EventsData(start: item.start, end: item.end, title: item.title));
      }
    }
    update();
  }

  // List<EventsData> getFinalSelectionListWithBeatsSelectedAndAllocated() {
  //   List<EventsData> firstList = addToCalenderList;
  //   List<EventsData> secondList = currentSelectionList;
  //   List<EventsData> itemsToRemoveList = addToCalenderListDuplicateList;
  //
  //   List<EventsData> totalList = [];
  //
  //    totalList.addAll(firstList);
  //
  //    for (var item in secondList) {
  //     if (!totalList.any((event) =>
  //     event.start == item.start &&
  //         event.end == item.end &&
  //         event.title == item.title)) {
  //       totalList.add(item);
  //     }
  //   }
  //    update();
  //
  //   return totalList;
  // }
  List<EventsData> getFinalSelectionListWithBeatsSelectedAndAllocated() {
    List<EventsData> firstList = beatCalData;
    List<EventsData> secondList = currentSelectionList;
    List<EventsData> itemsToRemoveList = addToCalenderListDuplicateList;
    List<EventsData> totalList = [];

    // Add items from the first list
    totalList.addAll(firstList);

    // Add items from the second list that are not already in the total list
    for (var item in secondList) {
      if (!totalList.any((event) =>
          event.start == item.start &&
          event.end == item.end &&
          event.title == item.title)) {
        totalList.add(item);
      }
    }

    // Remove items from itemsToRemoveList in the totalList
    totalList.removeWhere((item) => itemsToRemoveList.any(
        (event) => event.start == item.start && event.title == item.title));

    update();

    return totalList;
  }

  List<EventsData> currentSelectionList = [];

  void addCheckBoxDataToCalender(
      bool isSelected, EventsData manualSelectionData) {
    bool itemExistsInDuplicateData = beatsEventDataList.any((item) =>
        item.start == manualSelectionData.start &&
        item.title == manualSelectionData.title);
    //that means selction is done with in the items from api
    // if item is removed add removed item list, if items added again than remove
    // print('itemExistsInDuplicateData');
    // print(itemExistsInDuplicateData);
    if (itemExistsInDuplicateData) {
      if (!isSelected) {
        addToCalenderListDuplicateList.add(manualSelectionData);
      } else {
        bool itemIsAddedAgain = addToCalenderListDuplicateList.any((item) =>
            item.start == manualSelectionData.start &&
            item.end == manualSelectionData.end &&
            item.title == manualSelectionData.title);
        if (itemIsAddedAgain) {
          addToCalenderListDuplicateList.remove(manualSelectionData);
        }
      }
    }

    printWarning(manualSelectionData.title);
    printWarning(manualSelectionData.start);
    printWarning(manualSelectionData.end);

    bool shouldBeAdded = false;
    bool shouldBeRemoved = false;

    // Check if the item already exists in the currentSelectionList
    bool itemExists = currentSelectionList.any((item) =>
        item.start == manualSelectionData.start &&
        item.end == manualSelectionData.end &&
        item.title == manualSelectionData.title);

    if (isSelected) {
      // Add the item if it doesn't exist in the list
      shouldBeAdded = !itemExists;
    } else {
      // Remove the item if it exists in the list
      shouldBeRemoved = itemExists;
    }

    if (shouldBeAdded) {
      currentSelectionList.add(manualSelectionData);
      printAchievement("Item added to the list.");
    }

    if (shouldBeRemoved) {
      currentSelectionList.removeWhere((item) =>
          item.start == manualSelectionData.start &&
          item.end == manualSelectionData.end &&
          item.title == manualSelectionData.title);
      printAchievement("Item removed from the list.");
    }

    // Remove duplicates from the list
    Set<EventsData> uniqueSet = {};
    uniqueSet.addAll(currentSelectionList);
    currentSelectionList = uniqueSet.toList();

    for (var item in currentSelectionList) {
      print(item.title);
      print(item.start);
      print(item.end);
      print("*********");
    }
    addToCalenderList = currentSelectionList;
    update();
  }

  List<String> getSelectedBeatsFromCurrentSelectionList(String startDate) {
    List<String> selectedBeats = [];

    if (currentSelectionList.isNotEmpty) {
      for (var item in currentSelectionList) {
        if (item.start == startDate) {
          selectedBeats.add(item.title.toString());
        }
      }
    }

    return selectedBeats;
  }

  upDateSelectionForCurrentSelectionList(List<String> selectedBeats) {
    if (beatsDataDataList.isNotEmpty) {
      for (var item in beatsDataDataList) {
        if (selectedBeats.isNotEmpty) {
          if (selectedBeats.contains(item.beatCode)) {
            item.isSelected = true;
          }
        }
      }
    }

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

  resetSelection() {
    if (beatsDataDataList.isNotEmpty) {
      for (var item in beatsDataDataList) {
        item.isSelected = false;
      }
    }
    currentSelectionList = [];

    update();
  }

  upDateSelection(List<String> selectedBeats) {
    if (beatsDataDataList.isNotEmpty) {
      for (var item in beatsDataDataList) {
        if (selectedBeats.isNotEmpty) {
          if (selectedBeats.contains(item.beatCode)) {
            item.isSelected = true;
          } else {
            item.isSelected = false;
          }
        } else {
          item.isSelected = false;
        }
      }
    }

    update();
  }

  List<String> getSelectedBeats(String startDate) {
    List<String> selectedBeats = [];

    if (beatsEventDataList.isNotEmpty) {
      for (BeatsEventData item in beatsEventDataList) {
        if (item.start == startDate) {
          selectedBeats.add(item.beatCode.toString());
        }
      }
    }

    return selectedBeats;
  }

  bool showBodyVisibility = false;

  updateVisibilityToFalse() {
    showBodyVisibility = false;
    update();
  }

  setMonthData() {
    currentStart = dateTimeUtils.getStartOfMonth();
    currentEnd = dateTimeUtils.getEndOfMonth();

    update();
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
          // createPieChartModelList = [];

          // int? totalCustomersY = int.tryParse(value.totalBeats ?? "0");
          // int? pendingCustomersY = int.tryParse(value.pendingCustomers ?? "0");
          // int? completedCustomersY =
          //     int.tryParse(value.completedCustomers ?? "0");

          // print("totalCustomersY");
          // print(totalCustomersY);
          // print(pendingCustomersY);
          // print(completedCustomersY);

          // createPieChartModelList = createPieChartModel(
          //     totalCustomersY, pendingCustomersY, completedCustomersY);
          beatsEventDataList = [];
          localBeatsEventDataList = [];
          beatsDataDataList = [];
          // cartesianChartModelList = [];
          // totalBeats = value.totalBeats ?? '';
          // completedCustomers = value.completedCustomers ?? '';
          // pendingCustomers = value.pendingCustomers ?? '';
          beatsEventDataList = value.beatsEventData ?? [];
          localBeatsEventDataList.addAll(beatsEventDataList);
          beatsDataDataList = value.beatsData ?? [];

          // showBodyVisibility = true;
          // cartesianChartModelList = cartesianChartModel(
          //     value.customerOrdered ?? [], value.categories ?? []);
          addApiDataToCalender(beatsEventDataList);

          printMe("Beat list length : ${value.beatsEventData!.length}");
          printMe(
              "Total beat : $totalBeats, Total Completed Customers : $completedCustomers, Total Pending Customers : $pendingCustomers");
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
    print("BOdy =====");
    printMe(map);

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
  Future<bool> addEventsForApproval({
    required List<EventsData> eventsData,
    required String submittedBy,
    required String submittedTo,
    required String month,
    required String year,
    required String screenName,
  }) async {
    //Add loader
    final value = await addEventsForApprovalApi(
      eventsData: eventsData,
      submittedBy: submittedBy,
      submittedTo: submittedTo,
      month: month,
      year: year,
      screenName: screenName,
    );

    Get.back();
    if (value != null) {
      Widgets().showToast(value!.errorMessage.toString());
      await resetSelection();
      update();
      await getEventsAllocation(
          month: currentMonth,
          year: currentYear,
          currentStart: currentStart,
          currentEnd: currentEnd,
          customerScreenName: currentScreenName);
      return true;
    } else {
      return false;
    }
  }

//Add evens for approval
  Future<AddEventsForApprovalResponse?> addEventsForApprovalApi({
    required List<EventsData> eventsData,
    required String submittedBy,
    required String submittedTo,
    required String month,
    required String year,
    required String screenName,
  }) async {
    AddEventsForApprovalRequest addEventsForApprovalRequest =
        AddEventsForApprovalRequest();
    addEventsForApprovalRequest.eventsData = eventsData;
    addEventsForApprovalRequest.screenName = screenName;
    addEventsForApprovalRequest.submittedBy = submittedBy;
    addEventsForApprovalRequest.submittedTo = submittedTo;
    addEventsForApprovalRequest.month = month;
    addEventsForApprovalRequest.year = year;

    var requestJson = jsonEncode(addEventsForApprovalRequest.toJson());
    printMe("REQUEST JSON FOR BEAT APPROVAL ====================");
    printMe(requestJson);
    return await ApiService.postRequest(
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

//1.ASM
// and adding beats to TSI;
// screenName as tsi screenName
// submitted:to and submittedBy will be blank
// 2.TSI
// a) adding beats to last
// screenName as LAS screenName
// submitted:to and submittedBy will be blank
//
//
// b)beat himself
// screenName TSI
// and submittedBy TSI
//
// 3.LAS

  getButtonName(String userRole, String flag) {
    if (userRole == 'TSI') {
      if (flag == 'MyBeat') {
        return "Request For Approval";
      } else if (flag == 'beat') {
        return "Save";
      }
    } else {
      return 'Save';
    }

    //
  }

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
}
