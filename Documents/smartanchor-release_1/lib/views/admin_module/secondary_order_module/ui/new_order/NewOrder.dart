import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/admin_module/attandance_module/controllers/AdminAttendanceController.dart';
import 'package:smartanchor/views/admin_module/secondary_order_module/ui/new_order/NewOrderDetail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../global/common_controllers/GlobalController.dart';
import '../../controllers/RetailerNewOrderController.dart';

class AdminSecondaryNewOrder extends StatefulWidget {
  const AdminSecondaryNewOrder({Key? key}) : super(key: key);

  @override
  State<AdminSecondaryNewOrder> createState() => _AdminSecondaryNewOrderState();
}

class _AdminSecondaryNewOrderState extends State<AdminSecondaryNewOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  RetailerNewOrderController retailerNewOrderController =
      Get.put(RetailerNewOrderController());

  List<ChartData> chartData = [];
  late TooltipBehavior _tooltip;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltip = TooltipBehavior(
        enable: true,
        color: Colors.white,
        textStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));

    fetchData();
  }

  fetchData() async {
    await retailerNewOrderController.getRetailerNewOrders(
      fromDate: "",
      toDate: "",
      pageNumber: 1,
      pageSize: 2,
      role: globalController.role,
      screenName: globalController.customerScreenName,
      searchString: '',
      orderId: '',
    );
    setState(() {
      chartData = [
        ChartData(
            'Total Retailers Visited ',
            retailerNewOrderController.totalVisitedRetailer.toDouble(),
            malachite),
        ChartData('Order Count',
            retailerNewOrderController.orderCount.toDouble(), brinkPinkColor),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNewOrderController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
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
                                              titleText: "New Orders"),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                        bgColor: hintOfGreen,
                                                        borderColor: malachite,
                                                        iconName: customerSvg,
                                                        titleText: controller
                                                            .totalVisitedRetailer
                                                            .toString(),
                                                        iconColor: const Color(
                                                            0xff5BCB81),
                                                        context: context,
                                                        subTitleText:
                                                            'Total Retailers Visited '),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                  bgColor:
                                                      const Color(0xffFFF6F4),
                                                  borderColor: brinkPinkColor,
                                                  iconName: cartIconSvg,
                                                  titleText: controller
                                                      .orderCount
                                                      .toString(),
                                                  context: context,
                                                  iconColor: brinkPinkColor,
                                                  subTitleText: 'Order Count',
                                                ),
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
                                                          (ChartData data, _) =>
                                                              data.color,
                                                      xValueMapper:
                                                          (ChartData data, _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.y,
                                                    )
                                                  ],
                                                  tooltipBehavior: _tooltip,
                                                )),
                                            Container(
                                              height: 1,
                                              color: const Color(0xffD0D4EC),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 70,
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
                                                            child: Text(
                                                              'Total Retailers Visited ',
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
                                                                .totalVisitedRetailer
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
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 86,
                                                    color:
                                                        const Color(0xffD0D4EC),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 70,
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
                                                              'Order Count',
                                                              maxLines: 2,
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
                                                                .orderCount
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
                                          'New Order List',
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
                                        child: Widgets().textFieldWidget(
                                            controller: searchController,
                                            hintText: 'Search',
                                            iconName: search,
                                            onTap: () async {
                                              await controller
                                                  .getRetailerNewOrders(
                                                fromDate: "",
                                                toDate: "",
                                                pageNumber: 1,
                                                pageSize: 4,
                                                role: globalController.role,
                                                screenName: globalController
                                                    .customerScreenName,
                                                searchString:
                                                    searchController.text,
                                                orderId: '',
                                              );
                                            },
                                            keyBoardType: TextInputType.text,
                                            fillColor: white),
                                      ),
                                      Widgets().verticalSpace(1.h),
                                      Widgets().customLRPadding(
                                        child:
                                            controller.newOrderLists.isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: controller
                                                        .newOrderLists.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Widgets()
                                                          .neworderListCardWithStatus(
                                                              context: context,
                                                              statusTitle: controller
                                                                          .newOrderLists[
                                                                              index]
                                                                          .orderStatus ==
                                                                      ''
                                                                  ? 'Pending'
                                                                  : controller
                                                                      .newOrderLists[
                                                                          index]
                                                                      .orderStatus!,
                                                              orderId: controller
                                                                  .newOrderLists[
                                                                      index]
                                                                  .orderId!,
                                                              orderDateValue: DateTimeUtils()
                                                                  .convertDateFormat(controller
                                                                      .newOrderLists[
                                                                          index]
                                                                      .orderDate!),
                                                              customerCode:
                                                                  '(Code : ${controller.newOrderLists[index].code!})',
                                                              orderValue:
                                                                  '₹ ${controller.newOrderLists[index].orderValue!}',
                                                              orderQtyValue:
                                                                  controller
                                                                      .newOrderLists[
                                                                          index]
                                                                      .orderQuantity
                                                                      .toString(),
                                                              statusColor:
                                                                  controller.newOrderLists[index].orderStatus != ''
                                                                      ? magicMint
                                                                      : salomie,
                                                              onTapOrderDetail:
                                                                  () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) {
                                                                  return AdminSecondaryNewOrderDetail(
                                                                    Status: controller.newOrderLists[index].orderStatus ==
                                                                            ''
                                                                        ? 'Pending'
                                                                        : controller
                                                                            .newOrderLists[index]
                                                                            .orderStatus!,
                                                                    orderId: controller
                                                                        .newOrderLists[
                                                                            index]
                                                                        .orderId!,
                                                                    orderDate: controller
                                                                        .newOrderLists[
                                                                            index]
                                                                        .orderDate!,
                                                                    orderQty: controller
                                                                        .newOrderLists[
                                                                            index]
                                                                        .orderQuantity
                                                                        .toString(),
                                                                    code: controller
                                                                        .newOrderLists[
                                                                            index]
                                                                        .code!,
                                                                  );
                                                                }));
                                                              },
                                                              customerName: controller
                                                                  .newOrderLists[index]
                                                                  .retailerName
                                                                  .toString());
                                                    },
                                                  )
                                                : const Center(
                                                    child:
                                                        Text('No Data Found'),
                                                  ),
                                      ),

                                      Widgets().verticalSpace(2.h),
                                    ])));
                      }))));
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
