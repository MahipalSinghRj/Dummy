import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/widgets.dart';

import '../constants/assetsConst.dart';
import '../constants/colorConst.dart';

class NewWidgets {
  //Previous order detail
  Widget previousOrderListCardNew(
      {required BuildContext context,
      required String productDetailText,
      required String itemCode,
      required Function() editIconOnTap,
      required Function() deleteIconOnTap,
      required String qtyValue,
      bool hideEditButton = false,
      required String totalPriceValue}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .8.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardTopRowNew(
                  context: context,
                  itemCode: itemCode,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [
                      if (!hideEditButton) ...[
                        InkWell(onTap: editIconOnTap, child: Image.asset(editIcon)),
                        Widgets().horizontalSpace(1.h),
                      ],
                      if (!hideEditButton) ...[
                        InkWell(onTap: deleteIconOnTap, child: Image.asset(deleteIcon)),
                        Widgets().horizontalSpace(1.h),
                      ],
                    ],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Widgets().verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                children: [
                  Widgets().productListRowDetails(context: context, title: 'Qty', subTitle: qtyValue),
                  const Spacer(),
                  Text(
                    totalPriceValue,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            Widgets().verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  Widget productListCardTopRowNew({
    required BuildContext context,
    required String iconName,
    required String productDetailText,
    required String itemCode,
    required Widget iconWidget,
  }) {
    return Row(
      children: [
        Widgets().horizontalSpace(3.w),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productDetailText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: codGray,
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                itemCode,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: codGray,
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        const Spacer(),
        iconWidget
      ],
    );
  }

  Widget datePicker(
      {required BuildContext context,
      required Function() onTap,
      required TextEditingController controller,
      String? hintText,
      double? width,
      required DateTime initialDateTime,
      required Function(DateTime) onDateTimeChanged}) {
    return InkWell(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: DateTime(2010),
          lastDate: DateTime.now(),
        );

        if (selectedDate != null && selectedDate != initialDateTime) {
          onDateTimeChanged(selectedDate);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(1.h),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 13,
              offset: Offset(0, -4),
              spreadRadius: 8,
            )
          ],
        ),
        height: 6.h,
        width: width,
        child: Row(
          children: [
            SizedBox(width: 3.w),
            Expanded(
              child: SizedBox(
                width: 5.w,
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.start,
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText ?? "Hint Text",
                    hintStyle: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: SvgPicture.asset(
                dateTime,
                height: 2.3.h,
                width: 2.3.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget datePickerWithNoPreviousDate({
    required BuildContext context,
    required Function() onTap,
    required TextEditingController controller,
    String? hintText,
    double? width,
    required DateTime initialDateTime,
    required Function(DateTime) onDateTimeChanged,
  }) {
    return InkWell(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: DateTime.now(), // Set the minimum date to the current date
          lastDate: DateTime.now().add(const Duration(days: 365)), // Allow selection for the next year
        );

        if (selectedDate != null && selectedDate != initialDateTime) {
          onDateTimeChanged(selectedDate);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(1.h),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 13,
              offset: Offset(0, -4),
              spreadRadius: 8,
            )
          ],
        ),
        height: 6.h,
        width: width,
        child: Row(
          children: [
            SizedBox(width: 3.w),
            Expanded(
              child: SizedBox(
                width: 5.w,
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.start,
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText ?? "Hint Text",
                    hintStyle: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: SvgPicture.asset(
                dateTime,
                height: 2.3.h,
                width: 2.3.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showSimpleDialog({required String contentString, bool hideCancelButton = false, required Function onTapCancel, required Function onTapOk}) {
    return Get.dialog(
      AlertDialog(
        title: Widgets().textWidgetWithW500(titleText: "Alert", fontSize: 14.sp, textColor: codGray),
        content: Text(contentString),
        actions: [
          if (!hideCancelButton)
            ElevatedButton(
                onPressed: () async {
                  onTapCancel();
                },
                child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () async {
                onTapOk();
              },
              child: const Text("Ok"))
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget textFieldWidgetWithSearch({
    required TextEditingController controller,
    required String hintText,
    required String iconName,
    required TextInputType keyBoardType,
    required Color fillColor,
    required Function(String) onChanged,
    required Function() onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 13,
          offset: Offset(0, -4),
          spreadRadius: 8,
        )
      ]),
      height: 6.5.h,
      child: TextFormField(
        controller: controller..selection = TextSelection.fromPosition(TextPosition(offset: controller.text.toString().length)),
        keyboardType: keyBoardType,
        textAlign: TextAlign.start,
        readOnly: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 10.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          fillColor: fillColor,
          suffixIcon: InkWell(onTap: onTap, child: SizedBox(child: Image.asset(iconName))),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
