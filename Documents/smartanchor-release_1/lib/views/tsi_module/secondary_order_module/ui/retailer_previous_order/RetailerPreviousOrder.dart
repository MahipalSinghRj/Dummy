import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_previous_order_controller/RetailerPreviousOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../retailer_order_again/RetailerOrderAgain.dart';
import '../retailer_order_detail/RetailerOrderDetail.dart';

//ignore: must_be_immutable
class RetailerPreviousOrder extends StatefulWidget {
  String retailerCode;
  String retailerName;
  String emailAddress;

  RetailerPreviousOrder({
    Key? key,
    required this.retailerCode,
    required this.retailerName,
    required this.emailAddress,
  }) : super(key: key);

  @override
  State<RetailerPreviousOrder> createState() => _RetailerPreviousOrderState();
}

class _RetailerPreviousOrderState extends State<RetailerPreviousOrder> {
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  DateTime initialDateTime = DateTime.now();
  bool isFromDate = false;
  bool isToDate = false;
  bool initiallyExpanded = false;

  RetailerPreviousOrderController retailerPreviousOrderController = Get.put(RetailerPreviousOrderController());

  @override
  void initState() {
    previousOrdersByFilterApiCall();
    super.initState();
  }

  previousOrdersByFilterApiCall() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    printMe("Customer code : ${widget.retailerCode}");
    await retailerPreviousOrderController.previousOrderDetailsFn(retailerCode: widget.retailerCode, startDate: "", endDate: "", orderID: "").then((value) {
      if (value == true) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerPreviousOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          //globalController.splashNavigation();
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondaryOrder()));

          //globalController.secondaryNavigation();
          globalController.secondaryNavigation(context: context);
          //Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
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
                                            controller: dateFromController,
                                            width: 40.w,
                                            hintText: 'Date from',
                                            initialDateTime: initialDateTime,
                                            onDateTimeChanged: (value) {
                                              dateFromController.text = dateTimeUtils.formatDateTimePreviousOrder(value);
                                              isFromDate = true;
                                            }),
                                        NewWidgets().datePicker(
                                            context: context,
                                            onTap: () {
                                              Get.back();
                                            },
                                            controller: dateToController,
                                            width: 40.w,
                                            hintText: 'Date to',
                                            initialDateTime: initialDateTime,
                                            onDateTimeChanged: (value) {
                                              dateToController.text = dateTimeUtils.formatDateTimePreviousOrder(value);
                                              isToDate = true;
                                            }),
                                      ],
                                    ),
                                    orderIdController: orderIdController,
                                    onTap: () {
                                      // showSearch(
                                      //   context: context,
                                      //   delegate: SearchPreviousOrder(
                                      //       customerName: widget.customerName, customerCode: widget.customerCode, navigationTag: widget.navigationTag),
                                      // );
                                    },
                                    onTapApply: () async {
                                      if (isToDate && isFromDate) {
                                        Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                        setState(() {
                                          initiallyExpanded = false;
                                        });
                                        await retailerPreviousOrderController
                                            .previousOrderDetailsFn(
                                                retailerCode: widget.retailerCode,
                                                startDate: dateFromController.text,
                                                endDate: dateToController.text,
                                                orderID: orderIdController.text)
                                            .then((value) {
                                          if (value == true) {
                                            initiallyExpanded = false;
                                          }
                                        });
                                      } else {
                                        Widgets().showToast("Please select date range");
                                      }
                                    },
                                  ),
                                ),
                                Widgets().verticalSpace(2.h),
                              ],
                            ))),
                        Widgets().verticalSpace(2.h),
                        (controller.previousOrderDetailList.isNotEmpty)
                            ? Widgets().customLRPadding(
                                child: ListView.builder(
                                itemCount: controller.previousOrderDetailList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  var items = controller.previousOrderDetailList[index];
                                  return Widgets().retailerPreviousOrderCard(
                                      buttonName: "Order Again",
                                      context: context,
                                      orderId: items.orderId ?? '',
                                      statusTitle: items.status ?? '',
                                      orderDateValue: DateTimeUtils().formatDatePreviousOder(items.orderDate!),
                                      orderQtyValue: items.quantity!,
                                      orderValue: items.orderValue!,
                                      onTapOrderAgain: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                                          return RetailerOrderAgain(
                                              orderCartId: items.orderId.toString(),
                                              retailerCode: widget.retailerCode,
                                              retailerName: widget.retailerName,
                                              emailId: widget.emailAddress);
                                        }));
                                      },
                                      onTapOrderDetail: () {
                                        printMe('Order detail button clicked');
                                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                                          return RetailerOrderDetail(
                                              orderCartId: items.orderId.toString(),
                                              retailerCode: widget.retailerCode,
                                              retailerName: widget.retailerName,
                                              emailId: widget.emailAddress);
                                        }));
                                      },
                                      statusColor: items.status == "pending" ? salomie : magicMint);
                                },
                              ))
                            : Center(
                                child: Widgets().textWidgetWithW500(titleText: "No data found. Please try with different date", fontSize: 12.sp, textColor: codGray),
                              )
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
