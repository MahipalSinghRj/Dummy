import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerNewOrderController.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/ui/new_order/AdminPrimaryNewOrderSearch.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/ui/order_detail/OrderDetail.dart';
import 'package:smartanchor/views/home_module/BottomNavigation/LandingPage.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/no_order_controller/NoOrderController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../../../../utils/FileUtils.dart';
import '../../../../tsi_module/primary_order_module/controllers/AllInvoicesController.dart';

class AdminNewOrder extends StatefulWidget {
  const AdminNewOrder({Key? key}) : super(key: key);

  @override
  State<AdminNewOrder> createState() => _AdminNewOrderState();
}

class _AdminNewOrderState extends State<AdminNewOrder> {
  NoOrderController noOrderController = Get.put(NoOrderController());
  GlobalController globalController = Get.put(GlobalController());

  final TextEditingController commentController = TextEditingController();

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;
  DateTime initialDateTime = DateTime.now();

  final TextEditingController orderController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  AllInvoicesController allInvoicesController =
      Get.put(AllInvoicesController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  final TextEditingController searchController = TextEditingController();

  List<ChartData> chartData = [
    /* ChartData('Jack', 24, brinkPinkColor),
    ChartData('David', 10, yellowOrange),
    ChartData('Steve', 58, malachite),*/
  ];
  AdminCustomerNewOrderController adminCustomerNewOrderController =
      Get.put(AdminCustomerNewOrderController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await adminCustomerNewOrderController.getCustomerNewOrders(
        fromDate: dateFromController.text,
        toDate: dateToController.text,
        orderId: orderController.text,
        screenName: globalController.customerScreenName);

    double doubleValue =
        double.parse(adminCustomerNewOrderController.orderSales);
    log(doubleValue.toString());
    setState(() {
      chartData = [
        ChartData(
            'Total Customer Visited',
            adminCustomerNewOrderController.totalCustomerVisited.toDouble(),
            malachite),
        ChartData(
            'Order Count',
            adminCustomerNewOrderController.newOrderCount.toDouble(),
            brinkPinkColor),
        ChartData('Order Sales', doubleValue, yellowOrange),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerNewOrderController>(builder: (controller) {
      return SafeArea(
          child: Widgets().scaffoldWithAppBarDrawer(
        context: context,
        body: Container(
            width: 100.w,
            height: 100.h,
            color: alizarinCrimson,
            child: DraggableScrollableSheet(
                initialChildSize: 01,
                minChildSize: 01,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: Widgets().boxDecorationTopLRRadius(
                          color: white, topLeft: 2.h, topRight: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Widgets().draggableBottomSheetTopContainer(
                                  titleText: "New Orders"),
                              //Widgets().verticalSpace(2.h),
                              Container(
                                decoration: Widgets()
                                    .commonDecorationWithGradient(
                                        borderRadius: 0,
                                        gradientColorList: [pink, zumthor]),
                                child: Widgets().customLRPadding(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Widgets().verticalSpace(2.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Widgets().textWidgetWithW700(
                                              titleText: 'Select Date Range',
                                              fontSize: 11.sp),
                                        ],
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Widgets().noOrdersExpansionTile(
                                        context: context,
                                        textFiedWidget: Widgets()
                                            .textFieldWidgetWithoutIcon(
                                                controller: orderController,
                                                hintText: 'Enter Order ID',
                                                keyBoardType:
                                                    TextInputType.text,
                                                fillColor: white),
                                        datePickerWidget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Widgets().datePicker(
                                                context: context,
                                                onTap: () {
                                                  Get.back();
                                                },
                                                controller: dateFromController,
                                                width: 40.w,
                                                hintText: 'Date from',
                                                initialDateTime:
                                                    initialDateTime,
                                                onDateTimeChanged: (value) {
                                                  setState(() {
                                                    dateFromController.text =
                                                        dateTimeUtils
                                                            .formatDateTime(
                                                                value);
                                                  });
                                                }),
                                            Widgets().datePicker(
                                                context: context,
                                                onTap: () {
                                                  Get.back();
                                                },
                                                controller: dateToController,
                                                width: 40.w,
                                                hintText: 'Date to',
                                                initialDateTime:
                                                    initialDateTime,
                                                onDateTimeChanged: (value) {
                                                  setState(() {
                                                    dateToController.text =
                                                        dateTimeUtils
                                                            .formatDateTime(
                                                                value);
                                                  });
                                                }),
                                          ],
                                        ),
                                        onTap: () {
                                          fetchData();
                                          Get.back();
                                        },
                                      ),
                                      Widgets().verticalSpace(2.h),
                                    ],
                                  ),
                                ),
                              ),
                              Widgets().verticalSpace(2.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
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
                                            titleText: controller
                                                .totalCustomerVisited
                                                .toString(),
                                            iconColor: const Color(0xff5BCB81),
                                            context: context,
                                            subTitleText:
                                                'Total Customer Visited'),
                                      ),
                                      Widgets().horizontalSpace(2.w),
                                      Expanded(
                                        child: Widgets().myBeatColorContainer(
                                          bgColor: const Color(0xffFFF6F4),
                                          borderColor: brinkPinkColor,
                                          iconName: orderedIcon,
                                          titleText: controller.newOrderCount
                                              .toString(),
                                          context: context,
                                          iconColor: brinkPinkColor,
                                          subTitleText: 'Order Count',
                                        ),
                                      ),
                                      Widgets().horizontalSpace(2.w),
                                      Expanded(
                                        child: Widgets().myBeatColorContainer(
                                            bgColor: const Color(0xffFFFBF5),
                                            borderColor: yellowOrange,
                                            iconName: orderSalesSvg,
                                            titleText: formatStringNumber(
                                                controller.orderSales),
                                            iconColor: yellowOrange,
                                            context: context,
                                            subTitleText: 'Order Sales'),
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
                                              PieSeries<ChartData, String>(
                                                  dataSource: chartData,
                                                  pointColorMapper:
                                                      (ChartData data, _) =>
                                                          data.color,
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.y,
                                                  explode: true,
                                                  explodeIndex: 1)
                                            ])),
                                    Container(
                                      height: 1,
                                      color: const Color(0xffD0D4EC),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  dotSvg,
                                                  color:
                                                      const Color(0xff34D196),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .23,
                                                  child: Text(
                                                    'Total Customer Visited',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: waterlooColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  controller
                                                      .totalCustomerVisited
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: veryLightBoulder,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12.sp,
                                                      letterSpacing: .3),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 86,
                                            color: const Color(0xffD0D4EC),
                                          ),
                                          Widgets().horizontalSpace(2.w),
                                          SizedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  dotSvg,
                                                  color:
                                                      const Color(0xffEE466B),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .23,
                                                  child: Text(
                                                    'Order Count',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: waterlooColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  controller.newOrderCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: veryLightBoulder,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12.sp,
                                                      letterSpacing: .3),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 86,
                                            color: const Color(0xffD0D4EC),
                                          ),
                                          Widgets().horizontalSpace(2.w),
                                          SizedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  dotSvg,
                                                  color:
                                                      const Color(0xffF5AC2F),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .23,
                                                  child: Text(
                                                    'Order Sales',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: waterlooColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  formatStringNumber(
                                                      controller.orderSales),
                                                  style: TextStyle(
                                                      color: veryLightBoulder,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12.sp,
                                                      letterSpacing: .3),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                child: Text(
                                  'New Order List',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: veryLightBoulder),
                                ),
                              ),
                              Widgets().verticalSpace(2.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                child:
                                    Widgets().textFieldWidgetWithSearchDelegate(
                                        onTap: () {
                                          showSearch(
                                            context: context,
                                            delegate:
                                                AdminPrimaryNewOrderSearch(),
                                          );
                                        },
                                        controller: searchController,
                                        hintText: 'Search by name or code',
                                        iconName: search,
                                        keyBoardType: TextInputType.text,
                                        fillColor: white),
                              ),
                              Widgets().verticalSpace(1.h),
                              Widgets().customLRPadding(
                                child: ListView.builder(
                                  itemCount: controller.orders.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Widgets().neworderListCardWithStatus(
                                      customerName: controller
                                          .orders[index].customerName!,
                                      context: context,
                                      statusTitle: controller.orders[index]
                                          .status!.capitalizeFirst!,
                                      orderId: controller
                                          .orders[index].orderCartId
                                          .toString(),
                                      orderDateValue:
                                          controller.orders[index].createDate!,
                                      customerCode:
                                          '(Code : ${controller.orders[index].customerNumber!})',
                                      orderValue:
                                          '₹ ${controller.orders[index].orderValue}',
                                      orderQtyValue: controller
                                          .orders[index].quantity
                                          .toString(),
                                      statusColor:
                                          controller.orders[index].status ==
                                                  'pending'
                                              ? magicMint
                                              : salomie,
                                      onTapOrderDetail: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return AdminOrderDetail(
                                            orderId: controller
                                                .orders[index].orderCartId!,
                                            customerName: controller
                                                .orders[index].customerName!,
                                            customerCode: controller
                                                .orders[index].customerNumber!,
                                          );
                                        }));
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })),
      ));
    });
  }

  String formatStringNumber(String input) {
    // Parse the input string as a double
    double value = double.tryParse(input) ?? 0.0;

    // Round the double to two decimal places
    double roundedValue = double.parse(value.toStringAsFixed(2));

    // Convert the rounded value to a string
    String formattedValue = roundedValue.toString();

    return formattedValue;
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
