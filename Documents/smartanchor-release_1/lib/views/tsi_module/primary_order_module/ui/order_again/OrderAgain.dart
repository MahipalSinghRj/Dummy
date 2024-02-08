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

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/order_detail_model/OrderDetailsByIdResponse.dart';
import '../new_order/NewOrder.dart';
import 'OrderAgainCheckout.dart';

class OrderAgain extends StatefulWidget {
  final String navigationTag;
  final String orderCartId;
  final String customerName;
  final String customerCode;
  final String bu;

  const OrderAgain({
    Key? key,
    required this.orderCartId,
    required this.customerCode,
    required this.customerName,
    required this.navigationTag,
    required this.bu,
  }) : super(key: key);

  @override
  State<OrderAgain> createState() => _OrderAgainState();
}

class _OrderAgainState extends State<OrderAgain> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderDetailByIdController orderDetailByIdController = Get.put(OrderDetailByIdController());
  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());
  CalculationController calculationController = Get.put(CalculationController());
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  String? qtyValues;
  List<TextEditingController> qtyTextControllers = [];

  @override
  void initState() {
    super.initState();
    orderDetailsApiCall();
  }

  orderDetailsApiCall() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await orderDetailByIdController.orderDetailsById(orderCartId: widget.orderCartId, customerCode: widget.customerCode, bu: widget.bu).then((value) async {
      if (value == true) {
        await calculationController.setSelectedPreviousListItems(orderDetailByIdController.productDetailsbodies ?? []);
        previousOrderController.calculateTotalUnitPrice(orderDetailByIdController.productDetailsbodies ?? []);

        updateQtyTextControllers();

        setState(() {});
      }
    });
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      calculationController.selectedPreviousProductList.length,
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
                Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                Widgets().verticalSpace(2.h),
                Column(
                  children: [
                    GetBuilder<CalculationController>(builder: (controller) {
                      return Widgets().customLRPadding(
                          child: controller.selectedPreviousProductList.isEmpty
                              ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                              : ListView.builder(
                                  itemCount: controller.selectedPreviousProductList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    var items = controller.selectedPreviousProductList[index];
                                    updateQtyTextControllers();
                                    TextEditingController qtyTextController = qtyTextControllers[index];
                                    // qtyTextController.text = (items.productQty == "1" ? "1" : items.productQty.toString());
                                    qtyTextController.text = (items.punchedQty == "1" ? "1" : items.punchedQty.toString());
                                    return NewWidgets().previousOrderListCardNew(
                                      context: context,
                                      editIconOnTap: () {
                                        Widgets().editOrderBottomSheet(
                                          context: context,
                                          productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                            return Widgets().editPreviousOrderBottomSheet(
                                                deleteOnTap: () {
                                                  Get.back();
                                                  previousOrderController.deletePreviousProductItem(items);
                                                },
                                                productDetailText: items.productName!,
                                                context: context,
                                                amount: '₹  ${items.unitPriceList}',
                                                orderIdValue: items.itemCode ?? "",
                                                //qtyValue: items.itemCount == 1 ? items.productQty.toString() : "${items.itemCount}",
                                                qtyValue: items.punchedQty ?? '',
                                                onTapDecrease: () {
                                                  printMe("On tapped increase : ");
                                                  //int currentQty = items.itemCount;
                                                  int currentQty = int.tryParse(items.punchedQty ?? '0') ?? 0;
                                                  if (currentQty > 1) {
                                                    currentQty--;
                                                  }
                                                  previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                  previousOrderController.isInitialTotalUnitPrice = true;
                                                  qtyTextController.text = currentQty.toString();
                                                  myState(() {});
                                                },
                                                onTapInCrease: () {
                                                  myState(() {
                                                    printMe("On tapped increase : ");
                                                    //int currentQty = items.itemCount;
                                                    int currentQty = int.tryParse(items.punchedQty ?? '0') ?? 0;
                                                    currentQty++;
                                                    //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                    previousOrderController.isInitialTotalUnitPrice = true;
                                                    //qtyTextController.text = currentQty.toString();
                                                    if (currentQty < 100000) {
                                                      previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      qtyTextController.text = currentQty.toString();
                                                    } else {
                                                      Widgets().showToast("Quantity can not be greater than 99999");
                                                    }
                                                    myState(() {});
                                                  });
                                                },
                                                qtyTextController: qtyTextController,
                                                onChanged: (valueItemCount) {
                                                  qtyTextController.text = valueItemCount;
                                                  int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                                  //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                  if (currentQty < 100000) {
                                                    if (currentQty != items.itemCount) {
                                                      previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      qtyTextController.text = currentQty.toString();
                                                    }
                                                  } else {
                                                    Widgets().showToast("Quantity can not be greater than 99999");
                                                  }
                                                  myState(() {});
                                                },
                                                //qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                                qtyText: items.punchedQty ?? '',
                                                //totalCalculatedValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.unitPriceList}',
                                                totalCalculatedValue:
                                                    '₹ ${((double.tryParse(items.punchedQty ?? '0') ?? 0) >= 1) ? ((double.tryParse(items.unitPriceList ?? '0') ?? 0) * (double.tryParse(items.punchedQty ?? '0') ?? 0) * (double.tryParse(items.sQ ?? '0') ?? 0)) : "0.00"}',
                                                sqValue: items.sQ!);
                                          }),
                                          saveButton: () {
                                            Get.back();
                                          },
                                        );
                                      },
                                      deleteIconOnTap: () {
                                        previousOrderController.deletePreviousProductItem(items);
                                      },
                                      productDetailText: items.productName ?? '',
                                      //qtyValue: items.itemCount == 1 ? items.productQty.toString() : "${items.itemCount}",
                                      qtyValue: items.punchedQty ?? '',
                                      //totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.unitPriceList}',
                                      totalPriceValue:
                                          '₹ ${((double.tryParse(items.unitPriceList ?? '') ?? 0) * (double.tryParse(items.punchedQty ?? '') ?? 0) * (double.tryParse(items.sQ ?? '') ?? 0)).toStringAsFixed(2)}',
                                      itemCode: "${items.itemCode}",
                                    );
                                  },
                                ));
                    }),
                    Widgets().verticalSpace(2.h),
                    GetBuilder<PreviousOrderController>(builder: (controller) {
                      return Widgets().customLRPadding(
                          child: Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartIcon, titleValue: previousOrderController.getTotalOrderQTY()));
                    }),
                  ],
                ),
                Widgets().verticalSpace(2.h),
                GetBuilder<PreviousOrderController>(builder: (controller) {
                  return Widgets().totalOrderValueTile(context: context, iconName: cartIcon, titleValue: '₹  ${calculationController.totalPreviousOrderPrice}');
                }),
                Widgets().verticalSpace(3.h),
                Widgets().customLRPadding(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets().iconElevationButton(
                      /*onTap: () {
                        if (widget.navigationTag.toString().toLowerCase() == 'PreviousOrder'.toString().toLowerCase()) {
                          List<ProductByBUItems> newOrderListData = [];
                          printMe("List length : ${calculationController.selectedPreviousProductList.length}");

                          for (int i = 0; i < calculationController.selectedPreviousProductList.length; i++) {
                            ProductByBUItems items = ProductByBUItems(
                              dLP: calculationController.selectedPreviousProductList[i].dLP,
                              lastOD: calculationController.selectedPreviousProductList[i].lastOD,
                              mRP: '',
                              sKUCode: calculationController.selectedPreviousProductList[i].skuCode,
                              sQ: calculationController.selectedPreviousProductList[i].sQ,
                              warehouse: '',
                              availableQty: calculationController.selectedPreviousProductList[i].availableQty,
                              itemCode: calculationController.selectedPreviousProductList[i].itemCode,
                              masterQuantity: calculationController.selectedPreviousProductList[i].masterQuantity,
                              poductName: calculationController.selectedPreviousProductList[i].productName,
                              productMasterId: calculationController.selectedPreviousProductList[i].productMasterId,
                              isSelected: true,
                              cardColor: null,
                              itemCount: 1,
                              totalPrice: 0.0,
                              selectedQty: 1,
                            );
                            newOrderListData.add(items);
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return NewOrder(
                              customerCode: widget.customerCode,
                              buName: primaryOrderController.businessUnit,
                              customerName: widget.customerName,
                              newOrderListData: newOrderListData,
                              isFromNewOrder: true,
                            );
                          }));
                        } else {
                          Navigator.pop(context);
                        }
                      },*/
                      onTap: () {
                        if (widget.navigationTag.toString().toLowerCase() == 'PreviousOrder'.toString().toLowerCase()) {
                          List<ProductByBUItems> newOrderListData = [];

                          for (int i = 0; i < calculationController.selectedPreviousProductList.length; i++) {
                            ProductDetailsbodies items = calculationController.selectedPreviousProductList[i];
                            ProductByBUItems newOrderItem = ProductByBUItems(
                              dLP: items.dLP,
                              lastOD: items.lastOD,
                              mRP: items.mrp,
                              //sKUCode: items.skuCode,
                              sKUCode: items.itemCode,
                              sQ: items.sQ,
                              //warehouse: '',
                              availableQty: items.availableQty,
                              itemCode: items.itemCode,
                              masterQuantity: items.masterQuantity,
                              poductName: items.productName,
                              productMasterId: items.productMasterId,
                              isSelected: true,
                              cardColor: null,
                              itemCount: 1,
                              totalPrice: 0.0,
                              selectedQty: 1,
                            );
                            newOrderListData.add(newOrderItem);
                            printMe("Added new items name : ${newOrderItem.poductName}");
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return NewOrder(
                              customerCode: widget.customerCode,
                              buName: primaryOrderController.businessUnit,
                              customerName: widget.customerName,
                              newOrderListData: newOrderListData,
                              isFromNewOrder: true,
                            );
                          }));
                        } else {
                          Navigator.pop(context);
                        }
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
                        if (calculationController.selectedPreviousProductList.isEmpty) {
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
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 4,
                offset: Offset(0, -4),
                spreadRadius: 5,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.h),
              topLeft: Radius.circular(4.h),
            ),
          ),
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
                          child: SvgPicture.asset(closeIcon),
                        )
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("POSM visibility (Any POSM material available)",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
                                textAlign: TextAlign.start),
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
                                  groupValue: previousOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previousOrderController.dealerBoardGroupValue = 1;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: previousOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previousOrderController.dealerBoardGroupValue = 2;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "No", fontSize: 11.sp, textColor: codGray),
                              ],
                            )
                          ],
                        ),
                        Widgets().verticalSpace(1.5.h),
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
                                  groupValue: previousOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previousOrderController.pSampleBoardGroupValue = 1;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: previousOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previousOrderController.pSampleBoardGroupValue = 2;
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
                            previewOrderController.yesRetailerSelectProduct = [];
                            previewOrderController.noRetailerSelectProduct = [];

                            // Check if all available products are selected
                            for (var items in previewOrderController.getProductCategoryListItems) {
                              if (items.groupValue == null) {
                                allItemsSelected = false;
                                Widgets().showToast("Please select all available products.");
                                break;
                              } else if (items.groupValue == 1) {
                                previewOrderController.yesRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("Yes selected : ${previewOrderController.yesRetailerSelectProduct}");
                              } else if (items.groupValue == 2) {
                                previewOrderController.noRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("No selected : ${previewOrderController.noRetailerSelectProduct}");
                              }
                            }
                            // If all available products are selected, check dealer board
                            if (allItemsSelected) {
                              if (previousOrderController.dealerBoardGroupValue == 0) {
                                Widgets().showToast("Please select dealer board.");
                                return;
                              }
                              // If dealer board is selected, check product sample board
                              if (previousOrderController.pSampleBoardGroupValue == 0) {
                                Widgets().showToast("Please select product sample board.");
                                return;
                              }
                              // If all conditions are met, navigate to OrderAgainCheckOut
                              Get.back();
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return OrderAgainCheckOut(
                                  navigationTag: widget.navigationTag,
                                  selectedValues: previewOrderController.getProductCategoryListItems,
                                  customerCode: widget.customerCode,
                                  customerName: widget.customerName,
                                  totalOrderValue: calculationController.totalPreviousOrderPrice,
                                  productDetailsBodiesList: orderDetailByIdController.productDetailsbodies ?? [],
                                );
                              }));
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
