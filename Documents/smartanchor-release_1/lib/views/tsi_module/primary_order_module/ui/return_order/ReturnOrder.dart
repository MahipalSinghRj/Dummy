import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/return_order_controller/ReturnOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/new_order_controller/NewOrderController.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import 'EditReturnOrder.dart';

class ReturnOrder extends StatefulWidget {
  final String bu;
  final String customerCode;
  final String customerName;

  const ReturnOrder({Key? key, required this.bu, required this.customerCode, required this.customerName}) : super(key: key);

  @override
  State<ReturnOrder> createState() => _ReturnOrderState();
}

class _ReturnOrderState extends State<ReturnOrder> {
  final TextEditingController searchController = TextEditingController();
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  CalculationController _calculationController = Get.put(CalculationController());
  GlobalController globalController = Get.put(GlobalController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  NewOrderController newOrderController = Get.put(NewOrderController());

  String? selectedCategory;
  String? selectedSubBrand;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await returnOrderController.returnOrderById(customerCode: widget.customerCode, buName: widget.bu, category: selectedCategory ?? '', subBrand: selectedSubBrand ?? '');
    await returnOrderController.getReturnOrdersWithDropdown();
  }

  //TODO
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          _calculationController.removeSelectedProductListItems(key: 'selectedReturnProductList');
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
              floatingActionButton: Widgets().notificationCartFAButton(
                  notificationCount: _calculationController.returnCartItemCount,
                  onTap: () {
                    _calculationController.returnCartItemCount == "0"
                        ? Widgets().showToast("Cart is empty.")
                        : Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return EditReturnOrder(
                              selectedItems: _calculationController.selectedReturnProductList,
                              customerName: widget.customerName,
                              customerCode: widget.customerCode,
                            );
                          }));
                  }),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                            child: Widgets().customLRPadding(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Return Order", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().commonDropdown(
                                      hintText: "Select Category",
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                        await returnOrderController.returnOrderById(customerCode: widget.customerCode, buName: widget.bu, category: selectedCategory ?? '', subBrand: selectedSubBrand ?? '');
                                      },
                                      itemValue: controller.categoriesList,
                                      selectedValue: selectedCategory),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().commonDropdown(
                                      hintText: "Select SubBrand",
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedSubBrand = value;
                                        });
                                        await returnOrderController.returnOrderById(customerCode: widget.customerCode, buName: widget.bu, category: selectedCategory ?? '', subBrand: selectedSubBrand ?? '');
                                      },
                                      itemValue: controller.subcategoriesList,
                                      selectedValue: selectedSubBrand),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textFieldWidget(
                                      controller: searchController, hintText: 'Type here', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                                  Widgets().verticalSpace(2.h),
                                ],
                              ),
                            )),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(child: Widgets().textWidgetWithW500(titleText: "Products List", fontSize: 11.sp, textColor: codGray)),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: ListView.builder(
                            itemCount: controller.productsList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var items = controller.productsList[index];
                              return Widgets().returnOrderProductListCard(
                                  context: context,
                                  initialValue: controller.isReturnProductSelected(items),
                                  onChanged: (value) {
                                    controller.updateProductSelection(items, value!);
                                  },
                                  productDetailText: items.poductName ?? '',
                                  skuCodeValue: items.sKUCode ?? '',
                                  availableQtyValue: items.availableQty ?? '',
                                  cardColor: magnolia,
                                  checkBoxColor: items.isSelected == true ? alizarinCrimson : checkBoxColor);
                            },
                          ),
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }
}
