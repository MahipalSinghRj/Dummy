import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/return_order_controller/ReturnOrderController.dart';
import '../../controllers/calculationController/CalculationController.dart';
import '../../models/responseModels/return_order_model/ReturnOrderbyIdResponse.dart';
import 'ReturnOrderCheckOut.dart';

class ReturnOrderPreview extends StatefulWidget {
  final List<ReturnOrderByIdListData> selectedReturnProductList;
  final int totalQty;
  final String totalPrize;
  final String customerName;
  final String customerCode;
  final String qtyText;

  const ReturnOrderPreview(
      {Key? key,
      required this.selectedReturnProductList,
      required this.totalQty,
      required this.customerName,
      required this.customerCode,
      required this.totalPrize,
      required this.qtyText})
      : super(key: key);

  @override
  State<ReturnOrderPreview> createState() => _ReturnOrderPreviewState();
}

class _ReturnOrderPreviewState extends State<ReturnOrderPreview> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  CalculationController _calculationController = Get.put(CalculationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculationController>(builder: (controller) {
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
                    child: StatefulBuilder(builder: (context, setState) {
                      return controller.selectedReturnProductList.isEmpty
                          ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                          : ListView.builder(
                              itemCount: controller.selectedReturnProductList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var items = controller.selectedReturnProductList[index];
                                return Widgets().previousOrderListCard(
                                    context: context,
                                    editIconOnTap: () {
                                      Widgets().editOrderBottomSheet(
                                          context: context,
                                          productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                            return Widgets().returnOrderListCard(
                                                context: context,
                                                productDetailText: items.poductName ?? '',
                                                deleteOnTap: () {
                                                  Get.back();
                                                  returnOrderController.deleteReturnProductItem(items);
                                                  myState(() {});
                                                },
                                                skuCodeValue: items.sKUCode ?? '',
                                                mrpValue: '₹ ${items.mRP!}',
                                                dlpValue: '₹ ${items.dLP!}',
                                                totalValue: items.itemCount == 1 ? "₹ ${items.dLP}" : '₹ ${items.totalPrice}',
                                                onTapDecrease: () {
                                                  printMe("On tapped increase : ");
                                                  int currentQty = items.itemCount;
                                                  if (currentQty > 1) {
                                                    currentQty--;
                                                  }
                                                  returnOrderController.updateReturnQtyValue(currentQty, items);
                                                  myState(() {});
                                                },
                                                onTapInCrease: () {
                                                  printMe("On tapped increase : ");
                                                  int currentQty = items.itemCount;
                                                  currentQty++;

                                                  if (currentQty >= (int.tryParse(items.availableQty ?? '0') ?? 0)) {
                                                    printMe("BLOCK");
                                                    Widgets().showToast("Maximum item count reach");
                                                    return;
                                                  }
                                                  returnOrderController.updateReturnQtyValue(currentQty, items);
                                                  myState(() {});
                                                },
                                                qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                                totalValueText: items.itemCount == 1 ? "₹ ${items.dLP}" : '₹ ${items.totalPrice}');
                                          }),
                                          saveButton: () {
                                            Get.back();
                                          });
                                    },
                                    deleteIconOnTap: () {
                                      returnOrderController.deleteReturnProductItem(items);
                                    },
                                    productDetailText: items.poductName ?? '',
                                    qtyValue: items.itemCount.toString(),
                                    totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.dLP}');
                              },
                            );
                    }),
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartSvgIcon, titleValue: returnOrderController.getReturnTotalOrderQTY()),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                    child: Widgets().iconElevationButton(
                      onTap: () {
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
                  Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${_calculationController.totalReturnPrice}'),
                  Widgets().verticalSpace(7.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () {
                            globalController.splashNavigation();
                          },
                          height: 6.h,
                          width: 41.w,
                          buttonBGColor: codGray,
                          titleText: 'Cancel Order',
                          titleColor: white),
                      Widgets().dynamicButton(
                          onTap: () {
                            if (controller.selectedReturnProductList.isEmpty) {
                              Widgets().showToast("Please add item in cart");
                            } else {
                              previewOrderController.getProductCategory(businessUnit: primaryOrderController.businessUnit).then((value) {
                                previewOrderSelectInfBottomSheet(context: context);
                              });
                            }
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
                                  groupValue: returnOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      returnOrderController.dealerBoardGroupValue = 1;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: returnOrderController.dealerBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      returnOrderController.dealerBoardGroupValue = 2;
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
                                  groupValue: returnOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      returnOrderController.pSampleBoardGroupValue = 1;
                                    });
                                  },
                                ),
                                Widgets().textWidgetWithW400(titleText: "Yes", fontSize: 11.sp, textColor: codGray),
                                Widgets().horizontalSpace(3.w),
                                Radio(
                                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  activeColor: alizarinCrimson,
                                  value: 2,
                                  groupValue: returnOrderController.pSampleBoardGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      returnOrderController.pSampleBoardGroupValue = 2;
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
                              Get.back();
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return ReturnOrderCheckOut(
                                  selectedValues: previewOrderController.getProductCategoryListItems,
                                  customerCode: widget.customerCode,
                                  customerName: widget.customerName,
                                  totalOrderValue: widget.totalPrize,
                                  returnOrderByIdListData: _calculationController.selectedReturnProductList,
                                );
                              }));
                            },
                            height: 4.7.h,
                            width: 40.w,
                            buttonBGColor: alizarinCrimson,
                            titleText: "Save",
                            titleColor: white),
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
