import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_calculation_controller/RetailerCalculationController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_previous_order_controller/RetailerPreviousOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../primary_order_module/controllers/order_detail_controller/OrderDetailByIdController.dart';
import '../retailer_order_again/RetailerOrderAgain.dart';

class RetailerOrderDetail extends StatefulWidget {
  final String orderCartId;
  final String retailerName;
  final String retailerCode;
  final String emailId;

  const RetailerOrderDetail({
    Key? key,
    required this.orderCartId,
    required this.retailerName,
    required this.retailerCode,
    required this.emailId,
  }) : super(key: key);

  @override
  State<RetailerOrderDetail> createState() => _RetailerOrderDetailState();
}

class _RetailerOrderDetailState extends State<RetailerOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderDetailByIdController orderDetailByIdController = Get.put(OrderDetailByIdController());
  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());
  CalculationController calculationController = Get.put(CalculationController());

  RetailerPreviousOrderController retailerPreviousOrderController = Get.put(RetailerPreviousOrderController());
  RetailerCalculationController retailerCalculationController = Get.put(RetailerCalculationController());
  List<TextEditingController> qtyTextControllers = [];

  @override
  void initState() {
    super.initState();
    orderDetailsApiCall();
    // qtyTextControllers = List.generate(
    //   retailerPreviousOrderController.orderDetailsProductList.length,
    //   (index) => TextEditingController(),
    // );
  }

  orderDetailsApiCall() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await retailerPreviousOrderController.viewPreviousOrderFn(retailerCode: widget.retailerCode, orderID: widget.orderCartId).then((value) {
      if (value == true) {
        printMe("Value is order again data: $value");
        retailerPreviousOrderController.calculateTotalUnitPrice(retailerPreviousOrderController.orderDetailsProductList);

        updateQtyTextControllers();

        setState(() {});
      }
    });
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      retailerPreviousOrderController.orderDetailsProductList.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerPreviousOrderController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
                  Container(
                    decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: magnolia),
                    child: Widgets().customLRadding40(
                        child: Column(
                      children: [
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().richTextInRow(titleName: 'Order Number ', titleValue: ' ${widget.orderCartId}', fontColor: curiousBlue),
                            Widgets().statusContainer(
                              statusColor: controller.status.toString().toLowerCase() == "pending" ? magicMint : salomie,
                              statusTitle: controller.status.toString().toLowerCase() == "" ? "Pending" : controller.status ?? '',
                            )
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(context: context, title: 'Order Date', subTitle: '${controller.orderDate}'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(context: context, title: 'Order Qty', subTitle: '${controller.orderQty}'),
                              ],
                            ),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    )),
                  ),
                  Widgets().verticalSpace(1.h),
                  GetBuilder<RetailerPreviousOrderController>(builder: (controller) {
                    return Widgets().customLRPadding(
                        child: controller.orderDetailsProductList.isEmpty
                            ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                            : ListView.builder(
                                itemCount: controller.orderDetailsProductList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  var items = controller.orderDetailsProductList[index];
                                  updateQtyTextControllers();
                                  TextEditingController qtyTextController = qtyTextControllers[index];
                                  qtyTextController.text = items.itemCount == 1 ? "1" : items.itemCount.toString();
                                  return NewWidgets().previousOrderListCardNew(
                                    context: context,
                                    hideEditButton: true,
                                    //As discuss Vali mam and Shanwal sir,
                                    //Remove delete and edit button from Previous order, order detail 24-01-2024
                                    editIconOnTap: () {
                                      // Widgets().editOrderSecondaryBottomSheet(
                                      //   context: context,
                                      //   productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                      //     return Widgets().editPreviousOrderBottomSheet(
                                      //         deleteOnTap: () {
                                      //           Get.back();
                                      //           retailerPreviousOrderController.deletePreviousProductItem(items);
                                      //           myState(() {});
                                      //         },
                                      //         productDetailText: items.productName!,
                                      //         context: context,
                                      //         amount: '₹  ${items.rlp}',
                                      //         orderIdValue: widget.orderCartId,
                                      //         qtyValue: items.itemCount == 1 ? items.quantity.toString() : "${items.itemCount}",
                                      //         onTapDecrease: () {
                                      //           printMe("On tapped increase : ");
                                      //           int currentQty = items.itemCount;
                                      //           if (currentQty > 1) {
                                      //             currentQty--;
                                      //           }
                                      //           retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                      //           printMe("Current qty : $currentQty");
                                      //           previousOrderController.isInitialTotalUnitPrice = true;
                                      //           qtyTextController.text = currentQty.toString();
                                      //           myState(() {});
                                      //         },
                                      //         onTapInCrease: () {
                                      //           myState(() {
                                      //             printMe("On tapped increase : ");
                                      //             //int currentQty = items.itemCount;
                                      //             int currentQty = int.parse(items.quantity.toString());
                                      //             currentQty++;
                                      //             //retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                      //             previousOrderController.isInitialTotalUnitPrice = true;
                                      //             //qtyTextController.text = currentQty.toString();
                                      //             if (currentQty < 100000) {
                                      //               retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                      //               qtyTextController.text = currentQty.toString();
                                      //             } else {
                                      //               Widgets().showToast("Quantity can not be greater than 99999");
                                      //             }
                                      //           });
                                      //         },
                                      //         qtyTextController: qtyTextController,
                                      //         onChanged: (valueItemCount) {
                                      //           qtyTextController.text = valueItemCount;
                                      //           int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                      //           //retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                      //           if (currentQty < 100000) {
                                      //             if (currentQty != items.itemCount) {
                                      //               retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                      //               qtyTextController.text = currentQty.toString();
                                      //             }
                                      //           } else {
                                      //             Widgets().showToast("Quantity can not be greater than 99999");
                                      //           }
                                      //           myState(() {});
                                      //         },
                                      //         qtyText: items.quantity ?? '',
                                      //         //totalCalculatedValue: '₹ ${items.itemCount > 1 ? items.totalPrice?.toStringAsFixed(2) : items.rlp}'
                                      //         totalCalculatedValue:
                                      //             '₹ ${items.itemCount > 1 ? items.totalPrice?.toStringAsFixed(2) : items.itemCount == 0 ? "0.00" : items.rlp}',
                                      //         sqValue: "");
                                      //   }),
                                      //   saveButton: () {
                                      //     Get.back();
                                      //   },
                                      // );
                                    },
                                    deleteIconOnTap: () {
                                      //retailerPreviousOrderController.deletePreviousProductItem(items);
                                    },
                                    productDetailText: "${items.productName} - " ?? '',
                                    qtyValue: items.itemCount == 1 ? items.quantity.toString() : "${items.itemCount}",
                                    //totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.rlp}',
                                    totalPriceValue: " ₹ ${items.rlp}",
                                    itemCode: "${items.skuCode}",
                                  );
                                },
                              ));
                  }),
                  Widgets().verticalSpace(2.h),
                  GetBuilder<RetailerCalculationController>(builder: (controller) {
                    return Widgets().totalOrderValueTile(context: context, iconName: cartIcon, titleValue: '₹ ${controller.totalPreviousOrderPrice}');
                  }),
                  Widgets().verticalSpace(3.h),
                  Widgets().customLRadding40(
                    child: Widgets().dynamicButton(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return RetailerOrderAgain(
                              orderCartId: widget.orderCartId,
                              retailerCode: widget.retailerCode,
                              retailerName: widget.retailerName,
                              emailId: widget.emailId,
                            );
                          }));
                        },
                        height: 6.h,
                        width: 41.w,
                        buttonBGColor: alizarinCrimson,
                        titleText: 'Order Again',
                        titleColor: white),
                  ),
                  Widgets().verticalSpace(2.h),
                ],
              ),
            )),
      );
    });
  }
}
