import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../controllers/calculationController/CalculationController.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../product_list/ProductList.dart';
import 'SearchNewOrder.dart';

//ignore: must_be_immutable
class NewOrder extends StatefulWidget {
  final String customerName;
  final String customerCode;
  final String buName;
  final List<ProductByBUItems> newOrderListData;
  final bool? isFromNewOrder;

  const NewOrder({
    Key? key,
    required this.customerCode,
    required this.buName,
    required this.customerName,
    required this.newOrderListData,
    this.isFromNewOrder,
  }) : super(key: key);

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  NewOrderController newOrderController = Get.put(NewOrderController());
  //final TextEditingController searchVariantController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  CalculationController _calculationController = Get.put(CalculationController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  int selectedToggleIndex = 0;
  ScrollController _scrollController = ScrollController();

  String? selectedBu;
  String? selectDivision;
  String? selectCategory;
  String? selectBrand;

  @override
  void initState() {
    _calculationController.setSelectedListItems([]);
    getDataOfNewOrderApiCall();
    getMoreData();
    super.initState();
  }

  // getDataOfNewOrderApiCall() async {
  //   printMe("Customer code new order here: ${widget.customerCode}");
  //   if (widget.newOrderListData.isEmpty) {
  //     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //       Widgets().loadingDataDialog(loadingText: "Loading data...");
  //     });
  //     await newOrderController.productByBU(bu: widget.buName, customerCode: widget.customerCode, division: "", category: "", subBrand: "", context: context);
  //     await newOrderController.focusedProduct(customerCode: widget.customerCode, selectBU: widget.buName);
  //     for (int i = 0; i < widget.newOrderListData.length; i++) {
  //       var items = widget.newOrderListData[i];
  //       newOrderController.updateProductSelection(items, true);
  //       printMe("New item name is : ${items.poductName}");
  //     }
  //   } else {
  //     if (widget.isFromNewOrder!) {
  //       SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //         Widgets().loadingDataDialog(loadingText: "Loading data...");
  //       });
  //       await newOrderController.productByBU(bu: widget.buName, customerCode: widget.customerCode, division: "", category: "", subBrand: "", context: context);
  //       await newOrderController.focusedProduct(customerCode: widget.customerCode, selectBU: widget.buName);
  //
  //       // for (int i = 0; i < widget.newOrderListData.length; i++) {
  //       //   var items = newOrderController.productByBUItems[i];
  //       //   newOrderController.updateProductSelection(items, true);
  //       // }
  //       for (int i = 0; i < widget.newOrderListData.length; i++) {
  //         var items = widget.newOrderListData[i];
  //         newOrderController.updateProductSelection(items, true);
  //         printMe("New item name is2 : ${items.poductName}");
  //       }
  //     } else {
  //       newOrderController.productByBUItems = [];
  //       newOrderController.productByBUItems = widget.newOrderListData;
  //     }
  //   }
  // }

  getDataOfNewOrderApiCall() async {
    printMe("Customer code new order here: ${widget.customerCode}");
    if (widget.newOrderListData.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Widgets().loadingDataDialog(loadingText: "Loading data...");
      });
      await newOrderController.productByBU(
        bu: widget.buName,
        customerCode: widget.customerCode,
        start: (newOrderController.currentPage - 1) * newOrderController.pageSize,
        end: newOrderController.currentPage * newOrderController.pageSize,
      );
      await newOrderController.focusedProduct(customerCode: widget.customerCode, selectBU: widget.buName);
    } else {
      if (widget.isFromNewOrder!) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Widgets().loadingDataDialog(loadingText: "Loading data...");
        });
        await newOrderController.productByBU(
          bu: widget.buName,
          customerCode: widget.customerCode,
          start: (newOrderController.currentPage - 1) * newOrderController.pageSize,
          end: newOrderController.currentPage * newOrderController.pageSize,
        );
        await newOrderController.focusedProduct(customerCode: widget.customerCode, selectBU: widget.buName);

        for (int i = 0; i < widget.newOrderListData.length; i++) {
          var items = newOrderController.productByBUItems[i];
          newOrderController.updateProductSelection(items, true);
        }
      } else {
        newOrderController.productByBUItems = [];
        newOrderController.productByBUItems = widget.newOrderListData;
      }
    }
  }

  getMoreData() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        newOrderController.loadMoreData(bu: widget.buName, customerCode: widget.customerCode, selectedIndex: selectedToggleIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          _calculationController.removeSelectedProductListItems(key: 'selectedProductListItems');
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            floatingActionButton: Widgets().notificationCartFAButton(
                notificationCount: _calculationController.cartItemCount,
                onTap: () async {
                  _calculationController.cartItemCount == "0"
                      ? Widgets().showToast("Cart is empty.")
                      : Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductList(
                            customerCode: widget.customerCode,
                            customerName: widget.customerName,
                            productByBUItems: controller.selectedDataList,
                          );
                        }));
                }),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                  Container(
                    decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                    child: Widgets().customLRPadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Widgets().verticalSpace(2.h),
                          Widgets().simpleTextWithIcon(
                              context: context,
                              bgColor: (selectedToggleIndex == 0) ? white : boulder,
                              titleName: 'Search Variant',
                              iconName: filter,
                              onTap: (selectedToggleIndex == 0)
                                  ? () async {
                                      await newOrderController.dropdownFilter().then((value) {
                                        showNewDialog();
                                      });
                                    }
                                  : () async {
                                      Widgets().showToast("Focus product search not available.");
                                    }),
                          Widgets().verticalSpace(1.h),
                          Widgets().textFieldWidgetWithSearchDelegate(
                              controller: controller.searchVariantController,
                              hintText: "Type here",
                              iconName: search,
                              fillColor: white,
                              keyBoardType: TextInputType.text,
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: SearchNewOrder(customerCode: widget.customerCode, buName: widget.buName),
                                );
                              }),
                          Widgets().verticalSpace(2.h),
                        ],
                      ),
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                          child: ToggleSwitch(
                            minWidth: 40.w,
                            minHeight: 6.h,
                            cornerRadius: 2.h,
                            activeBgColors: [
                              [alizarinCrimson],
                              [alizarinCrimson],
                            ],
                            customTextStyles: [
                              TextStyle(color: selectedToggleIndex == 0 ? white : codGray, fontSize: 12.sp),
                              TextStyle(color: selectedToggleIndex == 1 ? white : codGray, fontSize: 12.sp)
                            ],
                            inactiveBgColor: magnolia,
                            initialLabelIndex: selectedToggleIndex,
                            totalSwitches: 2,
                            labels: const ['All Product', 'Focused Product'],
                            radiusStyle: true,
                            onToggle: (index) {
                              setState(() {
                                selectedToggleIndex = index ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  (selectedToggleIndex == 0)
                      ? Widgets().customLRPadding(
                          child: controller.productByBUItems.isEmpty
                              ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
                              : ListView.builder(
                                  itemCount: controller.productByBUItems.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  //physics: const ScrollPhysics(),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    var items = controller.productByBUItems[index];
                                    return Widgets().newOrderListCard(
                                      //TODO : add card color dynamically
                                      cardColor: magnolia,
                                      iconName: pcDowmLightIcon,
                                      productDetailText: items.poductName.toString(),
                                      checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                                      skuCodeValue: items.sKUCode.toString(),
                                      availableQtyValue: items.availableQty.toString(),
                                      wareHouseValue: primaryOrderController.selectedWarehouse ?? '',
                                      lastOD: items.lastOD.toString(),
                                      context: context,
                                      initialValue: controller.isProductSelected(items),
                                      onChanged: (value) {
                                        controller.updateProductSelection(items, value!);
                                      },
                                    );
                                  },
                                ))
                      : Widgets().customLRPadding(
                          child: ListView.builder(
                          itemCount: controller.focusProductList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          //physics: const ScrollPhysics(),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var items = controller.focusProductList[index];
                            return Widgets().newOrderListCard(
                              //TODO : add card color dynamically
                              cardColor: magnolia,
                              iconName: pcDowmLightIcon,
                              productDetailText: items.poductName.toString(),
                              checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                              skuCodeValue: items.sKUCode.toString(),
                              availableQtyValue: items.availableQty.toString(),
                              wareHouseValue: primaryOrderController.selectedWarehouse ?? '',
                              lastOD: items.lastOD.toString(),
                              context: context,
                              initialValue: controller.isProductSelected(items),
                              onChanged: (value) {
                                controller.updateProductSelection(items, value!);
                              },
                            );
                          },
                        )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: GetBuilder<NewOrderController>(builder: (controller) {
            return StatefulBuilder(builder: (context1, myState) {
              return SizedBox(
                height: 40.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(closeIcon))
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select BU",
                              width: 30.w,
                              onChanged: (value) {
                                myState(() {
                                  controller.selectedBuValue = value;
                                });
                              },
                              itemValue: primaryOrderController.buList,
                              selectedValue: controller.selectedBuValue),
                        ),
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select Division",
                              width: 30.w,
                              onChanged: (value) {
                                myState(() {
                                  controller.selectDivisionValue = value;
                                });
                              },
                              itemValue: controller.selectDivision,
                              selectedValue: controller.selectDivisionValue),
                        ),
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select Category",
                              width: 30.w,
                              onChanged: (value) {
                                myState(() {
                                  controller.selectCategoryValue = value;
                                });
                              },
                              itemValue: controller.selectCategory,
                              selectedValue: controller.selectCategoryValue),
                        ),
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select Brand",
                              width: 30.w,
                              onChanged: (value) {
                                myState(() {
                                  controller.selectBrandValue = value;
                                });
                              },
                              itemValue: controller.selectBrand,
                              selectedValue: controller.selectBrandValue),
                        ),
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Widgets().filterByCard(
                      widget: Widgets().commonDropdownWith8sp(
                          hintText: "Select Warehouse",
                          width: 100.w,
                          onChanged: (value) {
                            myState(() {
                              primaryOrderController.selectedWarehouse = value;
                            });
                          },
                          itemValue: primaryOrderController.wareHouseName,
                          selectedValue: primaryOrderController.selectedWarehouse),
                    ),
                    Widgets().verticalSpace(1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Widgets().dynamicButton(
                            onTap: () async {
                              newOrderController.currentPage = 1;
                              Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                              await controller
                                  .productByBU(
                                customerCode: widget.customerCode,
                                bu: widget.buName,
                                start: (newOrderController.currentPage - 1) * newOrderController.pageSize,
                                end: newOrderController.currentPage * newOrderController.pageSize,
                              )
                                  .then((value) {
                                if (value == true) {
                                  myState(() {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  printMe("Please try again.....");
                                  Widgets().showToast("Please try again.");
                                }
                              });
                            },
                            height: 5.5.h,
                            width: 32.w,
                            buttonBGColor: alizarinCrimson,
                            titleText: 'Apply',
                            titleColor: white),
                        Widgets().horizontalSpace(2.w),
                        Widgets().dynamicButton(
                            onTap: () async {
                              newOrderController.currentPage = 1;
                              controller.selectDivisionValue = null;
                              controller.selectCategoryValue = null;
                              controller.selectBrandValue = null;
                              primaryOrderController.selectedWarehouse = null;
                              Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                              await controller
                                  .productByBU(
                                customerCode: widget.customerCode,
                                bu: widget.buName,
                                start: (newOrderController.currentPage - 1) * newOrderController.pageSize,
                                end: newOrderController.currentPage * newOrderController.pageSize,
                              )
                                  .then((value) {
                                if (value == true) {
                                  myState(() {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  printMe("Please try again.....");
                                  Widgets().showToast("Please try again.");
                                }
                              });
                            },
                            height: 5.5.h,
                            width: 32.w,
                            buttonBGColor: alizarinCrimson,
                            titleText: 'Clear',
                            titleColor: white),
                        Widgets().verticalSpace(1.5.h),
                      ],
                    ),
                  ],
                ),
              );
            });
          }));
        });
  }
}
