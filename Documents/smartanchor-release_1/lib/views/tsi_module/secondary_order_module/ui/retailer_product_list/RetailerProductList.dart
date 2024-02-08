import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/retailer_calculation_controller/RetailerCalculationController.dart';
import '../../controllers/retailer_new-order_controller/RetailerNewOrderController.dart';
import '../retailer_preview_order/RetailerPreviewOrder.dart';

//ignore: must_be_immutable
class RetailerProductList extends StatefulWidget {
  final String retailerName;
  final String retailerCode;
  final String emailAddress;
  const RetailerProductList({Key? key, required this.retailerName,
    required this.retailerCode, required this.emailAddress}) : super(key: key);

  @override
  State<RetailerProductList> createState() => _RetailerProductListState();
}

class _RetailerProductListState extends State<RetailerProductList> {
  RetailerCalculationController _retailerCalculationController = Get.put(RetailerCalculationController());
  RetailerNewOrderControllerSec _retailerNewOrderControllerSec = Get.put(RetailerNewOrderControllerSec());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<TextEditingController> qtyTextControllers = [];

  @override
  void initState() {
    super.initState();
    qtyTextControllers = List.generate(
      _retailerCalculationController.selectedRetailerProductListItems.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
                  Widgets().totalOrderValueTile(
                      context: context, iconName: cartSvgIcon, titleValue: '₹ ${_retailerCalculationController.totalPrice}'),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                      child: Column(
                    children: [
                      _retailerCalculationController.selectedRetailerProductListItems.isEmpty
                          ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                          : ListView.builder(
                              itemCount: _retailerCalculationController.selectedRetailerProductListItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var items = _retailerCalculationController.selectedRetailerProductListItems[index];
                                TextEditingController qtyTextController = qtyTextControllers[index];
                                qtyTextController.text = items.itemCount == 1 ? "1" : items.itemCount.toString();

                                return Widgets().retailerProductListCard(
                                    context: context,
                                    productDetailText: items.productName.toString(),
                                    deleteOnTap: () {
                                      controller.deleteProductItem(items);
                                    },
                                    skuCodeValue: items.skuCode.toString(),
                                    sqValue: items.sq.toString(),
                                    availableQtyValue: items.quantity.toString(),
                                    mqValue: items.mq.toString(),
                                    lastOdValue: items.lastOrderd.toString(),
                                    onTapDecrease: () {
                                      printMe("On tapped increase : ");
                                      int currentQty = items.itemCount;
                                      if (currentQty > 1) {
                                        currentQty--;
                                      }
                                      controller.updateQtyValue(currentQty, items);
                                      qtyTextController.text = currentQty.toString();
                                    },
                                    onTapInCrease: () {
                                      printMe("On tapped increase : ");
                                      int currentQty = items.itemCount;
                                      currentQty++;

                                      if (currentQty < 100000) {
                                        controller.updateQtyValue(currentQty, items);
                                        qtyTextController.text = currentQty.toString();
                                      } else {
                                        Widgets().showToast("Quantity can not be greater than 99999");
                                      }

                                      FocusScope.of(context).unfocus();
                                    },
                                    //qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                    totalValueText: items.itemCount == 1 ? "₹ ${items.rlp}" : '₹ ${items.totalPrice?.toStringAsFixed(2)}',
                                    qtyTextController: qtyTextController,
                                    onChanged: (valueItemCount) {
                                      qtyTextController.text = valueItemCount;
                                      int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                      //controller.updateQtyValue(currentQty, items);
                                      if (currentQty < 100000) {
                                        if (currentQty != items.itemCount) {
                                          controller.updateQtyValue(currentQty, items);
                                          qtyTextController.text = currentQty.toString();
                                        }
                                      } else {
                                        Widgets().showToast("Quantity can not be greater than 99999");
                                      }
                                      setState(() {});
                                    });
                              },
                            ),
                      Widgets().verticalSpace(2.h),
                      Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartSvgIcon, titleValue: _retailerNewOrderControllerSec.getTotalOrderQTY()),
                      Widgets().verticalSpace(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Widgets().iconElevationButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              icon: addIcon,
                              iconColor: alizarinCrimson,
                              titleText: 'Add More',
                              textColor: alizarinCrimson,
                              isBackgroundOk: false,
                              width: 45.w,
                              height: 6.h,
                              bgColor: codGray),
                          Widgets().horizontalSpace(2.w),
                          Widgets().dynamicButton(
                              onTap: () {
                                if (_retailerCalculationController.selectedRetailerProductListItems.isEmpty) {
                                  Widgets().showToast("Please add item in cart");
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return RetailerPreviewOrder(
                                      retailerName: widget.retailerName,
                                      retailerCode: widget.retailerCode,
                                      totalPrize: _retailerCalculationController.totalPrice,
                                        emailAddress:widget.emailAddress
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
                      Widgets().verticalSpace(2.h),
                    ],
                  ))
                ],
              ),
            )),
      );
    });
  }
}
