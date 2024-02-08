import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/AllInvoicesController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';

class AllAdminRetailerInvoices extends StatefulWidget {
  const AllAdminRetailerInvoices({Key? key}) : super(key: key);

  @override
  State<AllAdminRetailerInvoices> createState() => _AllAdminRetailerInvoicesState();
}

class _AllAdminRetailerInvoicesState extends State<AllAdminRetailerInvoices> {
  final TextEditingController orderController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  AllInvoicesController allInvoicesController = Get.put(AllInvoicesController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;
  DateTime initialDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Widgets().textWidgetWithW700(titleText: 'Invoice Period   (Phase 2)', fontSize: 11.sp),
                                Widgets().dynamicButton(onTap: () {}, height: 4.h, width: 30.w, buttonBGColor: alizarinCrimson, titleText: "Download", titleColor: white),
                              ],
                            ),
                            Widgets().verticalSpace(2.h),
                            Widgets().invoicesPeriodExpantionTile(
                              context: context,
                              onApply: () {},
                              dropDownWidget: Widgets().commonDropdown(
                                selectedValue: selectedBu,
                                hintText: "Selected BU",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: itemValue,
                              ),
                              datePickerWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Widgets().datePicker(
                                      context: context,
                                      onTap: () {
                                        Get.back();
                                      },
                                      controller: dateFromController,
                                      width: 40.w,
                                      hintText: 'Date from',
                                      initialDateTime: initialDateTime,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          dateFromController.text = dateTimeUtils.formatDateTime(value);
                                        });
                                      }),
                                  Widgets().datePicker(
                                      context: context,
                                      onTap: () {
                                        Get.back();
                                      },
                                      controller: dateToController,
                                      width: 40.w,
                                      hintText: 'Date Tto',
                                      initialDateTime: initialDateTime,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          dateToController.text = dateTimeUtils.formatDateTime(value);
                                        });
                                      }),
                                ],
                              ),
                            ),
                            Widgets().verticalSpace(2.h),
                          ],
                        ),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: Text(
                        'All Invoice',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: veryLightBoulder),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Widgets().customLRPadding(
                      child: ListView.builder(
                        itemCount: allInvoicesController.dataList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var items = allInvoicesController.dataList[index];
                          return Widgets().allInvoicesCardList(
                              context: context,
                              initialValue: items.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  items.isSelected = value!;
                                  if (value) {
                                    allInvoicesController.selectedItems2.add(items);
                                  } else {
                                    allInvoicesController.selectedItems2.remove(items);
                                  }
                                });
                              },
                              businessUnit: items.businessUnit,
                              date: items.date,
                              referenceOrder: items.salesOrder,
                              salesOrder: items.salesOrder,
                              transactionType: items.transactionType);
                        },
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
