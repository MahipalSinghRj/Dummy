import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kg_charts/kg_charts.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timelines/timelines.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../utils/ChartsSupportClasses.dart';
import '../controllers/AdminHomeController.dart';
import '../models/TopCustomersAdminResponse.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminHomeController adminHomeController = Get.put(AdminHomeController());

  String? selectedBu;
  String? selectDivision;
  String? selectCategory;
  String? selectState;
  String? selectCity;
  String? selectZone;

  //List<ChartSampleData> productPerformaceChart = [];

  List<IndicatorModel> radarList = [];
  List<double> completedCustomer = [];
  List<double> pendingCustomer = [];

  List<ChartData> dataDonut = [];
  List<ChartSampleData>? primarySecondarychart = [];

  List<TopCustomersAdmin> topCustomers = [];

  double maxRaderNumber =0.0;

  List<List<TopAdminProductPrfmcChart>> dataSourceOfFinancialYearList = [];

  List<List<TopAdminProductPrfmcChart>> dataBusniessAchimentrList = [];

  String? selectedSalesBUFilter;

  GlobalController globalController = Get.put(GlobalController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentMonthAndYear();
    callInitialAPIs();
    fetchDropDownData();

    printMe("Admin app version : ${globalController.appVersion}");
  }

  fetchDropDownData() async {
    adminHomeController.getAdminData(
        bu: selectedBu ?? '',
        division: selectDivision ?? '',
        category: selectCategory ?? '',
        brand: "",
        city: selectCity ?? '',
        state: selectState ?? '',
        zone: selectZone ?? '');
  }

  callInitialAPIs() async {

    /*SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });*/

    await Future.wait([
      getFilterValues(adminHomeController),
      getBeatStatusValues(adminHomeController),
      getPrimarySecondaryValues(adminHomeController),
      getBusinessAchievementsValues(adminHomeController),
      getRetailerValues(adminHomeController),
      getCustomerValues(adminHomeController),
      getAdminAttandanceValues(adminHomeController),
      getProductPerformanceValues(adminHomeController, selectedSalesBUFilter),
    ]);

   // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return SafeArea(
          child: Widgets().scaffoldWithAppBarDrawer(
              context: context,
              body: Container(
                height: 100.h,
                width: 100.w,
                color: white,
                child: bottomDetailsSheet(),
              )));
    });
  }

  Widget bottomDetailsSheet() {
    return CustomeLoading(
      isLoading: adminHomeController.isLoading,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Widgets().verticalSpace(2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: Widgets().tileWithTwoIconAndSingleText(
                    context: context,
                    title: 'Search by Filter',
                    titleIcon: filter,
                    subtitleIcon: rightArrowWithCircleIcon,
                    tileGradientColor: [pink, zumthor],
                    onTap: () {
                      showNewDialog();
                    }),
              ),
              activityTrackerBlock(),
              Widgets().verticalSpace(2.h),
              (dataSourceOfFinancialYearList.isEmpty) ? Container() : productPerformanceBlock(),
              Widgets().verticalSpace(2.h),
              (dataDonut.isEmpty) ? Container() : attandanceAnalysisBlock(),
              Widgets().verticalSpace(2.h),
              beatStatusBlock(),
              Widgets().verticalSpace(2.h),
              primarySecondaryBlock(),
              Widgets().verticalSpace(2.h),
              (dataBusniessAchimentrList.isEmpty) ? Container() :     businessAchievementsBlock(),
              Widgets().verticalSpace(2.h),
              customersAndRetailersBlock(),
            ],
          ),
        ),
      ),
    );
  }

  Widget activityTrackerBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity Tracker",
                  style: TextStyle(color: codGray, fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedActivityFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "TODAY",
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedActivityFilter(filter: data!);
                      getFilterValues(controller);
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 16.h,
              //  width: 100.w,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 55.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: lightPinkColor
                          // gradient: LinearGradient(
                          //   colors: [pink, tickleMePink],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInBack,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: coralRedBlur,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    rupeesSign,
                                    style: TextStyle(fontWeight: FontWeight.w800, color: white),
                                  ),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.totalPrimarySales}K",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Widgets().verticalSpace(0.5.h),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Total Primary Sales",
                                              style: TextStyle(color: alizarinCrimson),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: 100.w,
                              child: SvgPicture.asset(
                                graphIndicator,
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 55.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: tangerine.withOpacity(0.3)
                          // gradient: LinearGradient(
                          //   colors: [pink, tickleMePink],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInBack,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: eggSourColor,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    personSvgIcon,
                                  ),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.primaryOrderCount}",
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Widgets().verticalSpace(0.5.h),
                                    Text(
                                      "Primary Order Count",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              //color: tangerine,
                              width: 100.w,
                              child: SvgPicture.asset(
                                newleadgraphSvg,
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 55.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: mountainMeadow
                          // gradient: LinearGradient(
                          //   colors: [pink, tickleMePink],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInBack,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: coralRedBlur,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    rupeesSign,
                                    style: TextStyle(fontWeight: FontWeight.w800, color: white),
                                  ),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.secondaryOrderCount}",
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Widgets().verticalSpace(0.5.h),
                                    Text(
                                      "Secondary Order Count ",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: 100.w,
                              child: SvgPicture.asset(
                                newcustomergraphSvg,
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 55.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: mountainMeadow
                          // gradient: LinearGradient(
                          //   colors: [pink, tickleMePink],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInBack,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: coralRedBlur,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    rupeesSign,
                                    style: TextStyle(fontWeight: FontWeight.w800, color: white),
                                  ),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.newCustomers}",
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Widgets().verticalSpace(0.5.h),
                                    Text(
                                      "New Customers ",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: 100.w,
                              child: SvgPicture.asset(
                                newcustomergraphSvg,
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 55.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: mountainMeadow
                          // gradient: LinearGradient(
                          //   colors: [pink, tickleMePink],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInBack,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: coralRedBlur,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    rupeesSign,
                                    style: TextStyle(fontWeight: FontWeight.w800, color: white),
                                  ),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.newRetailers}",
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                    ),
                                    Widgets().verticalSpace(0.5.h),
                                    Text(
                                      "New Retailers",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: 100.w,
                              child: SvgPicture.asset(
                                newcustomergraphSvg,
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ]),
      );
    });
  }

  Widget productPerformanceBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Product Performance",
                    style: TextStyle(color: codGray, fontSize: 16.sp, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                (controller.filterList.isEmpty)
                    ? Container()
                    : SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedSalesBUFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: controller.filterList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedSalesBuFilter(filter: data!);
                      getProductPerformanceValues(controller,controller.selectedSalesBUFilter);
                    }),
                  ),
                ),
              ],
            ),
          ),
          _buildSalesStackedLines(),
        ]),
      );
    });
  }

  Widget beatStatusBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Beat Status",
                  style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedBeatFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "TODAY",
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedBeatFilter(filter: data!);
                      getBeatStatusValues(controller);
                    }),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 45.w,
                height: 20.h,
                decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [cornflowerBlue, lochmara]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Widgets().verticalSpace(0.5.h),
                    Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(child: SvgPicture.asset(amountCollectIcon)),
                        )),
                    Widgets().verticalSpace(0.5.h),
                    Text(
                      "${controller.totalBeats}",
                      style: TextStyle(fontSize: 15.sp, color: white, fontWeight: FontWeight.w600),
                    ),
                    Widgets().verticalSpace(0.5.h),
                    Text(
                      "Total Beats",
                      style: TextStyle(fontSize: 12.sp, color: white),
                    ),
                    Widgets().verticalSpace(1.0.h),
                  ],
                ),
              ),
              Container(
                width: 45.w,
                height: 20.h,
                decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [peachOrange, tickleMePink]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Widgets().verticalSpace(0.5.h),
                    Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(child: SvgPicture.asset(amountCollectIcon)),
                        )),
                    Widgets().verticalSpace(0.5.h),
                    Text(
                      "${controller.totalAllocatedBeats}",
                      style: TextStyle(fontSize: 15.sp, color: white, fontWeight: FontWeight.w600),
                    ),
                    Widgets().verticalSpace(1.0.h),
                    Text(
                      "Allocated Beats",
                      style: TextStyle(fontSize: 12.sp, color: white),
                    ),
                    Widgets().verticalSpace(0.5.h),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Widgets().tileWithTwoIconAndSingleText(
                context: context, title: 'View Beat Map', titleIcon: filter, subtitleIcon: rightArrowWithCircleIcon,
                tileGradientColor: [pink, zumthor], onTap: () {}),
          ),
          (radarList.isEmpty) ? Container() : _buildRadarChart(controller)
        ]),
      );
    });
  }

  Widget primarySecondaryBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Primary and Secondary order",
                    style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedPrimarySecFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "TODAY",
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedPrimarySecFilter(filter: data!);
                      getPrimarySecondaryValues(controller);
                    }),
                  ),
                ),
              ],
            ),
          ),
          _buildPreSecChart(),
        ]),
      );
    });
  }

  Widget businessAchievementsBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Business Plan VS Achievements",
                    style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedBusinessAchievementsFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "2021",
                      "2022",
                      "2023",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedBusinessAchievementsFilter(filter: data!);
                      getBusinessAchievementsValues(controller);
                    }),
                  ),
                ),
              ],
            ),
          ),
          _buildBusinessSalesStackedLines(),
        ]),
      );
    });
  }

  Widget attandanceAnalysisBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Attendance Analytics",
                    style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedAttandanceFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "TODAY",
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedAttandanceFilter(filter: data!);
                      getAdminAttandanceValues(controller);
                    }),
                  ),
                ),
              ],
            ),
          ),
          _buildDoughnutChart(),
          const Divider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Indicator.dot(
                      color: const Color(0xFF34D196),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Present\nEmployees",
                      style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${controller.totalPresentEmployees}",
                      style: TextStyle(color: veryLightBoulder, fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Indicator.dot(
                      color: const Color(0xFFFF715B),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Absent/\nLeave Employees",
                      style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${controller.totalAbsentEmployees}",
                      style: TextStyle(color: veryLightBoulder, fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Indicator.dot(
                      color: const Color(0xFF6610F2),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Late\nComers",
                      style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${controller.totalLateComers}",
                      style: TextStyle(color: veryLightBoulder, fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      );
    });
  }

  Widget customersAndRetailersBlock() {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Container(
        color: chablis,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                  child: ToggleSwitch(
                    minWidth: 40.w,
                    minHeight: 6.h,
                    cornerRadius: 2.h,
                    activeBgColors: [
                      [alizarinCrimson],
                      [alizarinCrimson],
                    ],
                    customTextStyles: [
                      TextStyle(color: controller.selectedToggleIndex == 0 ? white : codGray, fontSize: 12.sp),
                      TextStyle(color: controller.selectedToggleIndex == 1 ? white : codGray, fontSize: 12.sp)
                    ],
                    inactiveBgColor: magnolia,
                    initialLabelIndex: controller.selectedToggleIndex,
                    totalSwitches: 2,
                    labels: const ['Customers', 'Retailers'],
                    radiusStyle: true,
                    onToggle: (index) {
                      printMe("index : $index");
                      controller.isSelectedToggleIndex(index: index!);
                    },
                  ),
                ),
              ],
            ),
          ),
          Widgets().verticalSpace(2.h),
          (controller.selectedToggleIndex == 0) ? _buildCustomerBlock(controller) : _buildRetailerBlock(controller)
        ]),
      );
    });
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: GetBuilder<AdminHomeController>(builder: (controller) {
            return StatefulBuilder(builder: (context1, myState) {
              return Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
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

                                fetchDropDownData();
                              },
                              itemValue: controller.buList,
                              selectedValue: selectedBu),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Widgets().filterByCard(
                            widget: Widgets().commonDropdownWith8sp(
                                hintText: "Select Zone",
                                onChanged: (value) {
                                  myState(() {
                                    selectZone = value;
                                  });

                                  fetchDropDownData();
                                },
                                itemValue: controller.zoneList,
                                selectedValue: selectZone),
                          )),
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
                                hintText: "Select Division",
                                onChanged: (value) {
                                  myState(() {
                                    selectDivision = value;
                                  });

                                  fetchDropDownData();
                                },
                                itemValue: controller.divisionList,
                                selectedValue: selectDivision),
                          )),
                      Expanded(
                          flex: 1,
                          child: Widgets().filterByCard(
                            widget: Widgets().commonDropdownWith8sp(
                                hintText: "Select State",
                                onChanged: (value) {
                                  myState(() {
                                    selectState = value;
                                  });

                                  fetchDropDownData();
                                },
                                itemValue: controller.stateList,
                                selectedValue: selectState),
                          )),
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
                                hintText: "Select Category",
                                onChanged: (value) {
                                  myState(() {
                                    selectCategory = value;
                                  });

                                  fetchDropDownData();
                                },
                                itemValue: controller.categoryList,
                                selectedValue: selectCategory),
                          )),
                      Expanded(
                          flex: 1,
                          child: Widgets().filterByCard(
                            widget: Widgets().commonDropdownWith8sp(
                                hintText: "Select City",
                                onChanged: (value) {
                                  myState(() {
                                    selectCity = value;
                                  });

                                  fetchDropDownData();
                                },
                                itemValue: controller.cityList,
                                selectedValue: selectCity),
                          )),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Widgets().verticalSpace(1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () {
                            printMe("BU : $selectedBu");
                            printMe("ZONE : $selectZone");
                            printMe("DIVISION : $selectDivision");
                            printMe("STATE : $selectState");
                            printMe("CATEGORY : $selectCategory");
                            printMe("CITY : $selectCity");

                            Get.back();

                            getFilterValues(controller);

                            getBeatStatusValues(controller);

                            getPrimarySecondaryValues(controller);

                            getBusinessAchievementsValues(controller);

                            getRetailerValues(controller);

                            getCustomerValues(controller);

                            getAdminAttandanceValues(controller);

                            getProductPerformanceValues(controller,controller.selectedSalesBUFilter);
                          },
                          height: 5.5.h,
                          width: 32.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Apply',
                          titleColor: white),
                      Widgets().horizontalSpace(2.w),
                      Widgets().dynamicButton(onTap: () {}, height: 5.5.h, width: 32.w, buttonBGColor: alizarinCrimson, titleText: 'Clear', titleColor: white),
                      Widgets().verticalSpace(1.5.h),
                    ],
                  ),
                ],
              );
            });
          }));
        });
  }

  Future<void> getFilterValues(AdminHomeController controller) async {
    controller
        .getActivityTracker(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedActivityFilter)
        .then((value) {
      setState(() {});
    });
  }

  Future<void> getBeatStatusValues(AdminHomeController controller) async {
    controller
        .getBeatStatus(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedBeatFilter)
        .then((value) {
      for (int i = 0; i < controller.completedCustomersBeatList.length; i++) {
        completedCustomer.add(controller.completedCustomersBeatList[i].toDouble());
        pendingCustomer.add(controller.pendingCustomersBeatList[i].toDouble());
      }

      double highestNumberComplete = findHighestNumber(completedCustomer);
      double highestNumberPending = findHighestNumber(pendingCustomer);

      setState(() {});

      if(highestNumberComplete>highestNumberPending){
        setState(() {
          maxRaderNumber=highestNumberComplete;
        });
      }else{
        setState(() {
          maxRaderNumber=highestNumberPending;
        });
      }

      printMe("Max RaderNumber $maxRaderNumber");

      for (int i = 0; i < controller.completedCustomersBeatList.length; i++) {
        IndicatorModel model = IndicatorModel(controller.categoriesBeatList[i],maxRaderNumber);
        radarList.add(model);
      }



    });
  }

  double findHighestNumber(List<double> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError("The list is empty");
    }

    double highestNumber = numbers[0]; // Assume the first element is the highest

    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] > highestNumber) {
        highestNumber = numbers[i];
      }
    }

    return highestNumber;
  }

  Future<void> getPrimarySecondaryValues(AdminHomeController controller) async {
    primarySecondarychart!.clear();

    controller
        .getPrimarySecondary(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedPrimarySecFilter)
        .then((value) {
      for (int i = 0; i < controller.primaryCategoriesList.length; i++) {
        primarySecondarychart!.add(ChartSampleData(
          x: controller.primaryCategoriesList[i],
          y: controller.primaryOrdersList[i],
          secondSeriesYValue: controller.secondaryOrdersList[i],
        ));
      }

      setState(() {});
    });
  }

  Future<void> getBusinessAchievementsValues(AdminHomeController controller) async {
    controller
        .getBusinessAchivement(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedBusinessAchievementsFilter)
        .then((value) {
      for (int salesIndex = 0; salesIndex <= controller.businessData.length - 1; salesIndex++) {
        dataBusniessAchimentrList.add(rawCalculation(controller.businessData[salesIndex].data as List<int>));
      }

      setState(() {});
    });
  }

  Future<void> getRetailerValues(AdminHomeController controller) async {
    controller
        .getRetailer(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedBusinessAchievementsFilter)
        .then((value) {
      setState(() {
        // retailers =value!.retailers!;
      });
    });
  }

  Future<void> getCustomerValues(AdminHomeController controller) async {
    controller
        .getCustomerAPI(
            stateName: selectState ?? "",
            cityName: selectCity ?? "",
            zoneName: selectZone ?? "",
            buName: selectedBu ?? "",
            filterType: controller.selectedBusinessAchievementsFilter)
        .then((value) {
      setState(() {
        topCustomers = value!.topCustomers!;
      });
    });
  }

  Future<void> getAdminAttandanceValues(AdminHomeController controller) async {
    controller
        .getAdminAttendence(
            buName: selectedBu ?? '',
            division: selectDivision ?? '',
            category: selectCategory ?? '',
            brand: "",
            cityName: selectCity ?? '',
            stateName: selectState ?? '',
            zoneName: selectZone ?? '',
            filterType: controller.selectedAttandanceFilter)
        .then((value) {
      dataDonut = [
        ChartData('Present', controller.totalPresentEmployees!, const Color(0xFF34D196)),
        ChartData('Absent', controller.totalAbsentEmployees!, const Color(0xFFFF715B)),
        ChartData('Late', controller.totalLateComers!, const Color(0xFF6610F2)),
      ];
      setState(() {});
    });
  }

  Future<void> getProductPerformanceValues(
      AdminHomeController controller, selectedSalesBUFilter) async {
    controller
        .getProductPerformance(
            buName: selectedBu ?? '',
            division: selectDivision ?? '',
            category: selectCategory ?? '',
            brand: "",
            cityName: selectCity ?? '',
            stateName: selectState ?? '',
            zoneName: selectZone ?? '',
            filterType: selectedSalesBUFilter)
        .then((value) {


      for (int salesIndex = 0; salesIndex <= controller.businessProductData.length - 1; salesIndex++) {
        dataSourceOfFinancialYearList.add(rawCalculation(controller.businessProductData[salesIndex].data as List<int>));
      }
      setState(() {});

    });
  }

  List<TopAdminProductPrfmcChart> rawCalculation(List<int> salesData) {

    List<TopAdminProductPrfmcChart> dataSourceList = <TopAdminProductPrfmcChart>[];
    for (int i = 0; i < adminHomeController.businessData.length; i++) {
      dataSourceList.add(TopAdminProductPrfmcChart(
        '$i',
        salesData[i],
      ));
    }
    return dataSourceList;
  }

  _buildRadarChart(controller) {
    return SizedBox(
      child: RadarWidget(
        skewing: 0,
        radarMap: RadarMapModel(
          legend: [
            LegendModel('Completed Customers', const Color(0XFF50A55D)),
            LegendModel('Pending Customers', const Color(0XFFFFD401)),
          ],
          indicator: radarList,
          data: [
            MapDataModel(completedCustomer),
            MapDataModel(pendingCustomer),
          ],
          radius: 130,
          duration: 2000,
          shape: Shape.square,
          maxWidth: 70,
          line: LineModel(4),
        ),
        textStyle: const TextStyle(color: Colors.black, fontSize: 14),
        isNeedDrawLegend: true,
        outLineText: (data, max) => "${data * 100 ~/ max}%",
      ),
    );
  }

  _buildDoughnutChart() {
    return SfCircularChart(series: <CircularSeries>[
      // Renders doughnut chart
      DoughnutSeries<ChartData, String>(
          dataSource: dataDonut,
          explodeOffset: '5%',
          explode: true,
          explodeAll: true,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ]);
  }

  _buildPreSecChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
        // tooltipBehavior: _tooltip,
        series: <ChartSeries<ChartSampleData, String>>[
          BarSeries<ChartSampleData, String>(
              dataSource: primarySecondarychart!,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              color: const Color(0xFF8183FF),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          BarSeries<ChartSampleData, String>(
              dataSource: primarySecondarychart!,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.secondSeriesYValue,
              color: const Color(0xFFFF76BA),
              borderRadius: const BorderRadius.all(Radius.circular(5)))
        ]);
  }

  _buildCustomerBlock(AdminHomeController controller) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: topCustomers.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Widgets().customerProfileExpantionCard(
              context: context,
              shopTitleText: '${topCustomers[index].customerName}',
              customerCode: '(Code : ${topCustomers[index].customerCode})',
              address: '${topCustomers[index].cutomerAddress}',
              beat: '${topCustomers[index].customerBeat}',
              city: '${topCustomers[index].customerCity}',
              state: '${topCustomers[index].customerState}',
              creditLimit: '${topCustomers[index].customerCreditLimit}',
              outstanding: '${topCustomers[index].customerOSAmount}',
              overdue: '${topCustomers[index].customerOVAmount}',
              noteDetailsOnTap: () {},
              callingOnTap: () {},
              locationOnTap: () {},
              viewDetailsOnTap: () {},
              isVerified: false);
        });
  }

  _buildRetailerBlock(AdminHomeController controller) {
    printMe("retailers length : ${controller.retailers.length}");
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: controller.retailers.length,
        itemBuilder: (context, index) {
          return Widgets().adminRetaierExpantionCard(
              context: context,
              shopTitleText: '${controller.retailers[index].retailerName}',
              customerCode: '(Code : ${controller.retailers[index].retailerCode})',
              address: '${controller.retailers[index].retailerAddress}',
              beat: '${controller.retailers[index].beat}',
              city: '${controller.retailers[index].city}',
              state: '${controller.retailers[index].state}',
              isVerified: false);
        });
  }



  SfCartesianChart _buildSalesStackedLines() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ' '),
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0),
          rangePadding: ChartRangePadding.auto, minimum: 0),
      /*primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.normal,
          axisLine: const AxisLine(width: 1),
          *//*title: AxisTitle(
            text: "Amount (in Lacs)",
            alignment: ChartAlignment.center
          ),*//*
          //numberFormat:  NumberFormat.compact(),
          labelPosition: ChartDataLabelPosition.outside,
          majorTickLines: const MajorTickLines(size: 1)),*/
      series: _getSalesStackedLine100Series(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineSeries<TopAdminProductPrfmcChart, String>> _getSalesStackedLine100Series() {
    List<SplineSeries<TopAdminProductPrfmcChart, String>> generateStackedSeriesList = [];

    for (int dataSourceIndex = 0; dataSourceIndex <= dataSourceOfFinancialYearList.length - 1; dataSourceIndex++) {
      generateStackedSeriesList.add(SplineSeries<TopAdminProductPrfmcChart, String>(
          dataSource: dataSourceOfFinancialYearList[dataSourceIndex],
          xValueMapper: (TopAdminProductPrfmcChart sales, _) => sales.x,
          yValueMapper: (TopAdminProductPrfmcChart sales, _) {
            return sales.y;
          },
          /*dataLabelMapper:  (TopAdminProductPrfmcChart sales, _) {
            return "${numDifferentiation(sales.y.toString())} lac";
          },
          name: homeController.salesDataBuSales[dataSourceIndex].name,*/
          legendIconType: LegendIconType.circle,
          enableTooltip: true,
          /* color: homeController.salesDataBuSales[dataSourceIndex].colorCode != null
              ? HexColor(homeController.salesDataBuSales[dataSourceIndex].colorCode.toString())
              : codGray,*/
          markerSettings: const MarkerSettings(isVisible: false)));
    }
    return generateStackedSeriesList;
  }

  num numDifferentiation(String value) {
    int v = int.parse(value);
    double a = (v / 100000);
    value = '$a';
    return num.parse(value);
  }

  getCurrentMonthAndYear() {
    DateTime now = DateTime.now();
    selectedSalesBUFilter = DateFormat('MMM yyyy').format(now);
    setState(() {
      adminHomeController.selectedSalesBUFilter = selectedSalesBUFilter;
     // adminHomeController.selectedSalesBUFilter = "Jan 2023";
    });
    //homeController.isSelectedSalesBuFilter(filter: selectedSalesBUFilter!);
  }

  SfCartesianChart _buildBusinessSalesStackedLines() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ' '),
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0),
          rangePadding: ChartRangePadding.auto, minimum: 0),
      series: _getSalesStackedBusinessSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineSeries<TopAdminProductPrfmcChart, String>> _getSalesStackedBusinessSeries() {
    List<SplineSeries<TopAdminProductPrfmcChart, String>> generateStackedSeriesList = [];

    for (int dataSourceIndex = 0; dataSourceIndex <= dataBusniessAchimentrList.length - 1; dataSourceIndex++) {
      generateStackedSeriesList.add(SplineSeries<TopAdminProductPrfmcChart, String>(
          dataSource: dataBusniessAchimentrList[dataSourceIndex],
          xValueMapper: (TopAdminProductPrfmcChart sales, _) => sales.x,
          yValueMapper: (TopAdminProductPrfmcChart sales, _) {
            return sales.y;
          },
          legendIconType: LegendIconType.circle,
          enableTooltip: true,
          /* color: homeController.salesDataBuSales[dataSourceIndex].colorCode != null
              ? HexColor(homeController.salesDataBuSales[dataSourceIndex].colorCode.toString())
              : codGray,*/
          markerSettings: const MarkerSettings(isVisible: false)));
    }
    return generateStackedSeriesList;
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}
