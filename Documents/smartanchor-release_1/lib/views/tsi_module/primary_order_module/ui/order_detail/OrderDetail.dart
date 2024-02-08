import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/order_detail_controller/OrderDetailByIdController.dart';
import '../order_again/OrderAgain.dart';

class OrderDetail extends StatefulWidget {
  final String navigationTag;
  final String orderCartId;
  final String customerName;
  final String customerCode;
  final String orderNo;
  final String bu;

  const OrderDetail(
      {Key? key, required this.orderCartId, required this.customerName, required this.customerCode, required this.navigationTag, required this.orderNo, required this.bu})
      : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderDetailByIdController orderDetailByIdController = Get.put(OrderDetailByIdController());
  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());
  CalculationController calculationController = Get.put(CalculationController());
  List<TextEditingController> qtyTextControllers = [];

  bool isDataLoad = false;

  @override
  void initState() {
    super.initState();
    orderDetailsApiCall();
  }

  orderDetailsApiCall() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await orderDetailByIdController.orderDetailsById(orderCartId: widget.orderCartId, customerCode: widget.customerCode, bu: widget.bu).then((value) {
      if (value == true) {
        printMe("Value is order again data: $value");
        previousOrderController.calculateTotalUnitPrice(orderDetailByIdController.productDetailsbodies ?? []);

        updateQtyTextControllers();

        setState(() {
          isDataLoad = true;
        });
      }
    });
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      orderDetailByIdController.productDetailsbodies!.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    printMe("Screen tag : ${widget.navigationTag}");
    return GetBuilder<OrderDetailByIdController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: (!isDataLoad)
                ? Container()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                        Container(
                          decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: magnolia),
                          child: Widgets().customLRadding40(
                              child: Column(
                            children: [
                              Widgets().verticalSpace(2.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Widgets().richTextInRow(titleName: 'Order No. ', titleValue: ' ${widget.orderNo}', fontColor: curiousBlue),
                                  Widgets().statusContainer(
                                      statusColor: controller.statusFlag == "S" ? magicMint : salomie,
                                      statusTitle: controller.statusFlag == "S" ? 'Completed' : 'Pending')
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
                        GetBuilder<PreviousOrderController>(builder: (controller) {
                          return Widgets().customLRPadding(
                              child: ListView.builder(
                            itemCount: orderDetailByIdController.productDetailsbodies?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var items = orderDetailByIdController.productDetailsbodies?[index];
                              updateQtyTextControllers();
                              TextEditingController qtyTextController = qtyTextControllers[index];
                              qtyTextController.text = (items?.punchedQty == "1" ? "1" : items?.punchedQty.toString())!;

                              return NewWidgets().previousOrderListCardNew(
                                context: context,
                                hideEditButton: true,
                                editIconOnTap: () {
                                  // Widgets().editOrderBottomSheet(
                                  //   context: context,
                                  //   productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                  //     return Widgets().editPreviousOrderBottomSheet(
                                  //         deleteOnTap: () {
                                  //           Get.back();
                                  //           previousOrderController.deletePreviousProductItem(items!);
                                  //         },
                                  //         productDetailText: items!.productName!,
                                  //         context: context,
                                  //         amount: '₹  ${items.unitPriceList}',
                                  //         orderIdValue: orderDetailByIdController.orderId!,
                                  //         // qtyValue: items.itemCount == 1 ? items.productQty.toString() : "${items.itemCount}",
                                  //         qtyValue: items.punchedQty ?? '',
                                  //         onTapDecrease: () {
                                  //           printMe("On tapped increase : ");
                                  //           //int currentQty = items.itemCount;
                                  //           int currentQty = int.parse(items.punchedQty.toString());
                                  //           if (currentQty > 1) {
                                  //             currentQty--;
                                  //           }
                                  //           previousOrderController.updatePreviousQtyValue(currentQty, items);
                                  //           qtyTextController.text = currentQty.toString();
                                  //           myState(() {});
                                  //         },
                                  //         onTapInCrease: () {
                                  //           printMe("On tapped increase : ");
                                  //           //int currentQty = items.itemCount;
                                  //           int currentQty = int.parse(items.punchedQty.toString());
                                  //           currentQty++;

                                  //           //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                  //           //qtyTextController.text = currentQty.toString();
                                  //           if (currentQty < 100000) {
                                  //             previousOrderController.updatePreviousQtyValue(currentQty, items);
                                  //             qtyTextController.text = currentQty.toString();
                                  //           } else {
                                  //             Widgets().showToast("Quantity can not be greater than 99999");
                                  //           }
                                  //           myState(() {});
                                  //         },
                                  //         qtyTextController: qtyTextController,
                                  //         onChanged: (valueItemCount) {
                                  //           qtyTextController.text = valueItemCount;
                                  //           // int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                  //           int currentQty = int.parse(items.punchedQty.toString());

                                  //           //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                  //           if (currentQty < 100000) {
                                  //             if (currentQty != items.itemCount) {
                                  //               previousOrderController.updatePreviousQtyValue(currentQty, items);
                                  //               qtyTextController.text = currentQty.toString();
                                  //             }
                                  //           } else {
                                  //             Widgets().showToast("Quantity can not be greater than 99999");
                                  //           }
                                  //           myState(() {});
                                  //         },
                                  //         //qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                  //         qtyText: items.productQty ?? '',
                                  //         //totalCalculatedValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.unitPriceList}',
                                  //         totalCalculatedValue:
                                  //             '₹ ${((double.tryParse(items.punchedQty ?? '0') ?? 0) >= 1) ? ((double.tryParse(items.unitPriceList ?? '0') ?? 0) * (double.tryParse(items.punchedQty ?? '0') ?? 0) * (double.tryParse(items.sQ ?? '0') ?? 0)) : "0.00"}',
                                  //         sqValue: items.sQ!);
                                  //   }),
                                  //   saveButton: () {
                                  //     Get.back();
                                  //   },
                                  // );
                                },
                                //As discuss Vali mam and Shanwal sir,
                                //Remove delete and edit button from Previous order, order detail 24-01-2024
                                deleteIconOnTap: () {
                                  //previousOrderController.deletePreviousProductItem(items!);
                                },
                                productDetailText: items?.productName ?? '',
                                //qtyValue: items?.itemCount == 1 ? items!.productQty.toString() : "${items?.itemCount}",
                                qtyValue: items!.punchedQty.toString(),
                                //totalPriceValue: '₹ ${items!.itemCount > 1 ? items.totalPrice : items.unitPriceList}',
                                totalPriceValue:
                                    '₹ ${((double.tryParse(items.unitPriceList ?? '') ?? 0) * (double.tryParse(items.punchedQty ?? '') ?? 0) * (double.tryParse(items.sQ ?? '') ?? 0)).toStringAsFixed(2)}',
                                itemCode: "${items.itemCode}",
                              );
                            },
                          ));
                        }),
                        Widgets().verticalSpace(2.h),
                        GetBuilder<PreviousOrderController>(builder: (controller) {
                          return Widgets().totalOrderValueTile(context: context, iconName: cartIcon, titleValue: '₹ ${calculationController.totalPreviousOrderPrice}');
                        }),
                        Widgets().verticalSpace(3.h),
                        Widgets().customLRadding40(
                          child: Widgets().dynamicButton(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                  return OrderAgain(
                                    navigationTag: widget.navigationTag,
                                    orderCartId: widget.orderCartId,
                                    customerCode: widget.customerCode,
                                    customerName: widget.customerName,
                                    bu: widget.bu,
                                  );
                                }));
                              },
                              height: 6.h,
                              width: 41.w,
                              buttonBGColor: alizarinCrimson,
                              titleText: widget.navigationTag == "ReturnOrder" ? "Return Order" : "Order Again",
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
