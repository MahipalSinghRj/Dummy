import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../../common/AppBar.dart';
import '../../../../common/Drawer.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../controllers/AddBeatController.dart';
import '../../models/requestModels/AddEventsForApprovalRequest.dart';
import '../../models/responseModels/GetEventsAllocationResponse.dart';
import '../my_beat/MyBeat.dart';

class AddBeat extends StatefulWidget {
  final String? customerCode;
  final String flag;

  const AddBeat(this.customerCode, this.flag, {Key? key}) : super(key: key);

  @override
  State<AddBeat> createState() => _AddBeatState();
}

class _AddBeatState extends State<AddBeat> {
  final TextEditingController commentController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;
  final TextEditingController searchController = TextEditingController();
  final AddBeatController addBeatController = Get.put(AddBeatController());
  List<Color> topFiveProductColor = [
    lochmara,
    caribbeanGreenColor,
    mySinColor,
    burntSiennaColor,
    cornflowerDarkBlueColor
  ];

  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  // IndividualUploadController addBeatController = Get.put(IndividualUploadController());

  List<BeatsData> beatsDataDataList = [];

  bool isData = false;

  List<BeatsData> selectedDataList = [];

  var formattedMonth, formattedYear;

  @override
  void initState() {
    /* SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });*/
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    addBeatController.currentScreenName = widget.customerCode.toString();

    addBeatController.currentYear = dateTimeUtils.getCurrentYear();
    addBeatController.currentMonth = dateTimeUtils.getCurrentMonth();
    addBeatController.currentStart = dateTimeUtils.getStartOfMonth();
    addBeatController.currentEnd = dateTimeUtils.getEndOfMonth();
    addBeatController.setMonthData();

    if (widget.customerCode != null) {
      await addBeatController.getEventsAllocation(
          month: addBeatController.currentMonth,
          year: addBeatController.currentYear,
          currentStart: addBeatController.currentStart,
          currentEnd: addBeatController.currentEnd,
          customerScreenName: addBeatController.currentScreenName);
      // controller.getEventsAllocation(
      //     month: "", year: "", currentStart: controller.currentStart, currentEnd: controller.currentEnd, customerScreenName: widget.customerCode!);
    }
    printMe("Events : ${addBeatController.beatsEventDataList.length}");
    printMe("Beats : ${addBeatController.beatsDataDataList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddBeatController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: MainAppBar(context, scaffoldKey),
          drawer: MainDrawer(context),
          body: Stack(
            children: [
              Positioned(left: 0, right: 0, top: 10, child: _myCalenderEvent()),
              Positioned(
                left: 0,
                right: 0,
                bottom: 4.h,
                child: Widgets().customLRPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () {
                            // Get.back();
                            Get.off(() => MyBeat());
                          },
                          height: 6.h,
                          width: 45.w,
                          buttonBGColor: codGray,
                          titleText: 'Cancel',
                          titleColor: white),
                      Widgets().dynamicButton(
                          onTap: () async {
                            printMe(
                                "List Size : ${addBeatController.beatCalData.length}");
                            printMe("formattedMonth : $formattedMonth");
                            printMe("formattedYear : $formattedYear");

                            if (addBeatController.beatCalData.isEmpty) {
                              Widgets().showToast('Please select a beat !!');
                            } else {
                              // if (selectedItems.isEmpty) {
                              //   Widgets().showToast('Please select a beat !!');
                              //   return;
                              // }
                              SchedulerBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                Widgets().loadingDataDialog(
                                    loadingText: "Loading data...");
                              });

                              final result =
                                  await addBeatController.addEventsForApproval(
                                      eventsData:
                                          addBeatController.addToCalenderList,
                                      submittedBy: globalController.role ==
                                                  'TSI' &&
                                              widget.flag == 'MyBeat'
                                          ? globalController.customerScreenName
                                          : '',
                                      submittedTo: '',
                                      month: formattedMonth,
                                      year: formattedYear,
                                      screenName:
                                          addBeatController.currentScreenName);
                              selectedDataList.clear();
                              if (result) {
                                Widgets().orderForApprovalBottomSheet(
                                    context: context,
                                    onTapOk: () {
                                      Get.back();
                                      // Get.back();
                                      Get.off(() => MyBeat());
                                    });
                              } else {
                                setState(() {});
                              }
                            }
                          },
                          height: 6.h,
                          width: 45.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: addBeatController.getButtonName(
                              globalController.role, widget.flag),
                          titleColor: white)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _myCalenderEvent() {
    return SfCalendar(
      view: addBeatController.cView,
      dataSource: MeetingDataSource(addBeatController.beatsEventDataList),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 60),
        startHour: 0,
        endHour: 0,
      ),
      onTap: (tap) {
        var selectedDate = DateTimeUtils().formatDateTime(tap.date!);
        printMe("Clicked Date : $selectedDate");
        getDateMonthYear(selectedDate);

        List<BeatsEventData> localEventList = [];
        for (int i = 0; i < tap.appointments!.length; i++) {
          BeatsEventData eventData = tap.appointments![i];
          localEventList.add(eventData);
        }
        // // addBeatController.resetSelection();
        addBeatController
            .upDateSelection(addBeatController.getSelectedBeats(selectedDate));
        addBeatController.upDateSelectionForCurrentSelectionList(
            addBeatController
                .getSelectedBeatsFromCurrentSelectionList(selectedDate));

        //reset selection
        showNewBottomSheet(addBeatController, searchController, tap.date);
      },
      onViewChanged: (viewChangedDetails) async {
        CalendarView currentView = addBeatController.cView;
        List<DateTime> visibleDates = viewChangedDetails.visibleDates;
        int currentYear = DateTime.now().year;
        int currentMonth = DateTime.now().month;
        currentYear = visibleDates[0].year;
        currentMonth = visibleDates[0].month;
        String startDate = addBeatController.currentStart;
        String endDate = addBeatController.currentEnd;
        print('controller.currentStart');
        print(addBeatController.currentStart);

        String operationView = '';

        if (currentView == CalendarView.day) {
          DateTime today = visibleDates[0];
          DateTime tomorrow = today.add(const Duration(days: 1));
          startDate = DateFormat('dd/MM/yyyy').format(today);
          endDate = DateFormat('dd/MM/yyyy').format(tomorrow);
          operationView = 'Daily';
        } else if (currentView == CalendarView.week) {
          DateTime weekStartDate = visibleDates[0];
          DateTime weekEndDate = visibleDates[visibleDates.length - 1];
          startDate = DateFormat('dd/MM/yyyy').format(weekStartDate);
          endDate = DateFormat('dd/MM/yyyy').format(weekEndDate);
          operationView = 'Weekly';
        } else if (currentView == CalendarView.month) {
          currentYear = visibleDates[10].year;
          currentMonth = visibleDates[10].month;
          startDate = dateTimeUtils.getFirstDateOfMonthFormatted(currentMonth);
          endDate = dateTimeUtils.getLastDateOfMonthFormatted(currentMonth);
          operationView = 'Monthly';
        }

        addBeatController.updateCurrentDates(
          operationView,
          currentYear.toString(),
          currentMonth.toString(),
          startDate.toString(),
          endDate.toString(),
        );

        await addBeatController.getEventsAllocation(
          month: addBeatController.currentMonth,
          year: addBeatController.currentYear,
          currentStart: addBeatController.currentStart,
          currentEnd: addBeatController.currentEnd,
          customerScreenName: addBeatController.currentScreenName,
        );
      },
      /*onSelectionChanged: (calendarSelectionDetails) {

      },*/
    );
  }

  void checkedItems1(List<BeatsData> list) {
    for (BeatsData item in list) {
      if (item.isSelected == false) {
        selectedDataList.removeWhere((selectedItem) =>
            selectedItem.beateatAllocationMasterId ==
            item.beateatAllocationMasterId);
      } else {
        selectedDataList.add(item);
      }
    }
    selectedDataList = removeDuplicates(selectedDataList);
    printMe("Selected List length : ${selectedDataList.length}");
  }

  List<BeatsData> removeDuplicates(List<BeatsData> list) {
    List<BeatsData> uniqueList = [];
    Set<String> uniqueIds = {};

    for (BeatsData item in list) {
      if (item.beateatAllocationMasterId != null &&
          !uniqueIds.contains(item.beateatAllocationMasterId!)) {
        uniqueList.add(item);
        uniqueIds.add(item.beateatAllocationMasterId!);
      }
    }

    return uniqueList;
  }

  showNewBottomSheet(AddBeatController controller,
      TextEditingController searchController, date) {
    String searchContext = '';
    return Get.bottomSheet(StatefulBuilder(// this is new
        builder: (BuildContext context, StateSetter mySetState) {
      return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 4,
                offset: Offset(0, -4),
                spreadRadius: 5,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Beats Available",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: codGray,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                            letterSpacing: .3),
                        textAlign: TextAlign.start,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                ),
                Widgets().verticalSpace(2.5.h),
                Widgets().horizontalDivider(),
                Widgets().verticalSpace(2.5.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Widgets().textFieldWidget(
                      controller: searchController,
                      hintText: 'Search',
                      iconName: search,
                      onChanged: (val) {
                        searchContext = val ?? '';
                        mySetState(() {});
                      },
                      keyBoardType: TextInputType.text,
                      fillColor: zumthor),
                ),
                ListView.builder(
                  itemCount: controller.beatsDataDataList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var items = controller.beatsDataDataList[index];
                    return (items.beatCode ?? "")
                            .toLowerCase()
                            .contains(searchContext)
                        ? Widgets().customLRPadding(
                            child: Row(
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(.5.h)),
                                  activeColor: alizarinCrimson,
                                  side: BorderSide(
                                      width: 9,
                                      color: checkBoxColor,
                                      style: BorderStyle.solid),
                                  value: items.isSelected ?? false,
                                  onChanged: (value) {
                                    mySetState(() {
                                      items.isSelected = value!;

                                      List<BeatsData> selectedDataList = [];
                                      selectedDataList.add(items);
                                      var selectedDate =
                                          DateTimeUtils().formatDateTime(date!);

                                      controller.addCheckBoxDataToCalender(
                                          value,
                                          EventsData(
                                              start: selectedDate,
                                              end: selectedDate,
                                              title: items.beatCode));

                                      checkedItems1(selectedDataList);
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(
                                    titleText: "${items.beatCode}",
                                    fontSize: 9.sp,
                                    textColor: codGray),
                                const Spacer(),
                                Widgets().textWidgetWithW400(
                                    titleText:
                                        "${items.noOfCustomers} Customers",
                                    fontSize: 9.sp,
                                    textColor: codGray),
                              ],
                            ),
                          )
                        : Container();
                  },
                ),
                Widgets().customLRPadding(
                    child: Widgets().dynamicButton(
                        onTap: () {
                          addBeatController.beatCalData.clear();
                          for (int i = 0; i < selectedDataList.length; i++) {
                            EventsData beat = EventsData(
                                title: '${selectedDataList[i].beatCode}',
                                start: DateTimeUtils().formatDateTime(date),
                                end: DateTimeUtils().formatDateTime(date));
                            addBeatController.beatCalData.add(beat);
                          }
                          printMe(
                              "addBeatController.beatCalData length : ${selectedDataList.length}");

                          for (int i = 0;
                              i < addBeatController.beatsEventDataList.length;
                              i++) {
                            EventsData beat = EventsData(
                                title:
                                    '${addBeatController.beatsEventDataList[i].beatCode}',
                                start: addBeatController
                                    .beatsEventDataList[i].start,
                                end: addBeatController
                                    .beatsEventDataList[i].end);
                            addBeatController.beatCalData.add(beat);
                          }
                          addBeatController.addToCalenderList = addBeatController
                              .getFinalSelectionListWithBeatsSelectedAndAllocated();

                          Get.back();
                          // Get.back();
                        },
                        height: 5.h,
                        width: 100.w,
                        buttonBGColor: alizarinCrimson,
                        titleText: "Add to Calendar",
                        titleColor: white)),
                Widgets().verticalSpace(2.5.h),
              ],
            ),
          ),
        ),
      );
    }));
  }

  getDateMonthYear(String dateStr) {
    // Split the date string into day, month, and year components
    List<String> dateComponents = dateStr.split('/');
    if (dateComponents.length != 3) {
      return "Invalid Date";
    }

    int day = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int year = int.parse(dateComponents[2]);

    // Create a DateTime object from the components
    DateTime dateTime = DateTime(year, month, day);

    // Format the month and year
    formattedMonth = "${dateTime.month}";
    formattedYear = "${dateTime.year}";

    printMe("Month: $formattedMonth, Year: $formattedYear");
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<BeatsEventData> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    var sDate =
        DateTimeUtils().convertDateFormatN(_getMeetingData(index).start!);
    DateTime startTime = DateTime.parse(sDate);
    return startTime;
  }

  @override
  DateTime getEndTime(int index) {
    var eDate =
        DateTimeUtils().convertDateFormatN(_getMeetingData(index).start!);
    DateTime endTime = DateTime.parse(eDate);
    return endTime;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).title!;
  }

  BeatsEventData _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final BeatsEventData meetingData;
    if (meeting is BeatsEventData) {
      meetingData = meeting;
    }
    return meetingData;
  }
}
