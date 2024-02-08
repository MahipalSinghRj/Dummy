import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../new_order/NewOrder.dart';
import '../no_order/NoOrder.dart';
import '../previous_order/PreviousOrder.dart';
import '../return_order/ReturnOrder.dart';

class CustomerSearchDelegate extends SearchDelegate<String> {
  String customerCode;
  String customerName;
  CustomerSearchDelegate({Key? key, required this.customerCode, required this.customerName});
  PrimaryOrderController primaryOrderController = Get.find();
  GlobalController globalController = Get.put(GlobalController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = primaryOrderController.customerNameAndCodeList.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    final searchResultsWithBeat = primaryOrderController.getCustomersByBeatList.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<PrimaryOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: Column(
          children: [
            Widgets().verticalSpace(2.h),
            controller.selectCustomersByBeat == true
                ? searchResultsWithBeat.isEmpty
                    ? Center(child: Widgets().textWidgetWithW700(titleText: "No data available.", fontSize: 12.sp))
                    : ListView.builder(
                        itemCount: searchResultsWithBeat.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var items = searchResultsWithBeat[index];
                          return InkWell(
                            onTap: () async {
                              String customerCode = items.customerCode!;
                              printMe("Customer code is : $customerCode");
                              await controller.getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit).then((value) async {
                                printMe("Value is : $value");

                                if (value == true) {
                                  controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                  await primaryOrderController.getWarehouseForCustomer(
                                    bu: primaryOrderController.businessUnit,
                                    customerCode: customerCode,
                                  );
                                  printMe("Customer code after Api call : $customerCode");
                                } else {
                                  Widgets().showToast("Something went wrong, please select customer again.");
                                }
                                Navigator.of(context).pop();
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
                : searchResults.isEmpty
                    ? Center(child: Widgets().textWidgetWithW700(titleText: "No data available.", fontSize: 12.sp))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var items = searchResults[index];
                          return InkWell(
                            onTap: () async {
                              String customerCode = items.customerCode!;
                              printMe("Customer code is : $customerCode");
                              await controller.getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit).then((value) async {
                                printMe("Value is : $value");

                                if (value == true) {
                                  controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                  await primaryOrderController.getWarehouseForCustomer(
                                    bu: primaryOrderController.businessUnit,
                                    customerCode: customerCode,
                                  );
                                  printMe("Customer code after Api call : $customerCode");
                                } else {
                                  Widgets().showToast("Something went wrong, please select customer again.");
                                }
                                Navigator.of(context).pop();
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
                      ),
            Widgets().verticalSpace(2.h),
            Widgets().verticalSpace(1.h),
          ],
        ));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = primaryOrderController.customerNameAndCodeList.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    final suggestionsWithBeat = primaryOrderController.getCustomersByBeatList.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<PrimaryOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: Column(
          children: [
            Widgets().verticalSpace(2.h),
            controller.selectCustomersByBeat == true
                ? suggestionsWithBeat.isEmpty
                    ? Center(child: Widgets().textWidgetWithW700(titleText: "No data available.", fontSize: 12.sp))
                    : ListView.builder(
                        itemCount: suggestionsWithBeat.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var items = suggestionsWithBeat[index];
                          return InkWell(
                            onTap: () async {
                              String customerCode = items.customerCode!;
                              //String customerCode = "${controller.customerCode1}";
                              printMe("Customer code is1 : $customerCode");
                              await controller.getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit).then((value) async {
                                printMe("Value is : $value");
                                if (value == true) {
                                  controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                  await primaryOrderController.getWarehouseForCustomer(
                                    bu: primaryOrderController.businessUnit,
                                    customerCode: customerCode,
                                  );
                                } else {
                                  Widgets().showToast("Something went wrong, please select customer again.");
                                }
                                Navigator.of(context).pop();
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
                : suggestions.isEmpty
                    ? Center(child: Widgets().textWidgetWithW700(titleText: "No data available.", fontSize: 12.sp))
                    : ListView.builder(
                        itemCount: suggestions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var items = suggestions[index];
                          return InkWell(
                            onTap: () async {
                              String customerCode = items.customerCode!;
                              printMe("Customer code is1 : $customerCode");
                              await controller.getCustomerInfo(customerCode: customerCode, businessUnit: controller.businessUnit).then((value) async {
                                printMe("Value is : $value");
                                if (value == true) {
                                  controller.isSelectedCustomerInfo(isSelectedInfo: true);
                                  await primaryOrderController.getWarehouseForCustomer(
                                    bu: primaryOrderController.businessUnit,
                                    customerCode: customerCode,
                                  );
                                } else {
                                  Widgets().showToast("Something went wrong, please select customer again.");
                                }
                                Navigator.of(context).pop();
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
                      ),
            Widgets().verticalSpace(2.h),
            Widgets().verticalSpace(1.h),
          ],
        ));
      }),
    );
  }
}
