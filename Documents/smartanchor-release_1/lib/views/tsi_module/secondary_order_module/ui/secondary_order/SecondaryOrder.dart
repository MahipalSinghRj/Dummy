import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/secondary_order_controller/SecondaryOrderController.dart';

import '../../../../../../common/AppBar.dart';
import '../../../../../../common/Drawer.dart';
import '../../../../../../common/widgets.dart';
import '../../../../../../constants/colorConst.dart';
import '../../../../../../debug/printme.dart';
import '../retailer_new_order/RetailerNewOrder.dart';
import '../retailer_no_order/RetailerNoOrder.dart';
import '../retailer_previous_order/RetailerPreviousOrder.dart';
import 'SecondaryCustomerSearch.dart';

class SecondaryOrder extends StatefulWidget {
  const SecondaryOrder({
    Key? key,
  }) : super(key: key);

  @override
  State<SecondaryOrder> createState() => _SecondaryOrderState();
}

class _SecondaryOrderState extends State<SecondaryOrder> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  SecondaryController secondaryController = Get.put(SecondaryController());
  GlobalController globalController = Get.put(GlobalController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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
    await secondaryController.retailerFieldsFn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecondaryController>(builder: (controller) {
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
                            Widgets().draggableBottomSheetTopContainer(titleText: "Secondary Order"),
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
                                      hintText: "Select Business Unit",
                                      onChanged: (value) {
                                        setState(() {
                                          controller.selectedBu = value;
                                        });
                                      },
                                      itemValue: controller.selectBuList,
                                      selectedValue: controller.selectedBu),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Select Location", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Select State",
                                      onChanged: (value) {
                                        setState(() {
                                          controller.selectedState = value;
                                        });
                                      },
                                      itemValue: controller.selectStateList,
                                      selectedValue: controller.selectedState),
                                  Widgets().verticalSpace(2.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Widgets().commonDropdown(
                                          hintText: "Select City",
                                          width: 45.w,
                                          onChanged: (value) {
                                            setState(() {
                                              controller.selectedCity = value;
                                            });
                                          },
                                          itemValue: controller.selectCityList,
                                          selectedValue: controller.selectedCity),
                                      Widgets().commonDropdown(
                                          hintText: "Select Beat",
                                          width: 45.w,
                                          onChanged: (value) async {
                                            setState(() {
                                              controller.selectedBeat = value;
                                            });

                                            await controller.retailersByBeatFn(beat: controller.selectedBeat ?? '');
                                            await controller.isSecondaryCustomersByBeat(true);
                                          },
                                          itemValue: controller.beatList,
                                          selectedValue: controller.selectedBeat),
                                    ],
                                  ),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW500(titleText: "Search Retailer", fontSize: 11.sp, textColor: codGray),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textFieldWidgetWithSearchDelegate(
                                      controller: searchController,
                                      hintText: "Search Retailer",
                                      iconName: search,
                                      fillColor: white,
                                      keyBoardType: TextInputType.text,
                                      onTap: () {
                                        controller.isSecondaryCustomerInfo(isSelectedInfo: false);
                                        showSearch(
                                          context: context,
                                          delegate: SecondaryCustomerSearch(),
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
                                    ? controller.selectSecCustomersByBeat
                                        ? controller.retailerDetailsByBeatList.isEmpty
                                            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found. Please try with another beat.", fontSize: 12.sp))
                                            : ListView.builder(
                                                itemCount: controller.retailerDetailsByBeatList.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  var items = controller.retailerDetailsByBeatList[index];
                                                  return InkWell(
                                                    onTap: () async {
                                                      setState(() {});
                                                      String retailerCode = items.retailerCode!;
                                                      controller.retailerCode = retailerCode;
                                                      printMe("Customer Retailer Code : $retailerCode");
                                                      await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                                                        controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                                                      });
                                                    },
                                                    child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"),
                                                  );
                                                },
                                              )
                                        : controller.newRetailersDetailsDataList.isEmpty
                                            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
                                            : ListView.builder(
                                                itemCount: controller.newRetailersDetailsDataList.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  var items = controller.newRetailersDetailsDataList[index];
                                                  return InkWell(
                                                      onTap: () async {
                                                        setState(() {});
                                                        String retailerCode = items.retailerCode!;
                                                        controller.retailerCode = retailerCode;
                                                        printMe("Customer Retailer Code : $retailerCode");
                                                        await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                                                          controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                                                        });
                                                      },
                                                      child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"));
                                                },
                                              )
                                    : Container(),
                                Widgets().verticalSpace(2.h),
                                controller.isGridItemSelected
                                    ? Column(
                                        children: [
                                          Widgets().secondaryOrderShopDetailCard(
                                            context: context,
                                            customerName: controller.retailerName,
                                            customerCode: controller.retailerCode ?? '',
                                            address: controller.address,
                                            mobileNo: controller.mobile,
                                            lastDateOrder: controller.lastOrder,
                                            beat: controller.beat,
                                            remark: controller.remark,
                                          ),
                                          Widgets().verticalSpace(2.h),
                                          Widgets().selectOrderType3Item(
                                              context: context,
                                              onTapNewOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return RetailerNewOrder(
                                                    retailerName: controller.retailerName,
                                                    retailerCode: controller.retailerCode ?? "",
                                                    buName: controller.selectedBu ?? '',
                                                    retailerNewOrderList: [],
                                                    isFromNewOrder: false,
                                                    emailAddress: controller.emailId,
                                                  );
                                                }));
                                              },
                                              onTapPreviousOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return RetailerPreviousOrder(
                                                    retailerName: controller.retailerName,
                                                    retailerCode: controller.retailerCode ?? "",
                                                    emailAddress: controller.emailId,
                                                  );
                                                }));
                                              },
                                              onTapNoOrder: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                  return RetailerNoOrder(
                                                    retailerName: controller.retailerName,
                                                    retailerCode: controller.retailerCode ?? "",
                                                    buName: controller.selectedBu ?? '',
                                                    emailAddress: controller.emailId,
                                                  );
                                                }));
                                              }),
                                          Widgets().verticalSpace(2.h),
                                        ],
                                      )
                                    : Container(color: Colors.transparent, height: controller.isGridItemSelected ? 0.h : 25.h)
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
