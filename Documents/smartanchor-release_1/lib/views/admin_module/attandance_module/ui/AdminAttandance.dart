/// UI file for admin attendance module to show employee list , employee details(absent/late/present), graph based on employee details

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/admin_module/attandance_module/ui/TrackEmployee.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/AppBar.dart';
import '../../../../common/Drawer.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../controllers/AdminAttendanceController.dart';

class AdminAttendance extends StatefulWidget {
  const AdminAttendance({Key? key}) : super(key: key);

  @override
  State<AdminAttendance> createState() => _AdminAttendanceState();
}

class _AdminAttendanceState extends State<AdminAttendance> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<ChartData> chartData = [];

  GlobalController globalController = Get.put(GlobalController());
  AdminAttendanceController adminAttendanceController =
      Get.put(AdminAttendanceController());
  DateTime initialDateTime = DateTime.now();
  late TooltipBehavior _tooltip;

  String? selectedBu;
  String? selectState;
  String? selectZone;
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  bool isFilter = false;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);

    // TODO: implement initState

    printMe("Picked Date : $initialDateTime");

    super.initState();
    fetchData();
  }

  fetchData() async {
    await adminAttendanceController.getAdminData();
    await adminAttendanceController.getAdminAttendance(
        date: DateTimeUtils().formatDateTimePreviousOrder(initialDateTime));
    setState(() {
      chartData = [
        ChartData(
            'Total Absent',
            adminAttendanceController.totalAbsent.toDouble(),
            const Color(0xffEE466B)),
        ChartData('Total Late', adminAttendanceController.totalLate.toDouble(),
            const Color(0xff6640E6)),
        ChartData(
            'Total Present',
            adminAttendanceController.totalPresent.toDouble(),
            const Color(0xff51C378)),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAttendanceController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              drawer: MainDrawer(context),
              appBar: MainAppBar(context, scaffoldKey),
              body: Container(
                  width: 100.w,
                  height: 100.h,
                  color: alizarinCrimson,
                  child: DraggableScrollableSheet(
                      initialChildSize: 01,
                      minChildSize: 01,
                      maxChildSize: 1,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                            child: Container(
                                decoration: Widgets().boxDecorationTopLRRadius(
                                    color: white, topLeft: 2.h, topRight: 2.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Widgets()
                                          .draggableBottomSheetTopContainer(
                                              titleText: "View Attendance"),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: Widgets()
                                            .tileWithTwoIconAndSingleText(
                                                context: context,
                                                title: 'Search by Filter',
                                                titleIcon: filter,
                                                subtitleIcon:
                                                    rightArrowWithCircleIcon,
                                                tileGradientColor: [
                                                  pink,
                                                  zumthor
                                                ],
                                                onTap: () {
                                                  showNewDialog();
                                                }),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Widgets().myBeatColorContainer(
                                                    bgColor: hintOfGreen,
                                                    borderColor: malachite,
                                                    iconName: groupSvg,
                                                    titleText:
                                                        "${controller.totalPresent}",
                                                    iconColor:
                                                        const Color(0xff5BCB81),
                                                    context: context,
                                                    subTitleText:
                                                        'Total Present Employees'),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                  bgColor:
                                                      const Color(0xffFFF6F4),
                                                  borderColor: brinkPinkColor,
                                                  iconName: lateAttendanceSvg,
                                                  titleText:
                                                      "${controller.totalAbsent}",
                                                  context: context,
                                                  iconColor: brinkPinkColor,
                                                  subTitleText:
                                                      'Absent / Leave Employees',
                                                ),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                        bgColor: const Color(
                                                            0xffF8F5FF),
                                                        borderColor:
                                                            const Color(
                                                                0xff6640E6),
                                                        iconName: lateComerSvg,
                                                        titleText:
                                                            "${controller.totalLate}",
                                                        iconColor: const Color(
                                                            0xff06640E6),
                                                        context: context,
                                                        subTitleText:
                                                            'Late\nComers'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Container(
                                        color: const Color(0xffF4F9FF),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 158,
                                                child: SfCircularChart(
                                                    tooltipBehavior: _tooltip,
                                                    series: <CircularSeries>[
                                                      DoughnutSeries<ChartData,
                                                          String>(
                                                        dataSource: chartData,
                                                        xValueMapper:
                                                            (ChartData data,
                                                                    _) =>
                                                                data.x,
                                                        yValueMapper:
                                                            (ChartData data,
                                                                    _) =>
                                                                data.y,
                                                        // Radius of doughnut's inner circle
                                                        innerRadius: '80%',
                                                        explodeOffset: "0.5%",
                                                        explode: true,
                                                        pointColorMapper:
                                                            (ChartData data,
                                                                    _) =>
                                                                data.color,
                                                      )
                                                    ])),
                                            Container(
                                              height: 1,
                                              color: const Color(0xffD0D4EC),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            dotSvg,
                                                            color: const Color(
                                                                0xff34D196),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .23,
                                                            child: Text(
                                                              'Total Present Employees',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color:
                                                                      waterlooColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            controller
                                                                .totalPresent
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    veryLightBoulder,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12.sp,
                                                                letterSpacing:
                                                                    .3),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 86,
                                                      color: const Color(
                                                          0xffD0D4EC),
                                                    ),
                                                    Widgets()
                                                        .horizontalSpace(2.w),
                                                    SizedBox(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            dotSvg,
                                                            color: const Color(
                                                                0xffEE466B),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .23,
                                                            child: Text(
                                                              'Total Absent / Leave Employees',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color:
                                                                      waterlooColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            controller
                                                                .totalAbsent
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    veryLightBoulder,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12.sp,
                                                                letterSpacing:
                                                                    .3),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 86,
                                                      color: const Color(
                                                          0xffD0D4EC),
                                                    ),
                                                    Widgets()
                                                        .horizontalSpace(2.w),
                                                    SizedBox(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            dotSvg,
                                                            color: const Color(
                                                                0xff6640E6),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .23,
                                                            child: Text(
                                                              'Total Late Comers',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color:
                                                                      waterlooColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            controller.totalLate
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    veryLightBoulder,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12.sp,
                                                                letterSpacing:
                                                                    .3),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      controller.empDetails.isNotEmpty ||
                                              controller
                                                  .empDetailsFilter.isNotEmpty
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
                                              child: Text(
                                                'Searched Employees',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: veryLightBoulder),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Widgets().verticalSpace(2.h),
                                      isFilter
                                          ? Widgets().customLRPadding(
                                              child: ListView.builder(
                                                itemCount: controller
                                                    .empDetailsFilter.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Widgets()
                                                      .EmployeeAttendanceExpantionCard(
                                                          context: context,
                                                          shopTitleText: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .name!,
                                                          customerCode:
                                                              '(Code : ${controller.empDetailsFilter[index].empCode})',
                                                          date: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .date!,
                                                          zone: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .zone!,
                                                          city: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .city!,
                                                          state: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .state!,
                                                          login: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .loginTime!,
                                                          logout: controller
                                                              .empDetailsFilter[
                                                                  index]
                                                              .logoutTime!,
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) {
                                                              return AdminTrackEmployee(
                                                                customerCode: controller
                                                                    .empDetailsFilter[
                                                                        index]
                                                                    .empCode!,
                                                                customerName:
                                                                    controller
                                                                        .empDetailsFilter[
                                                                            index]
                                                                        .name!,
                                                                customerDate:
                                                                    controller
                                                                        .empDetailsFilter[
                                                                            index]
                                                                        .date!,
                                                              );
                                                            }));
                                                          });
                                                },
                                              ),
                                            )
                                          : Widgets().customLRPadding(
                                              child: ListView.builder(
                                                itemCount: controller
                                                    .empDetails.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Widgets()
                                                      .EmployeeAttendanceExpantionCard(
                                                          context: context,
                                                          shopTitleText:
                                                              controller
                                                                  .empDetails[
                                                                      index]
                                                                  .name!,
                                                          customerCode:
                                                              '(Code : ${controller.empDetails[index].empCode})',
                                                          date: controller
                                                              .empDetails[index]
                                                              .date!,
                                                          zone: controller
                                                              .empDetails[index]
                                                              .zone!,
                                                          city: controller
                                                              .empDetails[index]
                                                              .city!,
                                                          state: controller
                                                              .empDetails[index]
                                                              .state!,
                                                          login: controller
                                                              .empDetails[index]
                                                              .loginTime!,
                                                          logout: controller
                                                              .empDetails[index]
                                                              .logoutTime!,
                                                          onTap: () {
                                                            final data = controller
                                                                    .empDetails[
                                                                index];
                                                            print(data);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) {
                                                              return AdminTrackEmployee(
                                                                customerCode:
                                                                    data.empCode!,
                                                                customerName:
                                                                    data.name!,
                                                                customerDate:
                                                                    data.date!,
                                                              );
                                                            }));
                                                          });
                                                },
                                              ),
                                            ),
                                      Widgets().verticalSpace(2.h),
                                      Widgets().verticalSpace(2.h),
                                    ])));
                      }))));
    });
  }

  /// dialog to show filters to get employee details based on applied filters
  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              GetBuilder<AdminAttendanceController>(builder: (controller) {
            return StatefulBuilder(builder: (context1, myState) {
              return Wrap(
                spacing: 1,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().textWidgetWithW700(
                          titleText: "Filter by", fontSize: 14.sp),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Widgets().verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select BU",
                              onChanged: (value) {
                                myState(() {
                                  selectedBu = value;
                                });

                                // fetchDropDownData();
                              },
                              itemValue: controller.buList,
                              selectedValue: selectedBu),
                        ),
                      ),
                      (globalController.role == "ZSM" ||
                              globalController.role == 'NSM')
                          ? Expanded(
                              flex: 1,
                              child: Widgets().filterByCard(
                                widget: Widgets().commonDropdownWith8sp(
                                    hintText: "Select Zone",
                                    onChanged: (value) {
                                      myState(() {
                                        selectZone = value;
                                      });

                                      //  fetchDropDownData();
                                    },
                                    itemValue: controller.placeList,
                                    selectedValue: selectZone),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().verticalSpace(1.h),
                  globalController.role == "NSM"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Widgets().filterByCard(
                                  widget: Widgets().commonDropdownWith8sp(
                                      hintText: "Select State",
                                      onChanged: (value) {
                                        myState(() {
                                          selectState = value;
                                        });

                                        // fetchDropDownData();
                                      },
                                      itemValue: controller.placeList,
                                      selectedValue: selectState),
                                )),
                          ],
                        )
                      : const SizedBox(),
                  Widgets().verticalSpace(2.h),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Widgets().datePicker(
                            context: context,
                            onTap: () {
                              Get.back();
                            },
                            controller: dateFromController,
                            // width: 30.w,
                            hintText: 'Date from',
                            initialDateTime: initialDateTime,
                            onDateTimeChanged: (value) {
                              setState(() {
                                dateFromController.text = dateTimeUtils
                                    .formatDateTimePreviousOrder(value);
                              });
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: Widgets().datePicker(
                            context: context,
                            onTap: () {
                              Get.back();
                            },
                            controller: dateToController,
                            // width: 30.w,
                            hintText: 'Date to',
                            initialDateTime: initialDateTime,
                            onDateTimeChanged: (value) {
                              setState(() {
                                dateToController.text = dateTimeUtils
                                    .formatDateTimePreviousOrder(value);
                              });
                            }),
                      ),
                    ],
                  ),
                  Widgets().verticalSpace(1.h),
                  Container(
                    height: 20,
                  ),
                  Widgets().verticalSpace(1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () async {
                            await controller
                                .getFilteredAdminAttendance(
                                    fromDate: dateFromController.text,
                                    toDate: dateToController.text,
                                    bu: selectedBu!,
                                    zone: selectZone ?? '',
                                    state: selectState ?? '',
                                    city: '')
                                .then((value) {
                              setState(() {
                                chartData = [
                                  ChartData(
                                      'Total Absent',
                                      controller.totalAbsent.toDouble(),
                                      const Color(0xffEE466B)),
                                  ChartData(
                                      'Total Late',
                                      controller.totalLate.toDouble(),
                                      const Color(0xff6640E6)),
                                  ChartData(
                                      'Total Present',
                                      controller.totalPresent.toDouble(),
                                      const Color(0xff51C378)),
                                ];
                                isFilter = true;
                              });
                            });
                            Get.back();
                          },
                          height: 5.5.h,
                          width: 32.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Apply',
                          titleColor: white),
                      Widgets().horizontalSpace(2.w),
                      Widgets().dynamicButton(
                          onTap: () {
                            setState(() {
                              isFilter = false;
                              selectedBu = null;
                              selectZone = null;
                              selectState = null;
                              dateFromController.text = '';
                              dateToController.text = '';
                            });
                            Get.back();
                          },
                          height: 5.5.h,
                          width: 32.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Clear',
                          titleColor: white),
                      Widgets().verticalSpace(1.5.h),
                    ],
                  ),
                ],
              );
            });
          }));
        });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
