import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/views/attendance_module/apply_leave/ui/ApplyLeave.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../../../utils/PermissionController.dart';
import '../../markAttendance/ui/AttendanceDetails.dart';
import '../../markAttendance/ui/ClockInOut.dart';
import '../controllers/ViewAttendanceController.dart';

class AttendanceMonth extends StatefulWidget {
  const AttendanceMonth({Key? key}) : super(key: key);

  @override
  State<AttendanceMonth> createState() => _AttendanceMonthState();
}

class _AttendanceMonthState extends State<AttendanceMonth> {
  ViewAttendanceController viewAttendanceController = Get.put(ViewAttendanceController());
  PermissionController permissionController = Get.put(PermissionController());

  int currentMonthSelected = DateTime.now().month;
  int currentYearSelected = DateTime.now().year;
  int currentDate = DateTime.now().year;

  @override
  void initState() {
    fn();
    super.initState();
  }

  fn() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading Data, Please wait...");
      viewAttendanceController.monthlyAttendanceData(currentMonthSelected, currentYearSelected).then((value) {
        Get.back();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
      context: context,
      isShowBackButton: false,
      body: Container(
        width: 100.w,
        height: 100.h,
        color: alizarinCrimson,
        child: bottomDetailsSheet(),
      ),
    ));
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return GetBuilder<ViewAttendanceController>(builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              decoration: Widgets().boxDecorationTopLRRadius(color: white, topLeft: 2.h, topRight: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().draggableBottomSheetTopContainer(titleText: "Attendance"),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                    child: Widgets().dynamicButton(
                        onTap: () {
                          Get.to(const ClockInOut());
                        },
                        height: 6.5.h,
                        width: 100.w,
                        buttonBGColor: alizarinCrimson,
                        titleText: 'Mark Today Attendance',
                        titleColor: white),
                  ),
                  Widgets().verticalSpace(1.2.h),
                  Widgets().customLRPadding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Widgets().attendanceStatusRow(titleText: "Present", color: malachite),
                        Widgets().attendanceStatusRow(titleText: "Absent/Leave", color: alizarinCrimson),
                        Widgets().attendanceStatusRow(titleText: "Holiday", color: meteorColor),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  Widgets().verticalSpace(1.2.h),
                  SizedBox(
                    height: 55.h,
                    child: Widgets().customLRPadding(
                      child: SfCalendar(
                        view: CalendarView.month,
                        showNavigationArrow: true,
                        headerStyle: const CalendarHeaderStyle(textAlign: TextAlign.center, textStyle: TextStyle(fontWeight: FontWeight.w800)),
                        onTap: (calender) {
                          //2023-10-31 00:00:00.000 => "05/10/2023"

                          if (!viewAttendanceController.isDateInFuture(calender.date.toString())) {
                            DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
                            String selectedDate = dateTimeUtils.convertDateFormat(calender.date.toString());
                            Widgets().loadingDataDialog(loadingText: "Location Fetching, Please wait...");
                            viewAttendanceController.dailyAttendanceApi(selectedDate).then((value) {
                              Get.back();
                              if (value != null) {
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                  return AttendanceDetails(attendanceApiResponse: value, todayDate: dateTimeUtils.formatDate(calender.date.toString()));
                                }));
                              }
                            });
                          } else {
                            Widgets().showToast("data not available for future dates  !!");
                          }
                        },
                        monthCellBuilder: (context, MonthCellDetails details) {
                          return cellItem(context, details);
                        },
                        monthViewSettings:
                            const MonthViewSettings(numberOfWeeksInView: 6, dayFormat: 'EEE', showTrailingAndLeadingDates: false, monthCellStyle: MonthCellStyle()),
                        selectionDecoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.transparent, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          shape: BoxShape.rectangle,
                        ),
                        onSelectionChanged: (d) {},
                        onViewChanged: (ViewChangedDetails data) async {
                          List<DateTime> visibleDates = [];
                          visibleDates = data.visibleDates;

                          currentMonthSelected = visibleDates[0].month;
                          currentYearSelected = visibleDates[0].year;
                          Future.delayed(const Duration(milliseconds: 500), () async {
                            Widgets().loadingDataDialog(loadingText: "Loading Data, Please wait...");

                            await viewAttendanceController.monthlyAttendanceData(currentMonthSelected, currentYearSelected);
                          });

                          Get.back();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Widgets().verticalSpace(1.5.h),
                        // Widgets().dynamicButton(
                        //     onTap: () {
                        //       Get.to(const ClockInOut());
                        //     },
                        //     height: 6.5.h,
                        //     width: 100.w,
                        //     buttonBGColor: alizarinCrimson,
                        //     titleText: 'Mark Today Attendance',
                        //     titleColor: white),
                        // Widgets().verticalSpace(1.2.h),
                        /* Widgets().dynamicButton(
                            onTap: () {
                              Get.to(const ApplyLeave());
                            },
                            height: 6.h,
                            width: MediaQuery.of(context).size.width,
                            buttonBGColor: veryLightBoulder,
                            titleText: 'Apply Leave',
                            titleColor: white),*/
                        Widgets().verticalSpace(2.5.h),
                        Widgets().totalOrderValueTile1(
                          context,
                          workingIcon,
                          "Total Working Days",
                          viewAttendanceController.haveValue(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalWorkedDays.toString())
                              ? '${viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalWorkedDays.toString() ?? ''} Days'
                              : 'N/A',
                          [magicMint, oysterBay],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().totalOrderValueTile1(
                          context,
                          workingIcon,
                          "Total Working Hrs",
                          viewAttendanceController.haveValue(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalWorkedHour.toString())
                              ? '${viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalWorkedHour.toString() ?? ''} Hrs'
                              : 'N/A',
                          [pink, zumthor],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().totalOrderValueTile1(
                          context,
                          workingIcon,
                          "Primary Order Punch",
                          viewAttendanceController.haveValue(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].primaryOrderPunched.toString())
                              ? '${viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].primaryOrderPunched.toString() ?? ''}'
                              : 'N/A',
                          [magicMint, oysterBay],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().totalOrderValueTile1(
                          context,
                          workingIcon,
                          "Secondary Order Punch",
                          viewAttendanceController.haveValue(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].secondaryOrderPunched.toString())
                              ? '${viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].secondaryOrderPunched.toString() ?? ''}'
                              : 'N/A',
                          [pink, zumthor],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().totalOrderValueTile1(
                          context,
                          workingIcon,
                          "Total Visited Customer",
                          viewAttendanceController.haveValue(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalVisitedCustomer.toString())
                              ? '${viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].totalVisitedCustomer.toString() ?? ''}'
                              : 'N/A',
                          [magicMint, oysterBay],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        InkWell(
                            onTap: () async {
                              bool permissionGranted = await permissionController.isStoragePermissionGranted();

                              printMe(permissionGranted);

                              if (permissionGranted) {
                                viewAttendanceController.downloadAndSaveReport(currentMonthSelected, currentYearSelected);
                              } else {
                                Widgets().showToast("Please Grant permission to save File !!");
                                await permissionController.askReadWritePermission();
                              }
                            },
                            child: Widgets().textWithArrowIcon(icon: Icons.arrow_downward_outlined, textTitle: "Download This Month Report")),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  String isInputStatus(List<String> presentList, List<String> holidayList, String inputDate) {
    String formattedInputDate = inputDate;

    if (viewAttendanceController.isPresentExist(presentList, inputDate)) {
      return 'present';
    } else if (holidayList.contains(formattedInputDate) || viewAttendanceController.isSunday(formattedInputDate)) {
      return 'holiday';
    } else if (viewAttendanceController.isDateInFuture(formattedInputDate)) {
      return 'future';
    } else if (viewAttendanceController.isDateToday(formattedInputDate)) {
      return 'today';
    } else {
      return 'absent';
    }
  }

  cellItem(context, MonthCellDetails details) {
    String inputDate = details.date.toString();
    String dayStatus = isInputStatus(viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].dates ?? [],
        viewAttendanceController.monthlyAttendanceApiResponse?.items?[0].holidays ?? [], inputDate);

    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: viewAttendanceController.getBorderColor(dayStatus), width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            details.date.day.toString(),
            style: TextStyle(
              color: viewAttendanceController.getTextColor(dayStatus),
              fontWeight: viewAttendanceController.isDateToday(inputDate) ? FontWeight.w800 : FontWeight.w500,
              fontSize: viewAttendanceController.isDateToday(inputDate) || viewAttendanceController.isDateInFuture(inputDate) ? 16 : 14,
              decoration: viewAttendanceController.isDateToday(inputDate) ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
