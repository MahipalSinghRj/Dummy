import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/return_order_controller/ReturnOrderController.dart';
import '../../models/responseModels/return_order_model/ReturnOrderbyIdResponse.dart';
import 'ReturnOrderPreview.dart';

class EditReturnOrder extends StatefulWidget {
  final String customerCode;
  final String customerName;
  final List<ReturnOrderByIdListData> selectedItems;

  const EditReturnOrder({
    Key? key,
    required this.selectedItems,
    required this.customerCode,
    required this.customerName,
  }) : super(key: key);

  @override
  State<EditReturnOrder> createState() => _EditReturnOrderState();
}

class _EditReturnOrderState extends State<EditReturnOrder> {
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  CalculationController _calculationController = Get.put(CalculationController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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
                  child: Column(
                    children: [
                      controller.selectedReturnProductList.isEmpty
                          ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                          : ListView.builder(
                              itemCount: controller.selectedReturnProductList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var items = controller.selectedReturnProductList[index];
                                return Widgets().returnOrderListCard(
                                    context: context,
                                    productDetailText: items.poductName ?? '',
                                    deleteOnTap: () {
                                      returnOrderController.deleteReturnProductItem(items);
                                    },
                                    skuCodeValue: items.sKUCode ?? '',
                                    mrpValue: '₹ ${items.mRP!}',
                                    dlpValue: '₹ ${items.dLP!}',
                                    totalValue:
                                        '₹${widget.selectedItems[index].totalPrice.toString() == 'null' ? "₹ ${widget.selectedItems[index].dLP}" : '₹ ${widget.selectedItems[index].totalPrice}'}',
                                    onTapDecrease: () {
                                      printMe("On tapped increase : ");
                                      int currentQty = _calculationController.selectedReturnProductList[index].itemCount;
                                      if (currentQty > 1) {
                                        currentQty--;
                                      }
                                      returnOrderController.updateReturnQtyValue(currentQty, _calculationController.selectedReturnProductList[index]);
                                    },
                                    onTapInCrease: () {
                                      int currentQty = _calculationController.selectedReturnProductList[index].itemCount;
                                      currentQty++;

                                      printMe("currentQty --> $currentQty");
                                      printMe("Avbl Qty --> ${widget.selectedItems[index].availableQty}");

                                      if (currentQty >= (int.tryParse(widget.selectedItems[index].availableQty ?? '0') ?? 0)) {
                                        printMe("BLOCK");
                                        Widgets().showToast("Maximum item count reach");
                                        return;
                                      }

                                      returnOrderController.updateReturnQtyValue(currentQty, _calculationController.selectedReturnProductList[index]);
                                    },
                                    qtyText: _calculationController.selectedReturnProductList[index].itemCount == 1
                                        ? "1"
                                        : "${_calculationController.selectedReturnProductList[index].itemCount}",
                                    totalValueText: _calculationController.selectedReturnProductList[index].itemCount == 1
                                        ? "₹ ${items.dLP}"
                                        : '₹ ${_calculationController.selectedReturnProductList[index].totalPrice}');
                              },
                            ),
                      Widgets().verticalSpace(2.h),
                      Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartIcon, titleValue: returnOrderController.getReturnTotalOrderQTY()),
                    ],
                  ),
                ),
                Widgets().verticalSpace(2.h),
                Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${_calculationController.totalReturnPrice}'),
                Widgets().verticalSpace(2.h),
                Widgets().customLRPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().iconElevationButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        icon: addIcon,
                        titleText: 'Add More',
                        isBackgroundOk: false,
                        width: 45.w,
                        iconColor: alizarinCrimson,
                        textColor: alizarinCrimson,
                        bgColor: codGray,
                      ),
                      Widgets().dynamicButton(
                          onTap: () {
                            if (controller.selectedReturnProductList.isEmpty) {
                              Widgets().showToast("Please add item in cart");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return ReturnOrderPreview(
                                  customerName: widget.customerName,
                                  customerCode: widget.customerCode,
                                  totalPrize: _calculationController.totalReturnPrice,
                                  qtyText: "",
                                  totalQty: 0,
                                  selectedReturnProductList: const [],
                                );
                              }));
                            }
                          },
                          height: 6.h,
                          width: 45.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Preview Order',
                          titleColor: white)
                    ],
                  ),
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
