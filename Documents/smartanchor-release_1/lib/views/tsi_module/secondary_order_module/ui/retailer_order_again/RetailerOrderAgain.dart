import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/order_detail_controller/OrderDetailByIdController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_previous_order_controller/RetailerPreviousOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/retailer_calculation_controller/RetailerCalculationController.dart';
import '../../controllers/secondary_order_controller/SecondaryOrderController.dart';
import '../../models/responseModels/retailer_new-order_model/ProductDetailListResponse.dart';
import '../retailer_new_order/RetailerNewOrder.dart';
import 'RetailerOrderAgainCheckOut.dart';

class RetailerOrderAgain extends StatefulWidget {
  final String orderCartId;
  final String retailerCode;
  final String retailerName;
  final String emailId;

  const RetailerOrderAgain({
    Key? key,
    required this.orderCartId,
    required this.retailerCode,
    required this.retailerName,
    required this.emailId,
  }) : super(key: key);

  @override
  State<RetailerOrderAgain> createState() => _RetailerOrderAgainState();
}

class _RetailerOrderAgainState extends State<RetailerOrderAgain> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderDetailByIdController orderDetailByIdController = Get.put(OrderDetailByIdController());
  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());
  CalculationController calculationController = Get.put(CalculationController());
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  SecondaryController secondaryController = Get.put(SecondaryController());
  RetailerPreviousOrderController retailerPreviousOrderController = Get.put(RetailerPreviousOrderController());
  RetailerCalculationController retailerCalculationController = Get.put(RetailerCalculationController());
  List<TextEditingController> qtyTextControllers = [];

  @override
  void initState() {
    orderDetailsApiCall();
    super.initState();
  }

  orderDetailsApiCall() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await retailerPreviousOrderController
        .viewPreviousOrderFn(
      retailerCode: widget.retailerCode,
      orderID: widget.orderCartId,
    )
        .then((value) async {
      if (value == true) {
        printMe("Value is order again data: $value");
        await retailerCalculationController.setSelectedPreviousListItems(retailerPreviousOrderController.orderDetailsProductList);
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
                Widgets().verticalSpace(2.h),
                Column(
                  children: [
                    GetBuilder<RetailerPreviousOrderController>(builder: (controller) {
                      return Widgets().customLRPadding(
                          child: retailerPreviousOrderController.orderDetailsProductList.isEmpty
                              ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                              : ListView.builder(
                                  itemCount: retailerPreviousOrderController.orderDetailsProductList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    var items = controller.orderDetailsProductList[index];
                                    updateQtyTextControllers();
                                    TextEditingController qtyTextController = qtyTextControllers[index];
                                    //qtyTextController.text = items.itemCount.toString();
                                    qtyTextController.text = items.itemCount == 1 ? items.quantity.toString() : "${items.itemCount}";
                                    return NewWidgets().previousOrderListCardNew(
                                      context: context,
                                      editIconOnTap: () {
                                        Widgets().editOrderSecondaryBottomSheet(
                                          context: context,
                                          productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                            return Widgets().editPreviousOrderBottomSheet(
                                                deleteOnTap: () {
                                                  Get.back();
                                                  retailerPreviousOrderController.deletePreviousProductItem(items);
                                                  myState(() {});
                                                },
                                                productDetailText: items.productName!,
                                                context: context,
                                                amount: '₹  ${items.rlp}',
                                                orderIdValue: widget.orderCartId,
                                                //qtyValue: items.itemCount == 1 ? items.quantity.toString() : "${items.itemCount}",
                                                qtyValue: items.quantity ?? '',
                                                onTapDecrease: () {
                                                  printMe("On tapped increase : ");
                                                  //int currentQty = items.itemCount;
                                                  int currentQty = int.tryParse(items.quantity ?? "0") ?? 0;
                                                  // int currentQty = double.parse(items.quantity.toString()).toInt();
                                                  if (currentQty > 1) {
                                                    currentQty--;
                                                  }
                                                  retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                                  printMe("Current qty : $currentQty");
                                                  qtyTextController.text = currentQty.toString();
                                                  previousOrderController.isInitialTotalUnitPrice = true;
                                                  myState(() {});
                                                },
                                                onTapInCrease: () {
                                                  myState(() {
                                                    printMe("On tapped increase : ");
                                                    //int currentQty = items.itemCount;
                                                    int currentQty = int.tryParse(items.quantity ?? "0") ?? 0;
                                                    currentQty++;
                                                    //retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                                    previousOrderController.isInitialTotalUnitPrice = true;
                                                    //qtyTextController.text = currentQty.toString();
                                                    if (currentQty < 100000) {
                                                      retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      qtyTextController.text = currentQty.toString();
                                                    } else {
                                                      Widgets().showToast("Quantity can not be greater than 99999");
                                                    }
                                                  });
                                                },
                                                qtyTextController: qtyTextController,
                                                onChanged: (valueItemCount) {
                                                  qtyTextController.text = valueItemCount;
                                                  int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                                  //retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                                  if (qtyTextController.text.length < 6) {
                                                    if (currentQty != items.itemCount) {
                                                      retailerPreviousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      qtyTextController.text = currentQty.toString();
                                                    }
                                                    myState(() {});
                                                  } else {
                                                    Widgets().showToast("Quantity can not be greater than 99999");
                                                  }
                                                  myState(() {});
                                                },
                                                //qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                                qtyText: items.quantity ?? '',
                                                //totalCalculatedValue: '₹ ${items.itemCount > 1 ? items.totalPrice?.toStringAsFixed(2) : items.rlp}'
                                                totalCalculatedValue:
                                                    '₹ ${items.itemCount > 1 ? items.totalPrice?.toStringAsFixed(2) : items.itemCount == 0 ? "0.00" : items.rlp}',
                                                sqValue: "");
                                          }),
                                          saveButton: () {
                                            Get.back();
                                          },
                                        );
                                      },
                                      deleteIconOnTap: () {
                                        retailerPreviousOrderController.deletePreviousProductItem(items);
                                      },
                                      productDetailText: items.productName ?? '',
                                      //qtyValue: items.itemCount == 1 ? items.quantity.toString() : "${items.itemCount}",
                                      qtyValue: items.quantity ?? '',
                                      //totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.rlp}',
                                      totalPriceValue: '₹ ${items.rlp}',
                                      itemCode: "${items.skuCode}",
                                    );
                                  },
                                ));
                    }),
                    Widgets().verticalSpace(2.h),
                    GetBuilder<RetailerPreviousOrderController>(builder: (controller) {
                      return Widgets().customLRPadding(
                          child: Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartIcon, titleValue: controller.getTotalOrderQTY()));
                    }),
                  ],
                ),
                Widgets().verticalSpace(2.h),
                GetBuilder<RetailerCalculationController>(builder: (controller) {
                  return Widgets().totalOrderValueTile(context: context, iconName: cartIcon, titleValue: '₹ ${controller.totalPreviousOrderPrice}');
                }),
                Widgets().verticalSpace(3.h),
                Widgets().customLRPadding(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets().iconElevationButton(
                      onTap: () {
                        List<ProductLists> retailerNewOrderList = [];
                        for (int i = 0; i < retailerPreviousOrderController.orderDetailsProductList.length; i++) {
                          if (retailerPreviousOrderController.orderDetailsProductList.isNotEmpty) {
                            var newItems = retailerPreviousOrderController.orderDetailsProductList[i];
                            printMe("Sku code is : ${newItems.skuCode}");
                            ProductLists items = ProductLists(
                              skuCode: newItems.skuCode,
                              quantity: newItems.quantity,
                              mq: "",
                              sq: "",
                              cardColor: null,
                              itemCount: 0,
                              lastOrderd: "",
                              productName: newItems.productName,
                              rlp: newItems.rlp,
                              totalPrice: 0.0,
                            );

                            retailerNewOrderList.add(items);
                          }
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return RetailerNewOrder(
                            retailerCode: widget.retailerCode,
                            retailerName: widget.retailerName,
                            buName: secondaryController.selectedBu ?? '',
                            retailerNewOrderList: retailerNewOrderList,
                            emailAddress: widget.emailId,
                            isFromNewOrder: true,
                          );
                        }));
                      },
                      icon: addIcon,
                      iconColor: alizarinCrimson,
                      textColor: alizarinCrimson,
                      titleText: 'Add More',
                      isBackgroundOk: false,
                      width: 45.w,
                      bgColor: codGray,
                    ),
                    Widgets().dynamicButton(
                      onTap: () {
                        if (retailerCalculationController.selectedPreviousProductListOD.isEmpty) {
                          Widgets().showToast("Please add item in cart");
                        } else {
                          previewOrderController.getProductCategory(businessUnit: primaryOrderController.businessUnit).then((value) {
                            previewOrderSelectInfBottomSheet(context: context);
                          });
                        }
                      },
                      height: 6.h,
                      width: 45.w,
                      buttonBGColor: alizarinCrimson,
                      titleText: 'Checkout',
                      titleColor: white,
                    )
                  ],
                )),
                Widgets().verticalSpace(2.h),
              ],
            ),
          )),
    );
  }

  previewOrderSelectInfBottomSheet({required BuildContext context}) {
    return Get.bottomSheet(
      StatefulBuilder(builder: (context1, setState) {
        return Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(4.h), topLeft: Radius.circular(4.h))),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.5.h, left: 5.w, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().textWidgetWithW700(titleText: "Select Info", fontSize: 13.sp),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(closeIcon))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().verticalSpace(2.5.h),
                        Widgets().horizontalDivider(),
                        Widgets().verticalSpace(2.5.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Widgets().textWidgetWithW700(titleText: "Which products are available (Category)", fontSize: 12.sp),
                            Widgets().verticalSpace(2.5.h),
                            ListView.builder(
                              itemCount: previewOrderController.getProductCategoryListItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var items = previewOrderController.getProductCategoryListItems[index];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .4,
                                      child: Widgets().textWidgetWithW400(titleText: items.itemName ?? '', fontSize: 11.sp, textColor: codGray),
                                    ),
                                    Widgets().textWidgetWithW400(titleText: ":", fontSize: 11.sp, textColor: codGray),
                                    const Spacer(),
                                    Radio(
                                      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                      activeColor: alizarinCrimson,
                                      value: 1,
                                      groupValue: items.groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          items.groupValue = 1;
                                          previewOrderController.updateSelectedValuesList(index, items.groupValue ?? 0, items.sfaProductUploadId ?? '');
                                        });
                                      },
                                    ),
                                    Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                    Widgets().horizontalSpace(3.w),
                                    Radio(
                                      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                      activeColor: alizarinCrimson,
                                      value: 2,
                                      groupValue: items.groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          items.groupValue = 2;
                                          previewOrderController.updateSelectedValuesList(index, items.groupValue ?? 0, items.sfaProductUploadId ?? '');
                                        });
                                      },
                                    ),
                                    Widgets().textWidgetWithW400(titleText: "No", fontSize: 11.sp, textColor: codGray),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        //Dealer Board
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Widgets().textWidgetWithW700(titleText: "POSM visibility (Any POSM material available)", fontSize: 11.sp),
                            Widgets().verticalSpace(1.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: Widgets().textWidgetWithW400(titleText: 'Dealer Board', fontSize: 11.sp, textColor: codGray),
                                ),
                                Widgets().textWidgetWithW400(titleText: ":", fontSize: 11.sp, textColor: codGray),
                                const Spacer(),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 1,
                                  groupValue: previewOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previewOrderController.dealerBoardGroupValue = 1;
                                      printWarning("Selected select info : ${previewOrderController.dealerBoardGroupValue}");
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: previewOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previewOrderController.dealerBoardGroupValue = 2;
                                      printWarning("Selected select info : ${previewOrderController.dealerBoardGroupValue}");
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "No", fontSize: 11.sp, textColor: codGray),
                              ],
                            )
                          ],
                        ),
                        Widgets().verticalSpace(1.5.h),
                        //Product Sample board
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: Widgets().textWidgetWithW400(titleText: 'Product Sample board', fontSize: 11.sp, textColor: codGray),
                                ),
                                Widgets().textWidgetWithW400(titleText: ":", fontSize: 11.sp, textColor: codGray),
                                const Spacer(),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 1,
                                  groupValue: previewOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previewOrderController.pSampleBoardGroupValue = 1;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: previewOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previewOrderController.pSampleBoardGroupValue = 2;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "No", fontSize: 11.sp, textColor: codGray),
                              ],
                            )
                          ],
                        ),
                        Widgets().verticalSpace(1.5.h),

                        Widgets().dynamicButton(
                          onTap: () {
                            bool allItemsSelected = true;

                            retailerPreviousOrderController.yesRetailerSelectProduct = [];
                            retailerPreviousOrderController.noRetailerSelectProduct = [];

                            for (var items in previewOrderController.getProductCategoryListItems) {
                              if (items.groupValue == null) {
                                // If any item is not selected, set allItemsSelected to false
                                allItemsSelected = false;
                                break;
                              } else if (items.groupValue == 1) {
                                retailerPreviousOrderController.yesRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("Yes selected : ${retailerPreviousOrderController.yesRetailerSelectProduct}");
                              } else if (items.groupValue == 2) {
                                retailerPreviousOrderController.noRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("No selected : ${retailerPreviousOrderController.noRetailerSelectProduct}");
                              }
                            }

                            if (allItemsSelected) {
                              if (previewOrderController.dealerBoardGroupValue == 0) {
                                Widgets().showToast("Please select dealer board.");
                                return;
                              }
                              if (previewOrderController.pSampleBoardGroupValue == 0) {
                                Widgets().showToast("Please select product sample board.");
                                return;
                              }
                              Get.back();
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return RetailerOrderAgainCheckOut(
                                  selectedValues: previewOrderController.getProductCategoryListItems,
                                  retailerCode: widget.retailerCode,
                                  retailerName: widget.retailerName,
                                  orderID: widget.orderCartId,
                                  emailAddress: widget.emailId,
                                );
                              }));
                            } else {
                              Widgets().showToast("Please select all items before saving.");
                            }
                          },
                          height: 4.7.h,
                          width: 40.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: "Save",
                          titleColor: white,
                        ),
                        Widgets().verticalSpace(1.5.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
      barrierColor: Colors.transparent,
      persistent: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
    );
  }
}
