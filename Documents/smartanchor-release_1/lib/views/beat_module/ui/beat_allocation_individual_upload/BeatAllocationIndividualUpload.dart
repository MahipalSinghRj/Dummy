import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../utils/ChartsSupportClasses.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../controllers/IndividualUploadController.dart';
import '../../models/responseModels/GetEventsAllocationResponse.dart';
import '../add_beat/AddBeat.dart';

class BeatAllocationIndividualUpload extends StatefulWidget {
  final String? customerCodeWithName;

  const BeatAllocationIndividualUpload({Key? key, this.customerCodeWithName})
      : super(key: key);

  @override
  State<BeatAllocationIndividualUpload> createState() =>
      _BeatAllocationIndividualUploadState();
}

class _BeatAllocationIndividualUploadState
    extends State<BeatAllocationIndividualUpload> {
  final TextEditingController bottomSheetController = TextEditingController();
  // TextEditingController searchTextController = TextEditingController();

  late TooltipBehavior _tooltip;
  List<String> itemValue = ["Daily", "Monthly", "Yearly"];
  String? selectedBu;

  IndividualUploadController controller = Get.put(IndividualUploadController());
  // DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  // FocusNode? autoTextFieldFocusNode;
  int i = 0;

  TextEditingValue? selectedCustomerName;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    //todo Test :check for multiple scenarios
    // autoTextFieldFocusNode = FocusNode();
    super.initState();
    if (widget.customerCodeWithName != null) {
      selectedCustomerName =
          TextEditingValue(text: widget.customerCodeWithName!);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadInitialData();
    });
  }

  loadInitialData() async {
    controller.currentYear = controller.dateTimeUtils.getCurrentYear();
    controller.currentMonth = controller.dateTimeUtils.getCurrentMonth();
    controller.currentStart = controller.dateTimeUtils.getStartOfMonth();
    controller.currentEnd = controller.dateTimeUtils.getEndOfMonth();
    controller.showBodyVisibility = false;
    controller.updateVisibilityToTrue();

    Future.delayed(const Duration(seconds: 1), () async {
      controller.setMonthData();

      if (controller.userList.isEmpty) {
        await controller.getUserListData(globalController.customerScreenName);
      }

      if (widget.customerCodeWithName != null) {
        selectedCustomerName =
            TextEditingValue(text: widget.customerCodeWithName!);
        // searchTextController.text = widget.customerCodeWithName!;
        for (var item in controller.userList) {
          if (widget.customerCodeWithName!.contains(item)) {
            controller.currentScreenName = item;
          }
        }

        await controller.getEventsAllocation(
            month: controller.currentMonth,
            year: controller.currentYear,
            currentStart: controller.currentStart,
            currentEnd: controller.currentEnd,
            customerScreenName: controller.currentScreenName);

        // controller.getEventsAllocation(
        //     month: "", year: "", currentStart: controller.currentStart, currentEnd: controller.currentEnd, customerScreenName: widget.customerCode!);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
        context: context,
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   controllers.getUserListData('dd');
        // }),
        body: GetBuilder<IndividualUploadController>(
          init: IndividualUploadController(),
          builder: (controller) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: Widgets().commonDecorationWithGradient(
                          borderRadius: 0, gradientColorList: [pink, zumthor]),
                      child: Widgets().customLRPadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Widgets().verticalSpace(2.h),
                            Widgets().textWidgetWithW700(
                                titleText: 'Select Individual',
                                fontSize: 11.sp),
                            Widgets().verticalSpace(2.h),
                            Container(
                              height: 6.5.h,
                              decoration: ShapeDecoration(
                                color: white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: i != 0
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(1.5.h),
                                            topLeft: Radius.circular(1.5.h))
                                        : BorderRadius.circular(1.5.h)),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: RawAutocomplete(
                                initialValue: selectedCustomerName,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  } else {
                                    List<String> matches = <String>[];
                                    matches.addAll(controller.userNameList);

                                    matches.retainWhere((s) {
                                      return s.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                    return matches;
                                  }
                                },
                                onSelected: (String selectedItem) async {
                                  selectedCustomerName =
                                      TextEditingValue(text: selectedItem);
                                  printMe('selected item : $selectedItem');

                                  controller.updateVisibilityToFalse();
                                  controller.updateCurrentScreenNameToShowInUI(
                                      selectedItem);

                                  for (var item in controller.userList) {
                                    if (selectedItem.contains(item)) {
                                      controller.currentScreenName = item;
                                    }
                                  }

                                  print('controller.currentScreenName');
                                  print(controller.currentScreenName);
                                  if (controller.currentScreenName.isNotEmpty) {
                                    await controller.getEventsAllocation(
                                        month: controller.currentMonth,
                                        year: controller.currentYear,
                                        currentStart: controller.currentStart,
                                        currentEnd: controller.currentEnd,
                                        customerScreenName:
                                            controller.currentScreenName);
                                  }
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    key: GlobalKey<FormState>(),
                                    decoration: InputDecoration(
                                      hintText: 'Type here',
                                      hintStyle: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(1.5.h),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(1.5.h),
                                      ),
                                      filled: true,
                                      fillColor: white,
                                      suffixIcon: Image.asset(search),
                                    ),
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onSubmitted: (String value) {},
                                  );
                                },
                                optionsViewBuilder: (BuildContext context,
                                    void Function(String) onSelected,
                                    Iterable<String> options) {
                                  return Material(
                                      child: SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(
                                              child: Column(
                                            children: options.map((opt) {
                                              return InkWell(
                                                  onTap: () {
                                                    print(
                                                        "Submitted Value :$opt");
                                                    onSelected(opt);
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(opt),
                                                  ));
                                            }).toList(),
                                          ))));
                                },
                              ),
                            ),
                            Widgets().verticalSpace(2.h),
                          ],
                        ),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Visibility(
                        visible: controller.showBodyVisibility,
                        child: individualBeatView(controller)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleTextChange(String text) {
    i = 0;
    printMe("Search Text is : $text");
  }

  //
  // Widget searchView() {
  //   print("setstttttttttttttttttttttttttttttttttttttttt");
  //   searchTextController.text = controller.currentScreenNameToShowInUI;
  //   return ;
  // }

  Widget individualBeatView(IndividualUploadController controller) {
    return Widgets().customLRPadding(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Widgets().myBeatColorContainer(
                bgColor: lightPinkColor,
                borderColor: brinkPinkColor,
                iconName: totalAllocatedBeats,
                titleText: controller.totalBeats.toString(),
                context: context,
                iconColor: brinkPinkColor,
                subTitleText: 'Total Allocated Beats',
              ),
              Widgets().horizontalSpace(2.w),
              Widgets().myBeatColorContainer(
                  bgColor: hintOfGreen,
                  borderColor: malachite,
                  iconName: completedCustomer,
                  titleText: controller.completedCustomers.toString(),
                  iconColor: turquoise,
                  context: context,
                  subTitleText: 'Completed Customers'),
              Widgets().horizontalSpace(2.w),
              Widgets().myBeatColorContainer(
                  bgColor: bridalHeath,
                  borderColor: tangerine,
                  iconName: pendingCustomer,
                  titleText: controller.pendingCustomers.toString(),
                  iconColor: tangerine,
                  context: context,
                  subTitleText: 'Pending Customers'),
            ],
          ),

          ///uncoment it
          Widgets().verticalSpace(2.h),
          Widgets().iconElevationButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddBeat(controller.currentScreenName, "beat");
              }));
            },
            icon: addIcon,
            iconColor: alizarinCrimson,
            titleText: 'Add Beat',
            textColor: alizarinCrimson,
            isBackgroundOk: false,
            width: 100.w,
            bgColor: codGray,
          ),
          Widgets().verticalSpace(2.h),

          /*SfCalendar(
            view: CalendarView.month,
            onTap: (calendarTapDetails) {
              Widgets().beatsMonthlyDetailsBottomSheet(
                  context: context,
                  currentDate: '20 September 2023',
                  onTapBackWordIcon: () {},
                  onTapForwardIcon: () {},
                  customerName: 'SUKMA',
                  customerCount: '15 Customer',
                  onTapCancel: () {
                    Get.back();
                  },
                  onTapCountCustomerTile: () {
                    Get.back();
                    Widgets().myBeatFullAddressBottomSheet(
                        context: context,
                        controller: searchController,
                        customersOnLocationText: 'Khopoli Beat (15 Customers)',
                        customerName: 'SAVALIA KANTIALAL',
                        customerCode: '(Code : 1463299)',
                        customerAddress: 'SUVIDHA INFOTECH, KHATHA NO. 28 MCE COLLEGE ROAD DVYAPPAN KOPPALU 573201 Hassan HASSAN India Karnataka');
                  });
            },
          ),*/

          Row(
            children: [
              const Spacer(),
              Widgets().dayMonthYearlyStatusDropdown(
                  hintText: "Selected",
                  width: 30.w,
                  onChanged: (value) {
                    controller.calenderViewSelected = value;

                    setState(() {
                      selectedCustomerName = TextEditingValue(
                          text: controller.currentScreenNameToShowInUI);
                    });

                    controller.updateCalenderView(
                        controller.calenderViewSelected.toString());
                  },
                  itemValue: controller.calenderViewList,
                  selectedValue: controller.calenderViewSelected),
            ],
          ),
          _myCalenderEvent(controller),
          Visibility(
            visible: !(controller.cView == CalendarView.day),
            child: Column(
              children: [
                Widgets().verticalSpace(2.h),
                Widgets().tileWithTwoIconAndSingleText(
                    context: context,
                    title: 'View Graph',
                    titleIcon: viewGraph,
                    subtitleIcon: rightArrowWithCircleIcon,
                    tileGradientColor: [pink, zumthor],
                    onTap: () {
                      viewGraphBottomSheet(context: context);
                    }),
              ],
            ),
          ),
          Widgets().verticalSpace(2.h),
          Container(
            decoration: BoxDecoration(
              color: pieChartBG,
              border: Border.all(color: pieChartBorder),
              borderRadius: BorderRadius.circular(1.5.h),
            ),
            child: controller.isEmptyData()
                ? const Center(
                    child: Text('No data is Avialble'),
                  )
                : _buildDefaultPieChart(),
          ),
          Widgets().verticalSpace(2.h),
        ],
      ),
    );
  }

  //Pie chart block
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
        title: ChartTitle(
            text: 'Beats Status',
            alignment: ChartAlignment.near,
            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
        legend: Legend(
            isVisible: !controller.isEmptyData(),
            position: LegendPosition.bottom),
        series: _getDefaultPieSeries(controller),
        tooltipBehavior: _tooltip,
        palette: controller.getPieChartColors());
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries(
      IndividualUploadController controller) {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: controller.createPieChartModelList,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }

//View bar graph bottom sheet

  viewGraphBottomSheet({required BuildContext context}) {
    return Get.bottomSheet(
      StatefulBuilder(builder: (context, myState) {
        return SingleChildScrollView(
          child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 5,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child:
                  GetBuilder<IndividualUploadController>(builder: (controller) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 1.5.h, left: 3.w, right: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().textWidgetWithW700(
                                titleText: "Graph", fontSize: 13.sp),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(closeIcon),
                            ),
                          ],
                        ),
                      ),
                      Widgets().verticalSpace(2.5.h),
                      Widgets().horizontalDivider(),
                      Widgets().verticalSpace(2.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Widgets().textWidgetWithW700(
                              titleText: controller.dateTimeUtils
                                  .convertDateFormatBar(
                                      controller.currentStart),
                              fontSize: 13.sp),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_back_ios_rounded),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                          // Widgets().dayMonthYearlyStatusDropdown(
                          //   hintText: "Selected",
                          //   width: 30.w,
                          //   onChanged: (value) {
                          //     controller.calenderViewSelected = value;
                          //     controller.calenderViewSelectedBarGraph = value;
                          //     myState(() {});
                          //     controller.updateCalenderView(controller.calenderViewSelectedBarGraph.toString());
                          //     myState(() {});
                          //   },
                          //   itemValue: controller.calenderViewList,
                          //   selectedValue: controller.calenderViewSelectedBarGraph,
                          // ),
                        ],
                      ),
                      Widgets().verticalSpace(2.5.h),
                      _buildTrackerColumnChart(controller),
                    ],
                  ),
                );
              })),
        );
      }),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  Widget _buildTrackerColumnChart(IndividualUploadController controller) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      enableAxisAnimation: true,
      title: ChartTitle(text: ''),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          autoScrollingDelta: 10,

          // maximum: 28,
          // minimum: 0,
          interval: 1,
          labelPlacement: LabelPlacement.onTicks,
          autoScrollingMode: AutoScrollingMode.start,
          arrangeByIndex: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
      ),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: const AxisLine(width: 1),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getTracker(controller),
      tooltipBehavior: _tooltip,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getTracker(
      IndividualUploadController controller) {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: controller.cartesianChartModelList,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: graphBarTrackColor,
          color: graphBarColor,
          borderRadius: BorderRadius.circular(5),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Marks',
          emptyPointSettings: EmptyPointSettings(
              // Mode of empty point
              mode: EmptyPointMode.average),
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }

  _myCalenderEvent(IndividualUploadController controller) {
    return SfCalendar(
      view: controller.cView,
      dataSource: MeetingDataSource(controller.beatsEventDataList),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 60),
        startHour: 0,
        endHour: 0,
      ),
      onTap: (tap) {
        if (tap.appointments != null && tap.appointments!.isNotEmpty) {
          List<BeatsEventData> eventList = [];
          for (int i = 0; i < tap.appointments!.length; i++) {
            BeatsEventData eventData = tap.appointments![i];
            eventList.add(eventData);
          }
          Widgets().beatsMonthlyEventDetailsBottomSheet(
              context: context,
              currentDate:
                  DateTimeUtils().convertDateFormatMonth(eventList[0].start!),
              onTapBackWordIcon: () {},
              onTapForwardIcon: () {},
              onTapCancel: () {
                Get.back();
              },
              onTapCountCustomerTile: () {
                Get.back();
              },
              listViewDataWidget: ListView.builder(
                  shrinkWrap: true,
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    return Widgets().customLRPadding(
                        child: Widgets().tileWithTwoTextAndSingleIcon(
                            context: context,
                            customerName: "${eventList[index].beatCode}",
                            customerCount:
                                "${eventList[index].noOfCustomers} Customers",
                            subtitleIcon: rightArrowWithCircleIcon,
                            onTap: () {
                              printMe(
                                  "Beat Code : ${eventList[index].beatCode}");
//todo : confirm if customer code here needs changes - tezz rathore
                              controller
                                  .getCustomerDetails(
                                      beatCode: eventList[index].beatCode!,
                                      employeeScreenName:
                                          (widget.customerCodeWithName != null
                                              ? widget.customerCodeWithName!
                                              : globalController
                                                  .customerScreenName))
                                  .then((value) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Widgets().loadingDataDialog(
                                      loadingText: "Loading data...");

                                  printMe("Beat Response : $value");
                                  Get.back();
                                  Get.back();

                                  Widgets().myBeatFullAddressBottomSheetMyBeat(
                                      context: context,
                                      controller: bottomSheetController,
                                      customersOnLocationText:
                                          '${eventList[index].beatCode} (${eventList[index].noOfCustomers} Customers)',
                                      listViewDataWidget: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.customerData.length,
                                          itemBuilder: (context, itemIndex) {
                                            return Widgets()
                                                .todayBeatFullAddressExpantionCard(
                                                    context: context,
                                                    customerName: controller
                                                        .customerData[itemIndex]
                                                        .customerName!,
                                                    customerCode: controller
                                                        .customerData[itemIndex]
                                                        .customerCode!,
                                                    customerAddress: controller
                                                        .customerData[itemIndex]
                                                        .address!);
                                          }));
                                });
                              });
                            }));
                  }),
              eventsList: eventList);
        } else {
          Widgets().showToast("No data is available !!");
        }
      },
      onViewChanged: (viewChangedDetails) async {
        for (var item in controller.userList) {
          if ((selectedCustomerName?.text ?? '').contains(item)) {
            controller.currentScreenName = item;
          }
        }

        CalendarView currentView = controller.cView;
        List<DateTime> visibleDates = viewChangedDetails.visibleDates;
        int currentYear = DateTime.now().year;
        int currentMonth = DateTime.now().month;
        currentYear = visibleDates[0].year;
        currentMonth = visibleDates[0].month;
        String startDate = controller.currentStart;
        String endDate = controller.currentEnd;
        print('controller.currentStart');
        print(controller.currentStart);

        String operationView = '';

        if (currentView == CalendarView.day) {
          DateTime today = visibleDates[0];
          DateTime tomorrow = today.add(const Duration(days: 1));
          startDate = DateFormat('dd/MM/yyyy').format(today);
          endDate = DateFormat('dd/MM/yyyy').format(today);
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
          startDate = controller.dateTimeUtils
              .getFirstDateOfMonthFormatted(currentMonth);
          endDate = controller.dateTimeUtils
              .getLastDateOfMonthFormatted(currentMonth);
          operationView = 'Monthly';
        }

        // controller.updateCurrentDates(
        //   operationView,
        //   currentYear.toString(),
        //   currentMonth.toString(),
        //   startDate.toString(),
        //   endDate.toString(),
        // );

        for (var item in controller.userList) {
          if (controller.currentScreenNameToShowInUI.contains(item)) {
            controller.currentScreenName = item;
          }
        }
        await controller.getEventsAllocation(
          month: currentMonth.toString(),
          year: currentYear.toString(),
          currentStart: startDate,
          currentEnd: endDate,
          customerScreenName: controller.currentScreenName,
        );
      },
      /*onSelectionChanged: (calendarSelectionDetails) {

        },*/
    );
  }
}

//-------------------------------------------------------------------------------------------------