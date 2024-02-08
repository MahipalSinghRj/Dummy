import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/beat_module/controllers/MyBeatController.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
// import '../../../../global/DummyCheckBox/DummyCheckBoxData.dart';
import '../../../../utils/ChartsSupportClasses.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../models/responseModels/GetCustomerAddressResponse.dart';
import '../../models/responseModels/GetCustomerDetailsResponse.dart';
import '../../models/responseModels/GetEventsAllocationResponse.dart';
import '../add_beat/AddBeat.dart';
import '../beat_on_map/BeatOnMap.dart';

class MyBeat extends StatefulWidget {
  const MyBeat({Key? key}) : super(key: key);

  @override
  State<MyBeat> createState() => _MyBeatState();
}

class _MyBeatState extends State<MyBeat> {
  GlobalController globalController = Get.put(GlobalController());

  final TextEditingController searchController = TextEditingController();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  List<Color> topFiveProductColor = [
    lochmara,
    caribbeanGreenColor,
    mySinColor,
    burntSiennaColor,
    cornflowerDarkBlueColor
  ];
  bool isSelected = false;
  // List<InvoiceItem> invoiceItems = [
  //   InvoiceItem(title: 'Invoice 1'),
  //   InvoiceItem(title: 'Invoice 2'),
  //   InvoiceItem(title: 'Invoice 3'),
  // ];

  // List<InvoiceItem> selectedItems = [];
  List<CustomerMap> customerMapList = [];

  late TooltipBehavior _tooltip;
  String? selectedBu;

  MyBeatController myBeatController = Get.put(MyBeatController());

  CalendarController calendarController = CalendarController();

  bool isData = false;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    getData();
    super.initState();
  }

  getData() async {
    myBeatController.currentYear = dateTimeUtils.getCurrentYear();
    myBeatController.currentMonth = dateTimeUtils.getCurrentMonth();
    myBeatController.currentStart = dateTimeUtils.getStartOfMonth();
    myBeatController.currentEnd = dateTimeUtils.getEndOfMonth();

    await myBeatController.getEventsAllocation(
        month: myBeatController.currentMonth,
        year: myBeatController.currentYear,
        currentStart: myBeatController.currentStart,
        currentEnd: myBeatController.currentEnd);
    setState(() {
      isData = myBeatController.isDataLoad;
    });

    //myBeatController.getCustomerAddress(month: "11", year: "2023", currentStart: "01/11/2023", currentEnd: "30/11/2023");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
      context: context,
      /*floatingActionButton: FloatingActionButton(onPressed: () {
            // myBeatController.getCustomerAddress(month: "", year: "", currentStart: "01/10/2023", currentEnd: "31/10/2023");
          }),*/
      body: (isData)
          ? Container(
              width: 100.w,
              height: 100.h,
              color: alizarinCrimson,
              child: bottomDetailsSheet(),
            )
          : Widgets().customLRPadding(
              child: Center(
                child: SizedBox(
                  height: 33.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(noDataFound),
                      Widgets().textWidgetWithW400(
                          titleText: 'No Data Found',
                          fontSize: 10.sp,
                          textColor: boulder),
                    ],
                  ),
                ),
              ),
            ),
    ));
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return GetBuilder<MyBeatController>(builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              decoration: Widgets().commonDecorationForTopLeftRightRadius(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Widgets()
                      .draggableBottomSheetTopContainer(titleText: "My Beat"),
                  Widgets().verticalSpace(2.h),
                  Column(
                    children: [
                      Widgets().customLeftRightPadding(
                        child: Row(
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
                                titleText:
                                    controller.completedCustomers.toString(),
                                iconColor: turquoise,
                                context: context,
                                subTitleText: 'Completed Customers'),
                            Widgets().horizontalSpace(2.w),
                            Widgets().myBeatColorContainer(
                                bgColor: bridalHeath,
                                borderColor: tangerine,
                                iconName: pendingCustomer,
                                titleText:
                                    controller.pendingCustomers.toString(),
                                iconColor: tangerine,
                                context: context,
                                subTitleText: 'Pending Customers'),
                          ],
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLeftRightPadding(
                        child: Visibility(
                          visible: !(globalController.role == 'LAS'),
                          child: Widgets().iconElevationButton(
                            onTap: () {
                              if (myBeatController
                                  .beatsDataDataList.isNotEmpty) {
                                Get.to(() => AddBeat(
                                    globalController.customerScreenName,
                                    'MyBeat'));
                              } else {
                                Widgets().showToast("No beats Allocated !!");
                              }
                            },
                            icon: addIcon,
                            iconColor: alizarinCrimson,
                            titleText: 'Add Beat',
                            textColor: alizarinCrimson,
                            isBackgroundOk: false,
                            width: 100.w,
                            bgColor: codGray,
                          ),
                        ),
                      ),

                      Widgets().verticalSpace(2.h),
                      Container(
                        color: magicMint,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Row(
                          children: [
                            Text(
                              DateFormat(
                                      myBeatController.cView != CalendarView.day
                                          ? 'MMMM y'
                                          : 'EEEE, MMMM d, y')
                                  .format(calendarController.displayDate ??
                                      DateTime.now()),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: codGray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp,
                                  letterSpacing: .3),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            if (myBeatController.cView == CalendarView.month)
                              IconButton(
                                  onPressed: () {
                                    calendarController..backward!();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.arrow_back_ios)),
                            if (myBeatController.cView == CalendarView.month)
                              IconButton(
                                  onPressed: () {
                                    calendarController.forward!();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios)),
                            Widgets().dayMonthYearlyStatusDropdown(
                                hintText: "Selected",
                                width: 30.w,
                                backgroundColor: alizarinCrimson,
                                onChanged: (value) {
                                  setState(() {
                                    controller.calenderViewSelected = value;
                                    controller.calenderViewSelectedBarGraph =
                                        value;
                                  });
                                  calendarController.view =
                                      controller.updateCalenderView(controller
                                          .calenderViewSelected
                                          .toString());

                                  if (calendarController.view ==
                                      CalendarView.day) {
                                    calendarController.displayDate =
                                        DateTime.now();
                                  }
                                },
                                itemValue: controller.calenderViewList,
                                selectedValue: controller.calenderViewSelected),
                          ],
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                      Visibility(
                          visible:
                              ((myBeatController.cView == CalendarView.day)),
                          child: Widgets().customLeftRightPadding(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat(DateFormat.WEEKDAY).format(
                                      calendarController.displayDate ??
                                          DateTime.now()),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: codGray,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      letterSpacing: .3),
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                          )),

                      Widgets().customLeftRightPadding(
                        child: Visibility(

                            /// Then calender should not be visible when applied day wise filter
                            visible:
                                ((myBeatController.cView != CalendarView.day)),
                            child: _myCalenderEvent()),
                      ),
                      Widgets().verticalSpace(2.h),

                      /* SizedBox(
                          height: 50.h,
                          child: SfCalendar(
                            view: CalendarView.month,
                            // monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                            //   return CustomerCalendarDesign(date: details.date);
                            // },
                            onTap: (calendarTapDetails) {
                              printMe("Tapped date : ${calendarTapDetails.date} ");
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
                          ),
                        ),*/
                      //currentView == CalendarView.day

                      Visibility(
                        visible: ((myBeatController.cView == CalendarView.day)),
                        child: Widgets().customLeftRightPadding(
                          child: Column(
                            children: [
                              Widgets().verticalSpace(2.h),
                              ListView.builder(
                                itemCount: controller.beatsEventDataList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  var items =
                                      controller.beatsEventDataList[index];

                                  // print(controller.openTileIndex == index);

                                  return !checkCurrentDateInBetweenEventOrNot(
                                          items,
                                          calendarController.displayDate ??
                                              DateTime.now())
                                      ? Container()
                                      : Widgets().todayBeatExpansionCard(
                                          context: context,
                                          tileGradientColor: [
                                            magicMint,
                                            oysterBay
                                          ],
                                          locationTitle: items.title.toString(),
                                          initiallyExpanded:
                                              controller.openTileIndex == index,
                                          noOfCustomers:
                                              items.noOfCustomers.toString(),
                                          onExpansionChanged: (isExpanded) {
                                            if (isExpanded) {
                                              controller
                                                  .handleTileTapped(index);
                                              // _openTileIndex
                                              controller.getCustomerDetails(
                                                  beatCode:
                                                      items.beatCode ?? '');
                                              printMe(
                                                  "On expansion changed click...");
                                            }
                                          },
                                          childView: customerDetailList(
                                              controller.customerData));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      Visibility(
                        visible: (controller.cView == CalendarView.day),
                        child: Widgets().customLeftRightPadding(
                          child: Widgets().tileWithTwoIconAndSingleText(
                              context: context,
                              title: 'View on Map',
                              titleIcon: locationIcon,
                              subtitleIcon: rightArrowWithCircleIcon,
                              tileGradientColor: [magicMint, oysterBay],
                              onTap: () {
                                Get.to(() => BeatOnMap(
                                    beatsList: controller.beatsEventDataList
                                        .where((element) =>
                                            checkCurrentDateInBetweenEventOrNot(
                                                element,
                                                calendarController
                                                        .displayDate ??
                                                    DateTime.now()))
                                        .toList()));
                              }),
                        ),
                      ),
                      Visibility(
                        visible: !(controller.cView == CalendarView.day),
                        child: Widgets().customLeftRightPadding(
                          child: Column(
                            children: [
                              Widgets().verticalSpace(2.h),
                              Widgets().tileWithTwoIconAndSingleText(
                                  context: context,
                                  title: 'View Bar Graph',
                                  titleIcon: viewBarGraph,
                                  subtitleIcon: rightArrowWithCircleIcon,
                                  tileGradientColor: [pink, zumthor],
                                  onTap: () {
                                    viewGraphBottomSheet(context: context);
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLeftRightPadding(
                        child: Container(
                          decoration: BoxDecoration(
                            color: pieChartBG,
                            border: Border.all(color: pieChartBorder),
                            borderRadius: BorderRadius.circular(1.5.h),
                          ),
                          child: _buildDefaultPieChart(controller),
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget customerDetailList(List<CustomerData> customerDataList) {
    return ListView.builder(
      itemCount: customerDataList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        print(customerDataList[index].customerName);

        return Widgets().todayBeatFullAddressExpantionCard(
            context: context,
            customerName: customerDataList[index].customerName ?? '',
            customerCode: customerDataList[index].customerCode ?? '',
            customerAddress: customerDataList[index].address ?? '');
      },
    );
  }

  SfCircularChart _buildDefaultPieChart(MyBeatController controller) {
    return SfCircularChart(
        title: ChartTitle(
            text: 'Beats Status',
            alignment: ChartAlignment.near,
            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
        legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            isResponsive: true),
        series: _getDefaultPieSeries(controller),
        tooltipBehavior: _tooltip,
        palette: controller.getPieChartColors());
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries(
      MyBeatController controller) {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '5%',
          dataSource: controller.createPieChartModelList,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          )),
    ];
  }

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
              child: GetBuilder<MyBeatController>(builder: (controller) {
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
                      Widgets().customLPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().textWidgetWithW700(
                                titleText: dateTimeUtils
                                    .convertStringDateIntoMonthAndYear(
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
                              child:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Widgets().dayMonthYearlyStatusDropdown(
                              hintText: "Selected",
                              width: 30.w,
                              backgroundColor: alizarinCrimson,
                              onChanged: (value) {
                                controller.calenderViewSelected = value;
                                controller.calenderViewSelectedBarGraph = value;
                                myState(() {});
                                controller.updateCalenderView(controller
                                    .calenderViewSelectedBarGraph
                                    .toString());
                                myState(() {});
                              },
                              itemValue: controller.calenderViewList,
                              selectedValue:
                                  controller.calenderViewSelectedBarGraph,
                            ),
                          ],
                        ),
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

  Widget _buildTrackerColumnChart(MyBeatController controller) {
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
        legend: Legend(
            isVisible: true,
            isResponsive: true,
            alignment: ChartAlignment.near,
            overflowMode: LegendItemOverflowMode.wrap,
            legendItemBuilder: (legendText, series, point, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      legendText == 'Completed Customers'
                          ? barLegendBlueSvg
                          : barLegendGreySvg,
                      height: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(legendText)
                  ],
                ),
              );
            },
            position: LegendPosition.bottom),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: double.tryParse(controller.pendingCustomers ?? '0') ?? 0,
            axisLine: const AxisLine(width: 1),
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: _getTracker(controller),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: white,
          builder: (data, point, series, pointIndex, seriesIndex) {
            final d = data as ChartSampleData;
            final s = series as StackedColumnSeries<ChartSampleData, String>;
            print("----------");
            print(
                "${d.x} ${d.y}  ${d.high}  ${d.low}  ${d.yValue} ${d.xValue}  ");
            print("${s}");
            print("${point}");
            print("----------");
            return Container(
              width: 50.w,
              // height: 20.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          barLegendBlueSvg,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("${d.y}")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [Text("Completed Customer")],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          barLegendGreySvg,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            "${((double.tryParse(controller.pendingCustomers ?? '0') ?? 0) - ((d.y) ?? 0).toDouble()).toInt()}")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [Text("Pending Customer")],
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  List<StackedColumnSeries<ChartSampleData, String>> _getTracker(
      MyBeatController controller) {
    return <StackedColumnSeries<ChartSampleData, String>>[
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: controller.cartesianChartModelList,

          //     <ChartSampleData>[
          //   ChartSampleData(x: '1', y: 71),
          //   ChartSampleData(x: '2', y: 84),
          //   ChartSampleData(x: '3', y: 48),
          //   ChartSampleData(x: '4', y: 80),
          //   ChartSampleData(x: '5', y: 76),
          //   ChartSampleData(x: '6', y: 52),
          //   ChartSampleData(x: '7', y: 54),
          //   ChartSampleData(x: '8', y: 76),
          //   ChartSampleData(x: '9', y: 05),
          //   ChartSampleData(x: '10', y: 76),
          //   ChartSampleData(x: '11', y: 44),
          //   ChartSampleData(x: '12', y: 76),
          //   ChartSampleData(x: '13', y: 86),
          //   ChartSampleData(x: '14', y: 76),
          //   ChartSampleData(x: '15', y: 77),
          //   ChartSampleData(x: '16', y: 76),
          //   ChartSampleData(x: '17', y: 77),
          //   ChartSampleData(x: '18', y: 76),
          //   ChartSampleData(x: '19', y: 35),
          //   ChartSampleData(x: '20', y: 29),
          //   ChartSampleData(x: '21', y: 37),
          //   ChartSampleData(x: '22', y: 15),
          //   ChartSampleData(x: '23', y: 42),
          //   ChartSampleData(x: '24', y: 37),
          //   ChartSampleData(x: '25', y: 25),
          //   ChartSampleData(x: '26', y: 29),
          //   ChartSampleData(x: '27', y: 78),
          // ],

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: graphBarTrackColor,
          color: graphBarColor,
          borderRadius: BorderRadius.circular(5),
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          name: 'Completed Customers',
          enableTooltip: true,
          emptyPointSettings: EmptyPointSettings(
              // Mode of empty point
              mode: EmptyPointMode.average),
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white))),
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: controller.cartesianChartModelList,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: graphBarTrackColor,
          color: graphBarTrackColor,
          borderRadius: BorderRadius.circular(5),
          xValueMapper: (ChartSampleData data, _) => null,
          yValueMapper: (ChartSampleData data, _) => data.secondSeriesYValue,
          name: 'Pending Customers',
          enableTooltip: true,
          emptyPointSettings: EmptyPointSettings(
              // Mode of empty point
              mode: EmptyPointMode.average),
          dataLabelSettings: const DataLabelSettings(
              isVisible: false,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white))),
    ];
  }

  _myCalenderEvent() {
    return GetBuilder<MyBeatController>(builder: (controller) {
      return SfCalendar(
        view: controller.cView,
        headerHeight: 0,
        controller: calendarController,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeInterval: Duration(minutes: 60),
          startHour: 0,
          endHour: 0,
        ),
        dataSource: MeetingDataSource(myBeatController.beatsEventDataList),
        onTap: (tap) {
          if (tap.appointments != null && tap.appointments!.isNotEmpty) {
            List<BeatsEventData> eventList = [];
            for (int i = 0; i < tap.appointments!.length; i++) {
              BeatsEventData eventData = tap.appointments![i];
              eventList.add(eventData);
            }

            printMe("OnTAp : ${tap.date}");

            Widgets().beatsMonthlyEventDetailsBottomSheetMyBeat(
                context: context,
                currentDate: DateTimeUtils()
                    .convertDateFormatMonthForBeat(tap.date.toString()),
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

                                myBeatController
                                    .getCustomerDetails(
                                        beatCode: eventList[index].beatCode!)
                                    .then((value) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Widgets().loadingDataDialog(
                                        loadingText: "Loading data...");

                                    printMe("Beat Response : $value");

                                    Get.back();
                                    Get.back();

                                    Widgets()
                                        .myBeatFullAddressBottomSheetMyBeat(
                                            context: context,
                                            controller: searchController,
                                            customersOnLocationText:
                                                '${eventList[index].beatCode} (${eventList[index].noOfCustomers} Customers)',
                                            listViewDataWidget:
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: myBeatController
                                                        .customerData.length,
                                                    itemBuilder:
                                                        (context, itemIndex) {
                                                      return Widgets().todayBeatFullAddressExpantionCard(
                                                          context: context,
                                                          customerName:
                                                              myBeatController
                                                                  .customerData[
                                                                      itemIndex]
                                                                  .customerName!,
                                                          customerCode:
                                                              myBeatController
                                                                  .customerData[
                                                                      itemIndex]
                                                                  .customerCode!,
                                                          customerAddress:
                                                              myBeatController
                                                                  .customerData[
                                                                      itemIndex]
                                                                  .address!);
                                                    }));
                                  });
                                });
                              }));
                    }),
                eventsList: eventList);
          } else {
            // Widgets().showToast("No data is available !!");
          }
        },
        onViewChanged: (viewChangedDetails) async {
          CalendarView currentView = myBeatController.cView;
          List<DateTime> visibleDates = viewChangedDetails.visibleDates;
          int currentYear = DateTime.now().year;
          int currentMonth = DateTime.now().month;
          currentYear = visibleDates[0].year;
          currentMonth = visibleDates[0].month;
          String startDate = myBeatController.currentStart;
          String endDate = myBeatController.currentEnd;

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
            startDate =
                dateTimeUtils.getFirstDateOfMonthFormatted(currentMonth);
            endDate = dateTimeUtils.getLastDateOfMonthFormatted(currentMonth);
            operationView = 'Monthly';
          }

          myBeatController.updateCurrentDates(
            operationView,
            currentYear.toString(),
            currentMonth.toString(),
            startDate.toString(),
            endDate.toString(),
          );

          if (!myBeatController.isFirstTime) {
            await myBeatController.getEventsAllocation(
                month: myBeatController.currentMonth,
                year: myBeatController.currentYear,
                currentStart: myBeatController.currentStart,
                currentEnd: myBeatController.currentEnd);
          }
          myBeatController.updateInFirstTime();
        },
      );
    });
  }

  //Show model bottom sheet
  void editOrderListCard({
    required BuildContext context,
    required List<BeatsEventData> eventsList,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: 40.h),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 5,
                  )
                ],
                color: white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.h),
                    topLeft: Radius.circular(4.h))),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, left: 6.w, right: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event",
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
                Widgets().verticalSpace(2.h),
                Container(width: 100.w, height: 1, color: lightBoulder),
                Widgets().verticalSpace(2.h),
                Wrap(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: eventsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(2.h),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0A000000),
                                        blurRadius: 5,
                                        offset: Offset(0, -4),
                                        spreadRadius: 8,
                                      )
                                    ],
                                    color: white,
                                    borderRadius: BorderRadius.circular(1.h)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${eventsList[index].title}"),
                                    Row(
                                      children: [
                                        Text(
                                            "Start Date : ${eventsList[index].start}"),
                                        const Spacer(),
                                        Text(
                                            "End Date : ${eventsList[index].end}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

// Remove This function if not needed
  bool checkCurrentDateInBetweenEventOrNot(
      BeatsEventData event, DateTime currentDateTime) {
    final current = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);
    final start =
        dateTimeUtils.convertStringDateIntoDateTime(event.start ?? '');
    final end = dateTimeUtils.convertStringDateIntoDateTime(event.end ?? '');
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    final result = current.isAtSameMomentAs(startDate) ||
        current.isAtSameMomentAs(endDate);

    return result;
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

  // @override
  // DateTime getEndTime(int index) {
  //   var eDate = DateTimeUtils().convertDateFormatN(_getMeetingData(index).end!);
  //   DateTime endTime = DateTime.parse(eDate);
  //   return endTime;
  // }

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
