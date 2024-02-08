/// UI file for admin customer primary module to show customers list , customer details(total/new/focused), graph based on customer details

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/admin_module/attandance_module/controllers/AdminAttendanceController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../../../tsi_module/primary_order_module/ui/customer_profile/controller/CustomerProfileController.dart';
import '../../controllers/CustomerProfileController.dart';
import '../customer_details/AdminCustomerDetails.dart';
import 'AdminPrimaryCustomerSearch.dart';

class AdminPrimaryOrder extends StatefulWidget {
  const AdminPrimaryOrder({Key? key}) : super(key: key);

  @override
  State<AdminPrimaryOrder> createState() => _AdminPrimaryOrderState();
}

class _AdminPrimaryOrderState extends State<AdminPrimaryOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<ChartData> chartData = [];

  final TextEditingController searchController = TextEditingController();
  AdminCustomerProfileController adminCustomerProfileController =
      Get.put(AdminCustomerProfileController());
  String? selectedBu;
  String? selectState;
  String? selectZone;
  String? selectDivision;
  String? selectCategory;
  String? selectCity;

  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  bool isFilter = false;
  DateTime initialDateTime = DateTime.now();
  GlobalController globalController = Get.put(GlobalController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchDropDownData();
  }

  fetchData() async {
    await adminCustomerProfileController.getCustomerProfile(
        fromDate: dateFromController.text,
        toDate: dateToController.text,
        bu: selectedBu ?? '',
        zone: selectZone ?? '',
        state: selectState ?? '',
        city: selectCity ?? '',
        role: globalController.role,
        screenName: globalController.customerScreenName);

    double d1 = 0.0;
    double d2 = 0.0;
    double d3 = 0.0;

    if (adminCustomerProfileController.totalCustomer.isNotEmpty) {
      d1 = double.parse(adminCustomerProfileController.totalCustomer);
    }
    if (adminCustomerProfileController.newCustomer.isNotEmpty) {
      d2 = double.parse(adminCustomerProfileController.newCustomer);
    }
    if (adminCustomerProfileController.focusedCustomer.isNotEmpty) {
      d3 = double.parse(adminCustomerProfileController.focusedCustomer);
    }

    setState(() {
      chartData = [
        ChartData('Total Customer', d1, malachite),
        ChartData('New Customer', d2, brinkPinkColor),
        ChartData('Focused Customer', d3, brinkPinkColor),
      ];
    });
  }

  fetchDropDownData() async {
    adminCustomerProfileController.getFiltersData(
        state: selectState ?? '', zone: selectZone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerProfileController>(builder: (controller) {
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
                                              titleText: "Customer Profiles"),
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
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                        bgColor: hintOfGreen,
                                                        borderColor: malachite,
                                                        iconName: groupSvg,
                                                        titleText: controller
                                                            .totalCustomer,
                                                        iconColor: const Color(
                                                            0xff5BCB81),
                                                        context: context,
                                                        subTitleText:
                                                            'Total\nCustomer'),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                  bgColor:
                                                      const Color(0xffFFF6F4),
                                                  borderColor: brinkPinkColor,
                                                  iconName: customerSvg,
                                                  titleText:
                                                      controller.newCustomer,
                                                  context: context,
                                                  iconColor: brinkPinkColor,
                                                  subTitleText: 'New\nCustomer',
                                                ),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                        bgColor: const Color(
                                                            0xffFFFBF5),
                                                        borderColor:
                                                            yellowOrange,
                                                        iconName:
                                                            focusedCustomerSvg,
                                                        titleText: controller
                                                            .focusedCustomer,
                                                        iconColor: yellowOrange,
                                                        context: context,
                                                        subTitleText:
                                                            'Focused Customer'),
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
                                                    series: <CircularSeries>[
                                                      // Render pie chart
                                                      PieSeries<ChartData,
                                                              String>(
                                                          dataSource: chartData,
                                                          pointColorMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.color,
                                                          xValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.y,
                                                          explode: true,
                                                          explodeIndex: 1)
                                                    ])),
                                            Container(
                                              height: 1,
                                              color: const Color(0xffD0D4EC),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
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
                                                            'Total\nCustomer',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
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
                                                              .totalCustomer,
                                                          style: TextStyle(
                                                              color:
                                                                  veryLightBoulder,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 12.sp,
                                                              letterSpacing:
                                                                  .3),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 86,
                                                    color:
                                                        const Color(0xffD0D4EC),
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
                                                            'New\nCustomer',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
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
                                                              .newCustomer,
                                                          style: TextStyle(
                                                              color:
                                                                  veryLightBoulder,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 12.sp,
                                                              letterSpacing:
                                                                  .3),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 86,
                                                    color:
                                                        const Color(0xffD0D4EC),
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
                                                              0xffF5AC2F),
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
                                                            'Focused Customer',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
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
                                                              .focusedCustomer,
                                                          style: TextStyle(
                                                              color:
                                                                  veryLightBoulder,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 12.sp,
                                                              letterSpacing:
                                                                  .3),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: Text(
                                          'Customer List',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: veryLightBoulder),
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: Widgets()
                                            .textFieldWidgetWithSearchDelegate(
                                                controller: searchController,
                                                hintText:
                                                    'Search by name or code',
                                                iconName: search,
                                                keyBoardType:
                                                    TextInputType.text,
                                                onTap: () {
                                                  showSearch(
                                                    context: context,
                                                    delegate:
                                                        AdminPrimaryCustomerSearch(),
                                                  );
                                                },
                                                fillColor: white),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Widgets().customLRPadding(
                                        child: ListView.builder(
                                          itemCount:
                                              controller.customerLists.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Widgets()
                                                .customerProfileExpantionCard(
                                                    context: context,
                                                    shopTitleText: controller
                                                        .customerLists[index]
                                                        .customerName!,
                                                    customerCode:
                                                        '(Code : ${controller.customerLists[index].customerCode!})',
                                                    address: controller
                                                        .customerLists[index]
                                                        .address!,
                                                    beat: controller
                                                        .customerLists[index]
                                                        .beat!,
                                                    city: controller
                                                        .customerLists[index]
                                                        .city!,
                                                    state: controller
                                                        .customerLists[index]
                                                        .state!,
                                                    creditLimit: controller
                                                        .customerLists[index]
                                                        .creditLimit!,
                                                    outstanding: controller
                                                        .customerLists[index]
                                                        .outstanding!,
                                                    overdue: controller
                                                        .customerLists[index]
                                                        .overdue!,
                                                    viewDetailsOnTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (_) {
                                                        return AdminCustomerDetails(
                                                          customerCode: controller
                                                              .customerLists[
                                                                  index]
                                                              .customerCode!,
                                                          customerName: controller
                                                              .customerLists[
                                                                  index]
                                                              .customerName!,
                                                        );
                                                      }));
                                                    },
                                                    noteDetailsOnTap: () {},
                                                    callingOnTap: () {
                                                      Utils().makePhoneCall(
                                                          controller
                                                              .customerLists[
                                                                  index]
                                                              .phoneNo!);
                                                    },
                                                    locationOnTap: () {
                                                      launchMap(controller
                                                          .customerLists[index]
                                                          .address!);
                                                    },
                                                    isVerified: false);
                                          },
                                        ),
                                      ),

                                      /*  Widgets().verticalSpace(2.h),
                                Widgets().customLRPadding(
                                  child: ListView.builder(
                                    itemCount: 4,
                                      shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {

                                      return Widgets().EmployeeCard(

                                      );

                                    },
                                  ),
                                ),
*/
                                      Widgets().verticalSpace(2.h),
                                    ])));
                      }))));
    });
  }

  /// dialog to show filters to get customer details based on applied filters
  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              GetBuilder<AdminCustomerProfileController>(builder: (controller) {
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
                      controller.buList.isNotEmpty
                          ? Expanded(
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
                            )
                          : const SizedBox(),
                      controller.zoneList.isNotEmpty
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
                                    itemValue: controller.zoneList,
                                    selectedValue: selectZone),
                              ))
                          : const SizedBox()
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.stateList.isNotEmpty
                          ? Expanded(
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
                                    itemValue: controller.stateList,
                                    selectedValue: selectState),
                              ))
                          : const SizedBox(),
                      controller.cityList.isNotEmpty
                          ? Expanded(
                              flex: 1,
                              child: Widgets().filterByCard(
                                widget: Widgets().commonDropdownWith8sp(
                                    hintText: "Select City",
                                    onChanged: (value) {
                                      myState(() {
                                        selectCity = value;
                                      });

                                      // fetchDropDownData();
                                    },
                                    itemValue: controller.cityList,
                                    selectedValue: selectCity),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            //  width: 30.w,
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
                            fetchData();
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

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
