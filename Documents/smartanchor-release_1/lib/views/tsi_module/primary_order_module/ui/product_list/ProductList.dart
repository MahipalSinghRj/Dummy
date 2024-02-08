import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/calculationController/CalculationController.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../preview_order/PreviewOrder.dart';

//ignore: must_be_immutable
class ProductList extends StatefulWidget {
  final String customerName;
  final String customerCode;
  List<ProductByBUItems> productByBUItems;
  ProductList({Key? key, required this.customerName, required this.customerCode, required this.productByBUItems}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  NewOrderController newOrderController = Get.put(NewOrderController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  CalculationController _calculationController = Get.put(CalculationController());
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
    int totalQty = newOrderController.calculateTotalQty(_calculationController.selectedProductListItems);
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
                  Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${_calculationController.totalPrice}'),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                      child: Column(
                    children: [
                      _calculationController.selectedProductListItems.isEmpty
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
                                return Widgets().productListCard(
                                  context: context,
                                  productDetailText: items.poductName.toString(),
                                  deleteOnTap: () {
                                    controller.deleteProductItem(items);
                                  },
                                  skuCodeValue: items.sKUCode.toString(),
                                  mrpValue: items.mRP.toString(),
                                  sqValue: items.sQ.toString(),
                                  availableQtyValue: items.availableQty.toString(),
                                  dlpValue: items.dLP.toString(),
                                  mqValue: items.masterQuantity.toString(),
                                  lastOdValue: items.lastOD.toString(),
                                  onTapDecrease: () {
                                    printMe("On tapped increase : ");
                                    int currentQty = items.itemCount;
                                    if (currentQty > 1) {
                                      currentQty--;
                                    }
                                    newOrderController.updateQtyValue(currentQty, items);
                                    qtyTextController.text = currentQty.toString();
                                  },
                                  onTapInCrease: () {
                                    printMe("On tapped increase : ");
                                    int currentQty = items.itemCount;
                                    currentQty++;
                                    // newOrderController.updateQtyValue(currentQty, items);
                                    // qtyTextController.text = currentQty.toString();
                                    if (currentQty < 100000) {
                                      newOrderController.updateQtyValue(currentQty, items);
                                      qtyTextController.text = currentQty.toString();
                                    } else {
                                      Widgets().showToast("Quantity can not be greater than 99999");
                                    }
                                  },
                                  qtyTextController: qtyTextController,
                                  onChanged: (valueItemCount) {
                                    qtyTextController.text = valueItemCount;
                                    int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                    //newOrderController.updateQtyValue(currentQty, items);
                                    if (currentQty < 100000) {
                                      if (currentQty != items.itemCount) {
                                        newOrderController.updateQtyValue(currentQty, items);
                                        qtyTextController.text = currentQty.toString();
                                      }
                                    } else {
                                      Widgets().showToast("Quantity can not be greater than 99999");
                                    }
                                    setState(() {});
                                  },
                                  // qtyText: items.itemCount == 1
                                  //     ? "1"
                                  //     : "${items.itemCount}",
                                  totalValueText: items.itemCount == 1
                                      ? "₹ ${(double.tryParse(items.dLP ?? "0.0") ?? 0.0) * (int.tryParse(items.sQ ?? '0') ?? 0)}"
                                      : '₹ ${items.totalPrice}',
                                );
                              },
                            ),
                      Widgets().verticalSpace(2.h),
                      Widgets().totalOrderQTYTileWithBGColor(context: context, iconName: cartSvgIcon, titleValue: newOrderController.getTotalOrderQTY()),
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
                                for (int i = 0; i < _calculationController.selectedProductListItems.length; i++) {
                                  var itemCount = _calculationController.selectedProductListItems[i].itemCount.toString();
                                  printMe("Item count : $itemCount");
                                }
                                if (_calculationController.selectedProductListItems.isEmpty) {
                                  Widgets().showToast("Please add item in cart");
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return PreviewOrder(
                                      productByBuItemsList: _calculationController.selectedProductListItems,
                                      totalQty: totalQty,
                                      customerName: widget.customerName,
                                      customerCode: widget.customerCode,
                                      totalPrize: _calculationController.totalPrice,
                                      qtyText: "",
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
