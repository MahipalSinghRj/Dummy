import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/AllInvoicesController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';

class AdminLedgerReport extends StatefulWidget {
  const AdminLedgerReport({Key? key}) : super(key: key);

  @override
  State<AdminLedgerReport> createState() => _AdminLedgerReportState();
}

class _AdminLedgerReportState extends State<AdminLedgerReport> {
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
                                Widgets().textWidgetWithW700(titleText: 'Ledger Report   (Phase 2)', fontSize: 11.sp),
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
                      padding: EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                      child: Column(
                        children: [
                          Widgets().verticalSpace(2.h),
                          Widgets().gradientContainerWithText(titleText: 'Opening Balance Rs. 1', gradientColor: [magicMint, oysterBay]),
                          Widgets().verticalSpace(2.h),
                          Widgets().gradientContainerWithText(titleText: 'Closing Balance Rs. -26,07,106', gradientColor: [pink, zumthor]),
                          Widgets().verticalSpace(2.h),
                        ],
                      ),
                    ),
                    Widgets().customLRPadding(
                        child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Widgets().ledgerReportListCard(
                            context: context,
                            invoiceNo: '2006',
                            transactionType: 'Invoice',
                            chequeNo: '121212121',
                            debit: 'Rs. 2001',
                            particulars: 'Enter ',
                            date: '26/05/2023',
                            credit: '1000');
                      },
                    )),
                    Widgets().verticalSpace(2.h),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
