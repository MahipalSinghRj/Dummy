import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../controllers/calculationController/CalculationController.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../checkout/CheckOut.dart';

class PreviewOrder extends StatefulWidget {
  final List<ProductByBUItems> productByBuItemsList;
  final int totalQty;
  final String totalPrize;
  final String customerName;
  final String customerCode;
  final String qtyText;

  const PreviewOrder(
      {Key? key,
      required this.productByBuItemsList,
      required this.totalQty,
      required this.customerName,
      required this.customerCode,
      required this.totalPrize,
      required this.qtyText})
      : super(key: key);

  @override
  State<PreviewOrder> createState() => _PreviewOrderState();
}

class _PreviewOrderState extends State<PreviewOrder> {
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  CalculationController _calculationController = Get.put(CalculationController());
  NewOrderController _newOrderController = Get.put(NewOrderController());
  List<TextEditingController> qtyTextControllers = [];

  @override
  void initState() {
    super.initState();
    updateQtyTextControllers();
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      _calculationController.selectedProductListItems.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                    child: _calculationController.selectedProductListItems.isEmpty
                        ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                        : ListView.builder(
                            itemCount: _calculationController.selectedProductListItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var items = _calculationController.selectedProductListItems[index];
                              updateQtyTextControllers();
                              TextEditingController qtyTextController = qtyTextControllers[index];
                              qtyTextController.text = items.itemCount.toString();
                              return NewWidgets().previousOrderListCardNew(
                                context: context,
                                editIconOnTap: () {
                                  Widgets().editOrderBottomSheet(
                                      context: context,
                                      productListCardWidget: Widgets().customLRPadding(child: StatefulBuilder(builder: (context1, myState) {
                                        return Widgets().productListCard(
                                            context: context,
                                            productDetailText: items.poductName!,
                                            deleteOnTap: () {
                                              Get.back();
                                              controller.deleteProductItem(items);
                                            },
                                            skuCodeValue: items.sKUCode!,
                                            mrpValue: items.mRP!,
                                            sqValue: items.sQ!,
                                            availableQtyValue: items.availableQty!,
                                            dlpValue: items.dLP!,
                                            mqValue: items.masterQuantity!,
                                            lastOdValue: items.lastOD!,
                                            onTapDecrease: () {
                                              printMe("On tapped increase : ");
                                              int currentQty = items.itemCount;
                                              if (currentQty > 1) {
                                                currentQty--;
                                              }
                                              _newOrderController.updateQtyValue(currentQty, items);
                                              qtyTextController.text = currentQty.toString();
                                              myState(() {});
                                            },
                                            onTapInCrease: () {
                                              printMe("On tapped increase : ");
                                              int currentQty = items.itemCount;
                                              currentQty++;
                                              //_newOrderController.updateQtyValue(currentQty, items);
                                              //qtyTextController.text = currentQty.toString();

                                              if (currentQty < 100000) {
                                                _newOrderController.updateQtyValue(currentQty, items);
                                                qtyTextController.text = currentQty.toString();
                                              } else {
                                                Widgets().showToast("Quantity can not be greater than 99999");
                                              }

                                              myState(() {});
                                            },
                                            qtyTextController: qtyTextController,
                                            onChanged: (valueItemCount) {
                                              qtyTextController.text = valueItemCount;
                                              int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                              //_newOrderController.updateQtyValue(currentQty, items);
                                              if (currentQty < 100000) {
                                                if (currentQty != items.itemCount) {
                                                  _newOrderController.updateQtyValue(currentQty, items);
                                                  qtyTextController.text = currentQty.toString();
                                                }
                                              } else {
                                                Widgets().showToast("Quantity can not be greater than 99999");
                                              }
                                              myState(() {});
                                            },
                                            // qtyText: items.itemCount == 1
                                            //     ? "1"
                                            //     : "${items.itemCount}",
                                            totalValueText: items.itemCount == 1
                                                ? "₹ ${(double.tryParse(items.dLP ?? '0.0') ?? 0.0) * (int.tryParse(items.sQ ?? '0') ?? 0)}"
                                                : '₹ ${(items.totalPrice ?? 0).toStringAsFixed(2)}');
                                      })),
                                      saveButton: () {
                                        Get.back();
                                      });
                                },
                                deleteIconOnTap: () {
                                  printMe("Clicked delete icon");
                                  _newOrderController.deleteProductItem(items);
                                },
                                productDetailText: items.poductName ?? '',
                                qtyValue: items.itemCount.toString(),
                                totalPriceValue:
                                    '₹ ${items.itemCount > 1 ? items.totalPrice : "${(double.tryParse(items.dLP ?? '0.0') ?? 0.0) * (int.tryParse(items.sQ ?? '0') ?? 0)}"}',
                                itemCode: "${items.itemCode}",
                              );
                            },
                          ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartSvgIcon, titleValue: _newOrderController.getTotalOrderQTY()),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                    child: Widgets().iconElevationButton(
                      onTap: () {
                        //Get.back();
                        //Get.back();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: addIcon,
                      iconColor: alizarinCrimson,
                      titleText: 'Add More',
                      textColor: alizarinCrimson,
                      isBackgroundOk: false,
                      width: 100.w,
                      bgColor: codGray,
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${_calculationController.totalPrice}'),
                  Widgets().verticalSpace(7.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () async {
                            await _calculationController.removeSelectedProductListItems(key: "selectedProductListItems");
                            await _calculationController.removeSelectedProductListItems(key: "totalPrice");
                            globalController.splashNavigation();
                          },
                          height: 6.h,
                          width: 41.w,
                          buttonBGColor: codGray,
                          titleText: 'Cancel Order',
                          titleColor: white),
                      Widgets().dynamicButton(
                          onTap: () {
                            if (_calculationController.selectedProductListItems.isEmpty) {
                              Widgets().showToast("Please add item in cart");
                              return;
                            }
                            previewOrderController.getProductCategory(businessUnit: primaryOrderController.businessUnit).then((value) {
                              previewOrderSelectInfBottomSheet(context: context);
                            });
                          },
                          height: 6.h,
                          width: 41.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Checkout',
                          titleColor: white)
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                ],
              ),
            )),
      );
    });
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
                                  groupValue: previewOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      previewOrderController.dealerBoardGroupValue = 1;
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
                        // Widgets().dynamicButton(
                        //     onTap: () {
                        //       Get.back();
                        //       Navigator.push(context, MaterialPageRoute(builder: (_) {
                        //         return CheckOut(
                        //           selectedValues: previewOrderController.getProductCategoryListItems,
                        //           customerCode: widget.customerCode,
                        //           customerName: widget.customerName,
                        //           totalOrderValue: widget.totalPrize,
                        //           productByBuItemsList: _calculationController.selectedProductListItems,
                        //         );
                        //       }));
                        //     },
                        //     height: 4.7.h,
                        //     width: 40.w,
                        //     buttonBGColor: alizarinCrimson,
                        //     titleText: "Save",
                        //     titleColor: white),
                        Widgets().dynamicButton(
                          onTap: () {
                            bool allItemsSelected = true;

                            previewOrderController.yesRetailerSelectProduct = [];
                            previewOrderController.noRetailerSelectProduct = [];

                            for (var items in previewOrderController.getProductCategoryListItems) {
                              if (items.groupValue == null) {
                                allItemsSelected = false;
                                break;
                              } else if (items.groupValue == 1) {
                                previewOrderController.yesRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("Yes selected : ${previewOrderController.yesRetailerSelectProduct}");
                              } else if (items.groupValue == 2) {
                                previewOrderController.noRetailerSelectProduct.add(items.itemName ?? '');
                                printMe("No selected : ${previewOrderController.noRetailerSelectProduct}");
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
                                return CheckOut(
                                  selectedValues: previewOrderController.getProductCategoryListItems,
                                  customerCode: widget.customerCode,
                                  customerName: widget.customerName,
                                  totalOrderValue: widget.totalPrize,
                                  productByBuItemsList: _calculationController.selectedProductListItems,
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
