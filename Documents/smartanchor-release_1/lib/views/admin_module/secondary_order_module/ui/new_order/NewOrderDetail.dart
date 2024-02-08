import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/RetailerNewOrderController.dart';

class AdminSecondaryNewOrderDetail extends StatefulWidget {
  final String Status;
  final String orderId;
  final String orderDate;
  final String orderQty;
  final String code;

  const AdminSecondaryNewOrderDetail(
      {Key? key,
      required this.Status,
      required this.orderId,
      required this.orderDate,
      required this.orderQty,
      required this.code})
      : super(key: key);

  @override
  State<AdminSecondaryNewOrderDetail> createState() =>
      _AdminSecondaryNewOrderDetailState();
}

class _AdminSecondaryNewOrderDetailState
    extends State<AdminSecondaryNewOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  RetailerNewOrderController retailerNewOrderController =
      Get.put(RetailerNewOrderController());

  int totalValue = 0;

  @override
  void initState() {
    super.initState();

    fetchDetail();
  }

  fetchDetail() async {
    await retailerNewOrderController.getRetailerNewOrderDetail(
        orderId: widget.orderId);

    retailerNewOrderController.totalValue = 0;
    await retailerNewOrderController.calculateTotalValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNewOrderController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().newOrderUserNameDetailsTileWithVerify(
                      context: context,
                      titleName: controller.shopName,
                      titleValue: "(Customer Code : ${widget.code})"),
                  Container(
                    decoration: Widgets()
                        .commonDecoration(borderRadius: 0, bgColor: magnolia),
                    child: Widgets().customLRadding40(
                        child: Column(
                      children: [
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().richTextInRow(
                                titleName: 'Order ID ',
                                titleValue: widget.orderId,
                                fontColor: curiousBlue),
                            Widgets().statusContainer(
                                statusColor: widget.Status != 'Pending'
                                    ? magicMint
                                    : salomie,
                                statusTitle: widget.Status)
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(
                                    context: context,
                                    title: 'Order Date',
                                    subTitle: DateTimeUtils()
                                        .convertDateFormat(widget.orderDate)),
                              ],
                            ),
                            Widgets().horizontalSpace(2.3.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(
                                    context: context,
                                    title: 'Order Qty',
                                    subTitle:
                                        (int.tryParse(widget.orderQty) ?? 0)
                                            .toString()),
                              ],
                            ),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    )),
                  ),
                  Widgets().verticalSpace(1.h),
                  Widgets().customLRPadding(
                      child: ListView.builder(
                    itemCount: controller.newOrderDetailsLists.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      //   totalValue=(controller.newOrderDetailsLists.length)*int.parse((controller.newOrderDetailsLists[index].rlp!));

                      return Widgets().newOrderDetailListCard(
                        context: context,
                        productDetailText:
                            controller.newOrderDetailsLists[index].productName!,
                        qtyValue: (int.tryParse(controller
                                    .newOrderDetailsLists[index]
                                    .totalQuantity!) ??
                                0)
                            .toString(),
                        totalPriceValue:
                            '₹ ${(double.tryParse(controller.newOrderDetailsLists[index].rlp!) ?? 0).toStringAsFixed(2)}',
                      );
                    },
                  )),
                  Widgets().verticalSpace(2.h),
                  Widgets().totalOrderValueTile(
                      context: context,
                      iconName: cartSvgIcon,
                      titleValue:
                          '₹ ${controller.totalValue.toDouble().toStringAsFixed(2)}'),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Widgets().retailerDetailsExpantionCard(
                        context: context,
                        address: controller.address,
                        beat: controller.beat,
                        city: controller.city,
                        state: controller.state,
                        creditLimit: controller.creditLimit,
                        outstanding: controller.outstanding,
                        overdue: controller.overdue,
                        callingOnTap: () {
                          //TODO add permission in info. plist for calling
                          Utils().makePhoneCall("+91${controller.mobileNo}");
                        },
                        locationOnTap: () {
                          launchMap(controller.address);
                        },
                        phoneNumber: controller.mobileNo,
                        verify: ''),
                  )
                ],
              ),
            )),
      );
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
