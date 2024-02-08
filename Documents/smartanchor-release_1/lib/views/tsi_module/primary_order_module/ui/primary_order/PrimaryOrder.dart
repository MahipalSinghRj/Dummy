import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/return_order_controller/ReturnOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../new_order/NewOrder.dart';
import '../no_order/NoOrder.dart';
import '../previous_order/PreviousOrder.dart';
import 'CustomerSearchDelegate.dart';

class PrimaryOrder extends StatefulWidget {
  final String navigationTag;

  const PrimaryOrder({Key? key, required this.navigationTag}) : super(key: key);

  @override
  State<PrimaryOrder> createState() => _PrimaryOrderState();
}

class _PrimaryOrderState extends State<PrimaryOrder> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  GlobalController globalController = Get.put(GlobalController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String? selectedValue;
  String? selectedBu;
  String? selectedState;
  String? selectedCity;
  String? selectedBeat;

  @override
  void initState() {
    fetchDataFunction();

    super.initState();
  }

  void handleTextChange(String text) {
    printMe("Search Text is : $text");
  }

  fetchDataFunction() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await primaryOrderController.getStatesForCustomers();
    await primaryOrderController.customerUnderTsi();
    await primaryOrderController.boolCustomersByBeat(false);
    //await primaryOrderController.getBeats(role: '',selectedCity: "");
    await getWareHouse();
  }

  getWareHouse() {
    for (int i = 0; i < primaryOrderController.wareHouseDataList.length; i++) {
      primaryOrderController.locationId = primaryOrderController.wareHouseDataList[i].locationId!;
      primaryOrderController.organizationId = primaryOrderController.wareHouseDataList[i].organizationId!;
      primaryOrderController.organizationName = primaryOrderController.wareHouseDataList[i].organizationName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrimaryOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          globalController.splashNavigation();
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(
                context,
                scaffoldKey,
                isShowBackButton: false,
              ),
              drawer: MainDrawer(context),
              // floatingActionButton: FloatingActionButton(onPressed: () async {
              //   await controller.getCustomersByBeat(beatCode: '', buName: '');
              // }),
              body: Container(
                width: 100.w,
                height: 100.h,
                color: alizarinCrimson,
                child: DraggableScrollableSheet(
                  initialChildSize: 01,
                  minChildSize: 01,
                  maxChildSize: 1,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      child: Container(
                        decoration: Widgets().boxDecorationTopLRRadius(color: white, topLeft: 2.h, topRight: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Widgets().draggableBottomSheetTopContainer(titleText: widget.navigationTag == "PrimaryOrder" ? "Primary Order" : "Secondary Order"),
                            Container(
                              decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                              child: Widgets().customLRPadding(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Business Unit", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                    hintText: "Select BU",
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBu = value;
                                      });
                                    },
                                    itemValue: controller.buList,
                                    selectedValue: selectedBu,
                                  ),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Select Location", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(1.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Widgets().commonDropdown(
                                          hintText: "Select State",
                                          width: (controller.isGridItemSelected) ? 45.w : 93.5.w,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedState = value;
                                            });
                                            if (selectedState != null) {
                                              primaryOrderController.getCustomersByState(stateName: selectedState!);
                                            }
                                          },
                                          itemValue: controller.statesList,
                                          selectedValue: selectedState),
                                      Visibility(
                                        visible: controller.isGridItemSelected == true,
                                        child: Widgets().commonDropdown(
                                            hintText: "Select Warehouse",
                                            width: 45.w,
                                            onChanged: (value) {
                                              setState(() {
                                                controller.selectedWarehouse = value;
                                                printMe("Selected warehouse : ${controller.selectedWarehouse}");
                                              });
                                            },
                                            itemValue: controller.wareHouseName,
                                            selectedValue: controller.selectedWarehouse),
                                      ),
                                    ],
                                  ),
                                  Widgets().verticalSpace(2.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Widgets().commonDropdown(
                                          hintText: "Select City",
                                          width: 45.w,
                                          onChanged: (value) async {
                                            setState(() {
                                              selectedCity = value;
                                            });

                                            await primaryOrderController.getBeats(role: '', selectedCity: selectedCity!, state: selectedState!);
                                          },
                                          itemValue: controller.citiesList,
                                          selectedValue: selectedCity),
                                      Widgets().commonDropdown(
                                          hintText: "Select Beat",
                                          width: 45.w,
                                          onChanged: (value) async {
                                            setState(() {
                                              selectedBeat = value;
                                            });

                                            await controller.getCustomersByBeat(beatCode: selectedBeat ?? '', buName: '');
                                            await controller.boolCustomersByBeat(true);
                                          },
                                          itemValue: controller.getBeatsList,
                                          selectedValue: selectedBeat),
                                    ],
                                  ),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Search Customer", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textFieldWidgetWithSearchDelegate(
                                      controller: searchController,
                                      hintText: "Search Customers",
                                      iconName: search,
                                      fillColor: white,
                                      keyBoardType: TextInputType.text,
                                      onTap: () {
                                        controller.isSelectedCustomerInfo(isSelectedInfo: false);
                                        showSearch(
                                          context: context,
                                          delegate: CustomerSearchDelegate(customerName: controller.customerName ?? '', customerCode: controller.customerCode ?? ''),
                                        );
                                      }),
                                  Widgets().verticalSpace(3.h),
                                ],
                              )),
                            ),
                            Widgets().customLRPadding(
                                child: Column(
                              children: [
                                Widgets().verticalSpace(2.h),
                                !controller.isGridItemSelected
                                    ? controller.selectCustomersByBeat == true
                                        ? controller.getCustomersByBeatList.isEmpty
                                            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found. Please try with another beat.", fontSize: 12.sp))
                                            : ListView.builder(
                                                itemCount: controller.getCustomersByBeatList.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  var items = controller.getCustomersByBeatList[index];
                                                  return InkWell(
                                                    onTap: () async {
                                                      setState(() {});
                                                      String customerCode = items.customerCode!;
                                                      printMe("Customer code after Api call : $customerCode");
                                                      await controller
                                                          .getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit)
                                                          .then((value) async {
                                                        if (value == true) {
                                                          controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                                          await primaryOrderController.getWarehouseForCustomer(
                                                            bu: primaryOrderController.businessUnit,
                                                            customerCode: customerCode,
                                                          );
                                                        } else {
                                                          Widgets().showToast("Something went wrong, please select customer again.");
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 0.h),
                                                      child: Container(
                                                        height: 6.h,
                                                        decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: titanWhite),
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 2.5.w),
                                                              child: Widgets().textWidgetWithW500WithCenterAlign(
                                                                  titleText: " ${items.customerName} / ${items.customerCode}", fontSize: 10.sp, textColor: codGray),
                                                            )),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                        : controller.customerNameAndCodeList.isEmpty
                                            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
                                            : ListView.builder(
                                                itemCount: controller.customerNameAndCodeList.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  var items = controller.customerNameAndCodeList[index];
                                                  return InkWell(
                                                    onTap: () async {
                                                      setState(() {});
                                                      String customerCode = items.customerCode!;
                                                      printMe("Customer code after Api call : $customerCode");
                                                      await controller
                                                          .getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit)
                                                          .then((value) async {
                                                        if (value == true) {
                                                          controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                                          await primaryOrderController.getWarehouseForCustomer(
                                                            bu: primaryOrderController.businessUnit,
                                                            customerCode: customerCode,
                                                          );
                                                        } else {
                                                          Widgets().showToast("Something went wrong, please select customer again.");
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 0.h),
                                                      child: Container(
                                                        height: 6.h,
                                                        decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: titanWhite),
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 2.5.w),
                                                              child: Widgets().textWidgetWithW500WithCenterAlign(
                                                                  titleText: "  ${items.customerName} / ${items.customerCode}", fontSize: 10.sp, textColor: codGray),
                                                            )),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                    : Container(),
                                Widgets().verticalSpace(2.h),
                                controller.isGridItemSelected
                                    ? Column(
                                        children: [
                                          Widgets().primaryOrderShopDetailCard(
                                            context: context,
                                            customerName: controller.customerName ?? "",
                                            customerCode: controller.customerCode ?? '',
                                            address: controller.address ?? '',
                                            mobileNo: controller.mobileNo ?? '',
                                            creditLimit: controller.creditLimit ?? '',
                                            lastDateOrder: controller.lastOrderDate ?? '',
                                            outstanding: controller.outstanding ?? '',
                                            overdue: controller.overdue ?? '',
                                            remark: controller.remarks ?? '',
                                          ),
                                          Widgets().verticalSpace(2.h),
                                          Widgets().selectOrderType(
                                              context: context,
                                              onTapNewOrder: () {
                                                if (controller.selectedWarehouse == null) {
                                                  Widgets().showToast("Please select Warehouse.");
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                    return NewOrder(
                                                      customerCode: controller.customerCode ?? "",
                                                      buName: controller.businessUnit,
                                                      customerName: controller.customerName ?? "",
                                                      newOrderListData: const [],
                                                    );
                                                  }));
                                                }
                                              },
                                              onTapNoOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return NoOrder(
                                                    customerName: controller.customerName!,
                                                    customerCode: controller.customerCode!,
                                                  );
                                                }));
                                              },
                                              onTapPreviousOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return PreviousOrder(
                                                    navigationTag: "PreviousOrder",
                                                    customerCode: controller.customerCode ?? '',
                                                    customerName: controller.customerName ?? "",
                                                  );
                                                }));
                                              },
                                              onTapReturnOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return PreviousOrder(
                                                    navigationTag: "ReturnOrder",
                                                    customerCode: controller.customerCode ?? '',
                                                    customerName: controller.customerName ?? "",
                                                  );
                                                }));
                                              }),
                                          Widgets().verticalSpace(2.h),
                                        ],
                                      )
                                    : Container(
                                        color: Colors.transparent,
                                        height: controller.isGridItemSelected ? 0.h : 25.h,
                                      )
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
      );
    });
  }
}
