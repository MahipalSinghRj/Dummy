import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../constants/colorConst.dart';
import '../utils/DateTimeUtils.dart';

class PromotionalActivityDialog extends StatefulWidget {
  const PromotionalActivityDialog({Key? key}) : super(key: key);

  @override
  State<PromotionalActivityDialog> createState() => _PromotionalActivityDialogState();
}

class _PromotionalActivityDialogState extends State<PromotionalActivityDialog> {
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedValue;
  String? selectedBu;
  final TextEditingController daterFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Widgets().customLRPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: Widgets().commonDecoration(bgColor: white, borderRadius: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.w, top: 1.5.h),
                    child: Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
                  ),
                  Widgets().verticalSpace(1.h),
                  Widgets().customLRPadding(
                    child: Column(
                      children: [
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdown(
                              hintText: "Selected City",
                              width: 100.w,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              itemValue: itemValue,
                              selectedValue: selectedValue),
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().datePicker(
                                context: context,
                                onTap: () {
                                  Get.back();
                                },
                                controller: daterFromController,
                                hintText: "Date from",
                                width: 43.w,
                                initialDateTime: selectedDate,
                                onDateTimeChanged: (value) {
                                  selectedDate = value;
                                  daterFromController.text = dateTimeUtils.formatDateTime(selectedDate);
                                }),
                            Widgets().datePicker(
                                context: context,
                                onTap: () {
                                  Get.back();
                                },
                                controller: dateToController,
                                hintText: "Date To",
                                width: 43.w,
                                initialDateTime: selectedDate,
                                onDateTimeChanged: (value) {
                                  selectedDate = value;
                                  dateToController.text = dateTimeUtils.formatDateTime(selectedDate);
                                }),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Widgets().dynamicButton(onTap: () {}, height: 4.h, width: 30.w, buttonBGColor: alizarinCrimson, titleText: 'Apply', titleColor: white),
                            Widgets().horizontalSpace(2.w),
                            Widgets().dynamicButton(onTap: () {}, height: 4.h, width: 30.w, buttonBGColor: alizarinCrimson, titleText: 'Clear', titleColor: white),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
