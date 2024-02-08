import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../order_again/OrderAgain.dart';
import '../order_detail/OrderDetail.dart';

//ignore: must_be_immutable
class PreviousOrder extends StatefulWidget {
  final String navigationTag;
  String customerCode;
  String customerName;
  PreviousOrder({Key? key, required this.customerCode, required this.customerName, required this.navigationTag}) : super(key: key);

  @override
  State<PreviousOrder> createState() => _PreviousOrderState();
}

class _PreviousOrderState extends State<PreviousOrder> {
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  PreviousOrderController _previousOrderController = Get.put(PreviousOrderController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  DateTime initialDateTime = DateTime.now();
  bool isFromDate = false;
  bool isToDate = false;
  bool isSchedulerBindingOk = false;
  bool initiallyExpanded = false;

  @override
  void initState() {
    _previousOrderController.currentPage = 1;
    _previousOrderController.lastPage = 0;

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // Load more data when reaching the end
        _previousOrderController.loadMoreData(widget.customerCode);
      }
    });
    previousOrdersByFilterApiCall();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  previousOrdersByFilterApiCall() async {
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   Widgets().loadingDataDialog(loadingText: "Loading data...");
    // });
    printMe("Customer code : ${widget.customerCode}");
    await _previousOrderController.previousOrdersByFilter(
      customerCode: widget.customerCode,
      dateFromFilter: _previousOrderController.dateFromController.text.toString(),
      dateToFilter: _previousOrderController.dateToController.text.toString(),
      orderNoFilter: _previousOrderController.orderIdController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    printMe("Screen tag : ${widget.navigationTag}");

    return GetBuilder<PreviousOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          globalController.primaryOrderNavigation(context: context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
              body: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                            child: Widgets().customLRPadding(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().verticalSpace(2.h),
                                Widgets().textWidgetWithW700(titleText: 'Select Date Range', fontSize: 11.sp),
                                Widgets().verticalSpace(2.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.w, right: 1.w),
                                  child: Widgets().selectDateRangeExpantionTile(
                                    context: context,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        initiallyExpanded = value ? true : false;
                                      });
                                    },
                                    initiallyExpanded: initiallyExpanded,
                                    datePickerWidget: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        NewWidgets().datePicker(
                                          context: context,
                                          onTap: () {
                                            Get.back();
                                          },
                                          controller: controller.dateFromController,
                                          hintText: 'Date From',
                                          width: 40.w,
                                          onDateTimeChanged: (value) {
                                            initialDateTime = value;
                                            controller.dateFromController.text = dateTimeUtils.formatDateTimePreviousOrder(initialDateTime);
                                            isFromDate = true;
                                          },
                                          initialDateTime: initialDateTime,
                                        ),
                                        NewWidgets().datePicker(
                                          context: context,
                                          onTap: () {
                                            Get.back();
                                          },
                                          controller: controller.dateToController,
                                          hintText: 'Date To',
                                          width: 40.w,
                                          onDateTimeChanged: (value) {
                                            initialDateTime = value;
                                            controller.dateToController.text = dateTimeUtils.formatDateTimePreviousOrder(initialDateTime);
                                            isToDate = true;
                                          },
                                          initialDateTime: initialDateTime,
                                        ),
                                      ],
                                    ),
                                    orderIdController: controller.orderIdController,
                                    onTap: () {
                                      // showSearch(
                                      //   context: context,
                                      //   delegate: SearchPreviousOrder(
                                      //       customerName: widget.customerName, customerCode: widget.customerCode, navigationTag: widget.navigationTag),
                                      // );
                                    },
                                    onTapApply: () async {
                                      Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                      setState(() {
                                        initiallyExpanded = false;
                                      });
                                      await _previousOrderController
                                          .previousOrdersByFilter(
                                        customerCode: widget.customerCode,
                                        dateFromFilter: controller.dateFromController.text,
                                        dateToFilter: controller.dateToController.text,
                                        orderNoFilter: controller.orderIdController.text,
                                      )
                                          .then((value) {
                                        initiallyExpanded = false;
                                      });
                                    },
                                  ),
                                ),
                                Widgets().verticalSpace(2.h),
                              ],
                            ))),
                        Widgets().verticalSpace(2.h),
                        (controller.isDataAvailable)
                            ? (controller.previousOrderItemsList.isNotEmpty)
                                ? Widgets().customLRPadding(
                                    child: ListView.builder(
                                    itemCount: controller.previousOrderItemsList.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var items = controller.previousOrderItemsList[index];
                                      return Widgets().orderDetailsCardWithStatus(
                                          buttonName: widget.navigationTag == "PreviousOrder" ? "Order Again" : "Return Order",
                                          context: context,
                                          orderId: int.tryParse(items.orderNo ?? '0') ?? 0,
                                          statusTitle: items.sTATUSFLAG == "S" ? "Completed" : "Pending",
                                          orderDateValue: items.orderDate!,
                                          //DateTimeUtils().formatDatePreviousOder(items.orderDate!),
                                          orderQtyValue: items.OrderQty!,
                                          orderValue: items.orderValue!,
                                          onTapOrderAgain: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                                              return OrderAgain(
                                                navigationTag: widget.navigationTag,
                                                orderCartId: items.orderId.toString(),
                                                customerName: widget.customerName,
                                                customerCode: widget.customerCode,
                                                bu: items.BU!,
                                              );
                                            }));
                                          },
                                          onTapOrderDetail: () {
                                            printMe('Order detail button clicked');
                                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                                              return OrderDetail(
                                                navigationTag: widget.navigationTag,
                                                orderCartId: items.orderId.toString(),
                                                customerCode: widget.customerCode,
                                                customerName: widget.customerName,
                                                orderNo: items.orderNo.toString(),
                                                bu: items.BU!,
                                              );
                                            }));
                                          },
                                          statusColor: items.sTATUSFLAG == "S" ? magicMint : salomie);
                                    },
                                  ))
                                : Center(
                                    child: Widgets().textWidgetWithW500(titleText: "No data found. Please try with different date", fontSize: 12.sp, textColor: codGray),
                                  )
                            : Container()
                      ],
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }
}
