import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../constants/assetsConst.dart';
import '../constants/colorConst.dart';
import '../constants/labelConst.dart';
import '../global/common_controllers/GlobalController.dart';
import '../utils/Validators.dart';
import '../views/beat_module/models/responseModels/GetEventsAllocationResponse.dart';
import '../views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'AppBar.dart';
import 'Drawer.dart';

class Widgets {
  //Elevated Button
  ElevatedButton dynamicButton(
      {required Function() onTap, required double height, required double width, required Color buttonBGColor, required String titleText, required Color titleColor}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: buttonBGColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.2.h),
        ),
      ),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(
          titleText,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
      ),
    );
  }

  //Increase decrease Button
  Widget increaseDecreaseButton({required Function() onTapDecrease, required Function() onTapInCrease, required String qtyText}) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5.h), color: alizarinCrimson),
      child: Row(
        children: [
          InkWell(
            onTap: onTapDecrease,
            child: SizedBox(
              height: 2.h,
              width: 3.w,
              child: SvgPicture.asset(
                decreaseSvg,
                height: .7.h,
              ),
            ),
          ),
          horizontalSpace(7.w),
          Text(qtyText, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: white)),
          horizontalSpace(7.w),
          InkWell(
            onTap: onTapInCrease,
            child: SvgPicture.asset(
              increaseSvg,
              height: 2.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget increaseDecreaseButtonWithTextField({
    required Function() onTapDecrease,
    required Function() onTapInCrease,
    required TextEditingController qtyTextController,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5.h), color: alizarinCrimson),
      child: Row(
        children: [
          InkWell(
            onTap: onTapDecrease,
            child: SizedBox(
              height: 2.h,
              width: 3.w,
              child: SvgPicture.asset(
                decreaseSvg,
                height: .7.h,
              ),
            ),
          ),
          horizontalSpace(7.w),
          Container(
            width: 15.w,
            height: 2.h,
            child: TextField(
              controller: qtyTextController..selection = TextSelection.fromPosition(TextPosition(offset: qtyTextController.text.toString().length)),
              //qtyTextController,
              cursorColor: white,
              //keyboardType: TextInputType.number,
              keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: white,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 1.2.h),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          horizontalSpace(7.w),
          InkWell(
            onTap: onTapInCrease,
            child: SvgPicture.asset(
              increaseSvg,
              height: 2.h,
            ),
          ),
        ],
      ),
    );
  }

  //Dynamic button with icon
  ElevatedButton iconElevationButton(
      {required Function() onTap,
      required String icon,
      required double width,
      double? height,
      required String titleText,
      double? textSize,
      required bool isBackgroundOk,
      required Color bgColor,
      Color? iconColor,
      Color? textColor}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: isBackgroundOk ? bgColor : white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
      ),
      child: Container(
        height: height ?? 6.5.h,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: isBackgroundOk ? Colors.transparent : alizarinCrimson),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: iconColor,
              height: 2.5.h,
            ),
            horizontalSpace(3.w),
            elevatedButtonTitleText(titleText: titleText, textSize: textSize, textColor: textColor),
          ],
        ),
      ),
    );
  }

  Widget elevatedButtonTitleText({required String titleText, double? textSize, Color? textColor}) {
    return Text(
      titleText,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }

  Widget elevatedButtonTitleTextNew({required String titleText, required Function() onTapInCreaseDecrease}) {
    return InkWell(
      onTap: onTapInCreaseDecrease,
      child: Text(titleText, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: white)),
    );
  }

  //Text widget
  Widget textWidgetWithW700({required String titleText, required double fontSize}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: fontSize, letterSpacing: .3),
      textAlign: TextAlign.start,
    );
  }

  //Text widget
  Widget colorTextWidgetWithW700({required String titleText, required double fontSize, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: fontSize, letterSpacing: .3),
      textAlign: TextAlign.start,
    );
  }

  //Text widget
  Widget textWidgetWithW500({required String titleText, required double fontSize, TextAlign? align, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: fontSize),
      textAlign: align ?? TextAlign.start,
    );
  }

  Widget textWidgetWithW500WithCenterAlign({required String titleText, required double fontSize, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: fontSize),
      textAlign: TextAlign.start,
    );
  }

  //Text widget with under line
  Widget underLineTextWidgetWithW500({required String titleText, required double fontSize, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        decoration: TextDecoration.underline,
      ),
      textAlign: TextAlign.start,
    );
  }

  //Text widget
  Widget textWidgetWithW400({required String titleText, required double fontSize, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: fontSize),
      textAlign: TextAlign.start,
    );
  }

  Widget textWidgetWithW400Max1({required String titleText, required double fontSize, required Color textColor}) {
    return Text(
      titleText,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: fontSize),
      textAlign: TextAlign.start,
    );
  }

  //Dynamic login/otp/attendance card field
  Widget buildTopContainer(String titleText) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 55.h,
        decoration: ShapeDecoration(
          color: coralRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.h),
              topRight: Radius.circular(7.h),
            ),
          ),
        ),
        child: customPadding(
            top: 2.1.h,
            child: Text(
              titleText.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            )),
      ),
    );
  }

  Widget loginCard(String titleText, Widget widget) {
    return Container(
      //height: 55.h,
      decoration: ShapeDecoration(
        color: coralRed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.h),
            topRight: Radius.circular(7.h),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customPadding(
              top: 2.1.h,
              bottom: 2.h,
              child: Text(
                titleText.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              )),
          widget
        ],
      ),
    );
  }

  //Bottom container
  Widget buildBottomContainer(Widget filedWidget) {
    return Container(
      height: 48.h,
      decoration: ShapeDecoration(
        color: pippin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.h),
            topRight: Radius.circular(7.h),
          ),
        ),
      ),
      child: filedWidget,
    );
  }

  //Title text with star
  Widget titleText({required String titleText, required bool isStar, required double fontSize}) {
    return RichText(
      text: TextSpan(
        text: titleText,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: codGray,
        ),
        children: [
          TextSpan(
            text: isStar ? ' *' : "",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: alizarinCrimson,
            ),
          ),
        ],
      ),
    );
  }

  //Text form field
  Widget textFieldWidget(
      {required TextEditingController controller,
      required String hintText,
      required String iconName,
      required TextInputType keyBoardType,
      required Color fillColor,
      Function()? onTap,
      Function(String?)? onChanged}) {
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
        controller: controller,
        keyboardType: keyBoardType,
        onChanged: (value) async {
          if (onChanged != null) {
            onChanged(value);
          }
        },
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
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: SizedBox(
                //height: 10,
                //width: 10,
                child: Image.asset(
              iconName,
            )),
          ),
        ),
      ),
    );
  }

// Text Form Filed
  Widget textFieldWidgetWithOutlineBorder(
      {TextEditingController? controller,
      String? hintText,
      bool? isEnable,
      String? Function(String?)? onValidate,
      Widget? suffixWidget,
      TextInputType? keyBoardType,
      Color? fillColor}) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(color: dottedBorderColor),
      // ),
      // height: 6.5.h,
      child: TextFormField(
        controller: controller,
        validator: onValidate,
        keyboardType: null,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.5.h), borderSide: BorderSide(color: dottedBorderColor)),
          hintStyle: TextStyle(fontSize: 10.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dottedBorderColor),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dottedBorderColor),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          enabled: isEnable ?? true,
          fillColor: fillColor,
          suffixIconConstraints: const BoxConstraints(),
          suffixIcon: suffixWidget == null ? null : Padding(padding: const EdgeInsets.all(8.0), child: suffixWidget),
        ),
      ),
    );
  }

  //Text form field
  Widget previousOrderSearchTextFieldWidget(
      {required TextEditingController controller,
      required String hintText,
      required String iconName,
      required TextInputType keyBoardType,
      required Color fillColor,
      required Function() onTap}) {
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
        controller: controller,
        keyboardType: keyBoardType,
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
          suffixIcon: (iconName.toString() == '')
              ? const SizedBox(
                  height: 5,
                  width: 5,
                )
              : SizedBox(child: Image.asset(iconName)),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget textFieldWidgetWithSearchDelegate({
    required TextEditingController controller,
    required String hintText,
    required String iconName,
    required TextInputType keyBoardType,
    required Color fillColor,
    //required Function(String) onChanged,
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
        controller: controller,
        keyboardType: keyBoardType,
        readOnly: true,
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
          suffixIcon: SizedBox(
              child: Image.asset(
            iconName,
          )),
        ),
        //onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }

  //Text form field
  Widget textFieldWidgetWithOrder(
      {required TextEditingController controller, required String hintText, required String iconName, required TextInputType keyBoardType, required Color fillColor}) {
    return SizedBox(
      height: 6.5.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 10.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dottedBorderColor),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          fillColor: fillColor,
          suffixIcon: Image.asset(iconName),
        ),
      ),
    );
  }

  Widget textFieldUserName(
      {required TextEditingController controller,
      required String hintText,
      TextInputType? keyBoardType,
      required bool obscure,
      required bool readOnly,
      required Function(String) onFieldSubmitted,
      required Function() onTap,
      required Widget iconDataWidget}) {
    return Container(
      height: 8.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoardType,
        // onChanged: onChanged,
        obscureText: obscure,
        readOnly: readOnly,
        onFieldSubmitted: onFieldSubmitted,
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter a user name.';
        //   } else if (value.length < 16) {
        //     return 'User name must be at least 16 characters long.';
        //   }
        //   return null;
        // },
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          fillColor: readOnly ? Colors.white38 : Colors.white,
          //errorText: errorText,
          suffixIcon: InkWell(
            onTap: onTap,
            child: iconDataWidget,
          ),
        ),
      ),
    );
  }

  Widget textFieldPassword(
      {required TextEditingController controller,
      required String hintText,
      TextInputType? keyBoardType,
      required bool obscure,
      required bool readOnly,
      required Function(String) onChanged,
      required Function() onTap,
      required var onTapTextField,
      required Widget iconDataWidget}) {
    return Container(
      height: 8.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoardType,
        // onChanged: onChanged,
        obscureText: obscure,
        readOnly: readOnly,
        onFieldSubmitted: onChanged,
        onTap: onTapTextField,

        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          fillColor: readOnly ? Colors.white38 : Colors.white,
          suffixIcon: InkWell(
            onTap: onTap,
            child: iconDataWidget,
          ),
        ),
      ),
    );
  }

  //Forgot password text field
  Widget forgotPasswordTextFieldWidget(
      {required TextEditingController controller,
      required String hintText,
      required bool obscure,
      required Function(String) onSubmit,
      required Function() onTap,
      required Widget iconDataWidget}) {
    return SizedBox(
      height: 7.h,
      child: TextFormField(
        controller: controller,
        // keyboardType: keyBoardType,
        obscureText: obscure,
        //readOnly: readOnly,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: InkWell(onTap: onTap, child: iconDataWidget),
        ),
      ),
    );
  }

  //Text form field without suffix icon
  Widget textFieldWithoutIcon(TextEditingController controller, String hintText, TextInputType keyBoardType,
      {Function(String?)? validator, int? maxLength, String? counterText, bool showValidator = false, bool disableHeight = false}) {
    return SizedBox(
      height: disableHeight ? null : 6.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoardType,
        validator: (String? val) {
          if (validator != null) {
            return validator(val);
          }
          return null;
        },
        maxLength: maxLength,
        inputFormatters: showValidator ? [UppercaseInputFormatter()] : null,
        decoration: InputDecoration(
          errorMaxLines: null,
          hintMaxLines: null,
          helperMaxLines: null,
          hintText: hintText,
          contentPadding: disableHeight ? EdgeInsets.symmetric(horizontal: 1.5.h) : null,
          counterText: counterText,
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
          fillColor: Colors.white,
        ),
      ),
    );
  }

  //Text form field without suffix icon
  Widget textFieldWithGeoCoordinatesContainer(
      {required TextEditingController controller, required String hintText, required Function() onTapGeoCoordinate, Function(String?)? validator}) {
    return SizedBox(
      height: 6.h,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        validator: (String? val) {
          if (validator != null) {
            return validator(val);
          }
          return null;
        },
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
            fillColor: Colors.white,
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: geoCoordinatesButton(titleText: 'View on Map', onTapGeoCoordinate: onTapGeoCoordinate),
            )),
      ),
    );
  }

  //Bottom text with left arrow
  Widget textWithArrowIcon({required IconData icon, required String textTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: curiousBlue,
        ),
        SizedBox(width: 1.h),
        Text(
          textTitle,
          style: TextStyle(fontSize: 12.sp, color: curiousBlue, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  //Bottom text with Right arrow
  Widget textWithRightArrowIcon({required IconData icon, required String textTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textTitle,
          style: TextStyle(fontSize: 12.sp, color: curiousBlue, fontWeight: FontWeight.w400),
        ),
        SizedBox(width: 1.h),
        Icon(
          icon,
          color: curiousBlue,
        ),
      ],
    );
  }

  //Gradient tile
  Widget gradientTile({required BuildContext context, required bool isGradientColor, required String iconName, required String iconText, required String valueText}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(2.5.h),
      decoration: BoxDecoration(
          gradient: isGradientColor
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [magicMint, oysterBay],
                  stops: const [-.10, 0.84],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [pink, zumthor],
                  stops: const [-.10, 0.84],
                ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
          ),
          SizedBox(width: 2.0.h),
          Text(
            iconText,
            style: TextStyle(fontSize: 10.sp, color: codGray, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            valueText,
            style: TextStyle(fontSize: 10.sp, color: codGray, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  //Date picker
  Widget datePicker(
      {required BuildContext context,
      required Function() onTap,
      required TextEditingController controller,
      String? hintText,
      double? width,
      required DateTime initialDateTime,
      required Function(DateTime) onDateTimeChanged}) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(color: white, borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: Column(
                  children: [
                    Center(
                        child: SizedBox(
                      height: 30.h,
                      child: CupertinoDatePicker(
                        minimumYear: 2010,
                        minimumDate: DateTime(2020, 4, 1),
                        // maximumYear: DateTime.now().year,
                        // maximumDate: DateTime.now(),
                        initialDateTime: initialDateTime,
                        onDateTimeChanged: onDateTimeChanged,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    )),
                    Widgets().dynamicButton(onTap: onTap, height: 5.5.h, width: 22.0.h, buttonBGColor: alizarinCrimson, titleText: submit, titleColor: white),
                    SizedBox(height: 2.2.h),
                  ],
                )),
          ),
          barrierColor: Colors.transparent,
          // isDismissible: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
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
                      decoration: InputDecoration.collapsed(hintText: hintText ?? "Hint Text", hintStyle: TextStyle(fontSize: 10.sp)),
                    ))),
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: SvgPicture.asset(
                dateTime,
                height: 2.3.h,
                width: 2.3.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget horizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget verticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget drawerItemBox(VoidCallback onPressed, Widget widget) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFECECEC)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: widget),
    );
  }

  Widget expansionDrawerItemBox(VoidCallback onPressed, Widget widget) {
    return Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFECECEC)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: widget);
  }

  Widget expansionDrawerItemBox1(VoidCallback onPressed, Widget widget) {
    return Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: widget);
  }

  Widget expansionDrawerItemBox2(VoidCallback onPressed, Widget widget) {
    return Container(
        // padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: widget);
  }

  //Dropdown button
  Widget commonDropdown({void Function(String?)? onChanged, double? width, required String hintText, String? selectedValue, List<String>? itemValue}) {
    return Container(
      height: 6.h,
      width: width ?? 100.w,
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Center(
        child: DropdownButton<String>(
            underline: DropdownButtonHideUnderline(child: Container()),
            isExpanded: true,
            isDense: true,
            focusColor: alizarinCrimson,
            iconSize: 3.h,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            value: selectedValue,
            style: TextStyle(color: codGray),
            iconEnabledColor: codGray,
            items: itemValue!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 10.sp),
            ),
            onChanged: onChanged),
      ),
    );
  }

  Widget commonTextOfDropdown({
    double? width,
    required String titleText,
    required double fontSize,
    required Color textColor,
  }) {
    return Container(
      height: 6.h,
      width: width ?? 100.w,
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Text(
          titleText,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: fontSize),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget commonDropdownWith8sp({void Function(String?)? onChanged, double? width, required String hintText, String? selectedValue, List<String>? itemValue}) {
    return Container(
      height: 6.h,
      width: width ?? 100.w,
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Center(
        child: DropdownButton<String>(
            underline: DropdownButtonHideUnderline(child: Container()),
            isExpanded: true,
            isDense: true,
            focusColor: alizarinCrimson,
            iconSize: 3.h,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            value: selectedValue,
            style: TextStyle(color: codGray),
            iconEnabledColor: codGray,
            items: itemValue!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 8.sp),
            ),
            onChanged: onChanged),
      ),
    );
  }

  //Dropdown button daily monthly and yearly status
  Widget dayMonthYearlyStatusDropdown(
      {void Function(String?)? onChanged, double? width, Color? backgroundColor, required String hintText, String? selectedValue, List<String>? itemValue}) {
    return Container(
      height: 4.5.h,
      width: width ?? 100.w,
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? magicMint,
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: Center(
        child: DropdownButton<String>(
            underline: DropdownButtonHideUnderline(child: Container()),
            isExpanded: true,
            isDense: true,
            focusColor: alizarinCrimson,
            iconSize: 3.h,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            value: selectedValue,
            style: TextStyle(color: codGray),
            iconEnabledColor: white,
            items: itemValue!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 10.sp),
            ),
            onChanged: onChanged),
      ),
    );
  }

  //Primary Order Shop Detail Card
  Container primaryOrderShopDetailCard({
    required BuildContext context,
    required String customerName,
    required String customerCode,
    required String address,
    required String mobileNo,
    required String creditLimit,
    required String lastDateOrder,
    required String outstanding,
    required String overdue,
    required String remark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5.h),
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: textWidgetWithW700(titleText: customerName, fontSize: 9.sp),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: textWidgetWithW400(titleText: "(Customer Code : $customerCode)", fontSize: 9.sp, textColor: curiousBlue),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          customLRPadding(
            child: Column(
              children: [
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Mobile No. ', subTitle: mobileNo),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Credit Limit ', subTitle: creditLimit),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Last Order Date ', subTitle: lastDateOrder),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetailsWithColor(context: context, title: 'Overdue ', subTitle: overdue),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Last order remark ', subTitle: remark),
                Widgets().verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Secondary Order Shop Detail Card
  Container secondaryOrderShopDetailCard({
    required BuildContext context,
    required String customerName,
    required String customerCode,
    required String address,
    required String mobileNo,
    required String lastDateOrder,
    required String beat,
    required String remark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5.h),
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: textWidgetWithW700(titleText: customerName, fontSize: 9.sp),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: textWidgetWithW400(titleText: "(Retailer Code : $customerCode)", fontSize: 9.sp, textColor: curiousBlue),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          customLRPadding(
            child: Column(
              children: [
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Mobile No. ', subTitle: mobileNo),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Last Order Date ', subTitle: lastDateOrder),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat ', subTitle: beat),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Remark ', subTitle: remark),
                Widgets().verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Primary Order Shop Detail Card
  Container primaryOrderShopDetailCardWith5Item({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: Text(
                    "Jai Ram Electronic Shop",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: Text(
                    "(Customer Code : 252154)",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: curiousBlue, fontWeight: FontWeight.w400, fontSize: 9.sp, letterSpacing: .3),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          primaryOrderRowDetails(context: context, title: 'Address', subTitle: 'Krishna Nagar'),
          Widgets().verticalSpace(1.h),
          primaryOrderRowDetails(context: context, title: 'Mobile No. ', subTitle: '9958848072'),
          Widgets().verticalSpace(1.h),
          primaryOrderRowDetails(context: context, title: 'Credit Limit ', subTitle: '654000.00'),
          Widgets().verticalSpace(1.h),
          primaryOrderRowDetails(context: context, title: 'Last Order Date ', subTitle: '12/05/2023'),
          Widgets().verticalSpace(1.h),
          primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: '145564.00'),
          Widgets().verticalSpace(2.h),
        ],
      ),
    );
  }

  //Primary Order Shop Detail Card
  Container customerOnMapAddressCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String address,
    required String beat,
    required String city,
    required String state,
    required Function() viewDetailsOnTap,
    required Function() noteDetailsOnTap,
    required Function() callingOnTap,
    required Function() locationOnTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5.h),
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                Widgets().verticalSpace(2.h),
                InkWell(onTap: viewDetailsOnTap, child: textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue)),
                verticalSpace(1.h),
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  await noteDetailsOnTap();
                },
                child: SvgPicture.asset(noteDetailsIcon, height: 4.h),
              ),
              verticalDivider8(),
              InkWell(
                onTap: () async {
                  callingOnTap();
                },
                child: SvgPicture.asset(callingIcon, height: 4.h),
              ),
              verticalDivider8(),
              InkWell(
                onTap: () async {
                  locationOnTap();
                },
                child: SvgPicture.asset(locationIcon, height: 4.h),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Primary Order Shop Detail Card
  Widget nearestPatnerAddressDetailList({
    required BuildContext context,
    required String shopName,
    required String customerCode,
    required String address,
    required String beat,
    required String distance,
    required Function() calling,
    required Function() location,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Container(
        decoration: commonDecoration(bgColor: white, borderRadius: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: textWidgetWithW700(titleText: shopName, fontSize: 9.sp),
                  ),
                  //const SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue),
                  ),
                ],
              ),
            ),
            Divider(color: lightBoulder, thickness: 1),
            customLRPadding(
              child: Column(
                children: [
                  primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                  Widgets().verticalSpace(1.h),
                  primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                  Widgets().verticalSpace(1.h),
                  primaryOrderRowDetails(context: context, title: 'Distance', subTitle: distance),
                  verticalSpace(1.h),
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(onTap: calling, child: SvgPicture.asset(callingIcon, height: 4.h)),
                verticalDivider8(),
                InkWell(onTap: location, child: SvgPicture.asset(locationSvg, height: 4.h)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget primaryOrderRowDetails({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            title,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: textWidgetWithW500(titleText: subTitle, fontSize: 9.sp, textColor: codGray),
        ),
      ],
    );
  }

  Widget productCatelogueRowDetails({required BuildContext context, required String title, Color? titleColor, Color? subTitleColor, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            title,
            style: TextStyle(color: titleColor ?? codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: textWidgetWithW500(titleText: subTitle, fontSize: 9.sp, textColor: subTitleColor ?? codGray),
        ),
      ],
    );
  }

  Widget primaryOrderRowDetailsWithColor({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            title,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: textWidgetWithW500(titleText: subTitle, fontSize: 9.sp, textColor: alizarinCrimson),
        ),
      ],
    );
  }

  //Row with status color text
  Widget rowWithStatusColorText({required BuildContext context, required String title, required String subTitle, required Color textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            title,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: textWidgetWithW500(titleText: subTitle, fontSize: 9.sp, textColor: textColor),
        ),
      ],
    );
  }

//Row items with 500 font weight
  Widget items500FWRowDetails({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: textWidgetWithW500(titleText: title, fontSize: 9.sp, textColor: codGray),
        ),
        textWidgetWithW500(titleText: ':', fontSize: 9.sp, textColor: codGray),
        Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            subTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget primaryOrderRowDetailsWithStatus(
      {required BuildContext context, required String title, required String subTitle, Function? onVerifyClick, required String verify}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            title,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        Text(
          subTitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 9.sp, letterSpacing: .3),
          textAlign: TextAlign.start,
        ),
        horizontalSpace(1.h),
        TextButton(
          onPressed: () {
            if (onVerifyClick != null) {
              onVerifyClick();
            }
          },
          child: Text(
            verify,
            style: TextStyle(color: alizarinCrimson, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  //Comment Container
  Widget commentContainer({required String hintText, required TextEditingController commentController}) {
    return Container(
      height: 15.h,
      padding: EdgeInsets.only(left: 1.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.5.h),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: commentController,
            //keyboardType: TextInputType.text,

            maxLines: null,
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
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  //Select order type block

  Widget selectOrderType3Item({
    required BuildContext context,
    required Function() onTapNewOrder,
    required Function() onTapPreviousOrder,
    required Function() onTapNoOrder,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Center(
              child: Text(
                "Secondary Activity",
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
                // textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              columnSelectOrderTypeFourBlock(titleText: "New\nOrder", iconPath: cartSvgIcon, onTap: onTapNewOrder),
              verticalDivider16(),
              columnSelectOrderTypeFourBlock(titleText: "Previous\nOrder", iconPath: previousOrderIcon, onTap: onTapPreviousOrder),
              verticalDivider16(),
              columnSelectOrderTypeFourBlock(titleText: "No\nOrder", iconPath: noOrderIcon, onTap: onTapNoOrder),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectOrderType({
    required BuildContext context,
    required Function() onTapNewOrder,
    required Function() onTapPreviousOrder,
    required Function() onTapNoOrder,
    required Function() onTapReturnOrder,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Center(
              child: Text(
                "Primary Activity",
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
                // textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              columnSelectOrderTypeFourBlock(titleText: "New Order", iconPath: cartSvgIcon, onTap: onTapNewOrder),
              verticalDivider16(),
              columnSelectOrderTypeFourBlock(titleText: "Previous Order", iconPath: previousOrderIcon, onTap: onTapPreviousOrder),
              verticalDivider16(),
              columnSelectOrderTypeFourBlock(titleText: "No Order", iconPath: noOrderIcon, onTap: onTapNoOrder),
              verticalDivider16(),
              columnSelectOrderTypeFourBlock(titleText: "Return Order", iconPath: returnOrderIcon, onTap: onTapReturnOrder)
            ],
          ),
        ],
      ),
    );
  }

/*
  Widget columnSelectOrderType({required String iconPath, required String titleText, required String secondTitleText, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 16.w,
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 4.h,
            ),
            Widgets().verticalSpace(1.5.h),
            Text(
              titleText,
              style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
            ),
            Text(
              secondTitleText,
              style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
            )
          ],
        ),
      ),
    );
  }
*/

  Widget columnSelectOrderTypeFourBlock({required String iconPath, required String titleText, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 16.w,
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 4.h,
            ),
            Widgets().verticalSpace(1.5.h),
            Text(
              titleText,
              style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalDivider8() {
    return Container(
      //height: 16.h,
      height: 8.h,
      width: 1.0,
      color: lightBoulder,
    );
  }

  Widget verticalDivider16() {
    return Container(
      height: 16.h,
      //height: 8.h,
      width: 1.0,
      color: lightBoulder,
    );
  }

  Widget verticalDivider10() {
    return Container(
      height: 10.h,
      //height: 8.h,
      width: 1.0,
      color: lightBoulder,
    );
  }

  Widget verticalDividerInGradientRow() {
    return Container(
      //height: 5.h,
      width: 1.0,
      color: codGray,
    );
  }

  Widget horizontalDivider() {
    return Container(height: 1, color: lightBoulder);
  }

  Widget horizontalDividerWhite() {
    return Container(height: 1, color: white);
  }

  Widget verticalDivider() {
    return Container(
      //height: 16.h,
      height: 60.h,
      width: 1.0,
      color: lightBoulder,
    );
  }

  Widget verticalDivider1() {
    return Container(
      //height: 16.h,

      width: 1.0,
      color: lightBoulder,
    );
  }

  //Product list card
  Widget productListCard(
      {required BuildContext context,
      required String productDetailText,
      required Function() deleteOnTap,
      required String skuCodeValue,
      required String mrpValue,
      required String sqValue,
      required String availableQtyValue,
      required String dlpValue,
      required String mqValue,
      required String lastOdValue,
      required Function() onTapDecrease,
      required Function() onTapInCrease,
      //required String qtyText,
      required TextEditingController qtyTextController,
      required Function(String) onChanged,
      required String totalValueText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
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
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            customLPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(2.h),
                  richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                  verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'MRP', subTitle: " ₹ $mrpValue"),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'SQ', subTitle: sqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Available Qty', subTitle: availableQtyValue),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'DLP', subTitle: " ₹ $dlpValue"),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'MQ', subTitle: mqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Last OD', subTitle: lastOdValue),
                        ],
                      ),
                      verticalSpace(2.h)
                    ],
                  ),
                  verticalSpace(2.h),
                  Row(
                    children: [
                      //increaseDecreaseButton(onTapDecrease: onTapDecrease, onTapInCrease: onTapInCrease, qtyText: qtyText),
                      increaseDecreaseButtonWithTextField(
                          onTapInCrease: onTapInCrease, onTapDecrease: onTapDecrease, qtyTextController: qtyTextController, onChanged: onChanged),
                      horizontalSpace(3.w),
                      Text(
                        totalValueText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                  verticalSpace(2.h),
                  Text(
                    "Total Ordered QTY = $sqValue * ${qtyTextController.text}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: codGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  verticalSpace(2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Retailer product list
  Widget retailerProductListCard(
      {required BuildContext context,
      required String productDetailText,
      required Function() deleteOnTap,
      required String skuCodeValue,
      required String sqValue,
      required String availableQtyValue,
      required String mqValue,
      required String lastOdValue,
      required Function() onTapDecrease,
      required Function() onTapInCrease,
      //required String qtyText,
      required TextEditingController qtyTextController,
      required Function(String) onChanged,
      required String totalValueText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
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
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            customLPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(2.h),
                  richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                  verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //productListRowDetails(context: context, title: 'MRP', subTitle: " ₹ $mrpValue"),
                          //verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'SQ', subTitle: sqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Last OD', subTitle: lastOdValue),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //productListRowDetails(context: context, title: 'DLP', subTitle: " ₹ $dlpValue"),
                          // verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'MQ', subTitle: mqValue),
                          verticalSpace(1.h),
                        ],
                      ),
                      verticalSpace(2.h)
                    ],
                  ),
                  verticalSpace(2.h),
                  Row(
                    children: [
                      //   increaseDecreaseButton(
                      //       onTapDecrease: onTapDecrease,
                      //       onTapInCrease: onTapInCrease,
                      //       qtyText: qtyText),
                      increaseDecreaseButtonWithTextField(
                          onTapInCrease: onTapInCrease, onTapDecrease: onTapDecrease, qtyTextController: qtyTextController, onChanged: onChanged),
                      horizontalSpace(3.w),
                      Text(
                        totalValueText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                  verticalSpace(2.h),
                  Text(
                    "Total Ordered QTY = $sqValue * ${qtyTextController.text}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: codGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  verticalSpace(2.h)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Edit return order list card
  Widget editReturnOrder(
      {required BuildContext context,
      required String productDetailText,
      required Function() deleteOnTap,
      required String skuCodeValue,
      required String mrpValue,
      required String sqValue,
      required String availableQtyValue,
      required String dlpValue,
      required String mqValue,
      required String lastOdValue,
      required Function() onTapDecrease,
      required Function() onTapInCrease,
      required String qtyText,
      required String totalValueText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
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
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            customLPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(2.h),
                  richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                  verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'MRP', subTitle: mrpValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'SQ', subTitle: sqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Available Qty', subTitle: availableQtyValue),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'DLP', subTitle: "$dlpValue"),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'MQ', subTitle: mqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Last OD', subTitle: lastOdValue),
                        ],
                      ),
                      verticalSpace(2.h)
                    ],
                  ),
                  verticalSpace(2.h),
                  Row(
                    children: [
                      increaseDecreaseButton(onTapDecrease: onTapDecrease, onTapInCrease: onTapInCrease, qtyText: qtyText),
                      horizontalSpace(3.w),
                      Text(
                        totalValueText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                  verticalSpace(2.h)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Return order list card
  Widget returnOrderListCard(
      {required BuildContext context,
      required String productDetailText,
      required Function() deleteOnTap,
      required String skuCodeValue,
      required String mrpValue,
      required String dlpValue,
      required String totalValue,
      required Function() onTapDecrease,
      required Function() onTapInCrease,
      required String qtyText,
      required String totalValueText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                verticalSpace(1.h),
                Row(
                  children: [
                    productListRowDetails(context: context, title: 'MRP', subTitle: mrpValue),
                    const Spacer(),
                    productListRowDetails(context: context, title: 'DLP', subTitle: dlpValue),
                    verticalSpace(2.h)
                  ],
                ),
                verticalSpace(2.h),
                Row(
                  children: [
                    //quantityElevationButton(onTapDecrease: () {}, onTapInCrease: () {}, qtyText: ''),
                    increaseDecreaseButton(onTapDecrease: onTapDecrease, onTapInCrease: onTapInCrease, qtyText: qtyText),
                    horizontalSpace(3.w),
                    Text(
                      totalValue,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  //Edit order details card
  Widget editOrderListCard({
    required BuildContext context,
    required String productDetailText,
    required Function() deleteOnTap,
    required String orderIdValue,
    required String qtyValue,
    required String amount,
    required String totalValue,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextInRow(titleName: 'Order ID ', titleValue: orderIdValue, fontColor: curiousBlue),
                verticalSpace(1.h),
                Row(
                  children: [
                    productListRowDetails(context: context, title: 'Qty', subTitle: qtyValue),
                    const Spacer(),
                    productListRowDetails(context: context, title: "Amount", subTitle: amount),
                    verticalSpace(2.h)
                  ],
                ),
                verticalSpace(2.h),
                Row(
                  children: [
                    increaseDecreaseButton(onTapDecrease: () {}, onTapInCrease: () {}, qtyText: '1'),
                    horizontalSpace(3.w),
                    Text(
                      totalValue,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  Widget productListCardTopRow({
    required BuildContext context,
    required String iconName,
    required String productDetailText,
    required Widget iconWidget,
  }) {
    return Row(
      children: [
        Widgets().horizontalSpace(3.w),
        // Container(
        //   width: 8.w,
        //   height: 4.h,
        //   decoration: ShapeDecoration(
        //     color: white,
        //     shape: RoundedRectangleBorder(
        //       side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
        //       borderRadius: BorderRadius.circular(.7.h),
        //     ),
        //   ),
        //   child: Image.asset(iconName),
        // ),
        // Widgets().horizontalSpace(3.w),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Text(
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
        ),
        const Spacer(),
        iconWidget
      ],
    );
  }

  Widget productListCardWithoutIcon({required BuildContext context, required String iconName, required String productDetailText, required Widget iconWidget}) {
    return Row(
      children: [
        // Widgets().horizontalSpace(3.w),
        // Container(
        //   width: 8.w,
        //   height: 4.h,
        //   decoration: ShapeDecoration(
        //     color: white,
        //     shape: RoundedRectangleBorder(
        //       side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
        //       borderRadius: BorderRadius.circular(.7.h),
        //     ),
        //   ),
        //   child: Container(),
        // ),
        Widgets().horizontalSpace(3.w),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Text(
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
        ),
        const Spacer(),
        iconWidget
      ],
    );
  }

  Widget productListRowDetails({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          " :",
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.center,
        ),
        //Widgets().horizontalSpace(1.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * .2,
          child: Text(
            subTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w400,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget previousOrderListRowDetails({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            ":",
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            subTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w400,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  //Stock details row widget
  Widget stockDetailsRowDetails({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          ":",
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        Text(
          subTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w400,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

//Beat Allocation - Bulk Upload with status color
  Widget beatAllocationTextWithStatus({required BuildContext context, required String title, required String subTitle, required Color statusColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          ":",
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.center,
        ),
        Widgets().horizontalSpace(1.h),
        Text(
          subTitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.w400,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  //Previous order detail
  Widget previousOrderListCard(
      {required BuildContext context,
      required String productDetailText,
      required Function() editIconOnTap,
      required Function() deleteIconOnTap,
      required String qtyValue,
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
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [
                      InkWell(onTap: editIconOnTap, child: Image.asset(editIcon)),
                      horizontalSpace(1.h),
                      InkWell(onTap: deleteIconOnTap, child: Image.asset(deleteIcon)),
                      horizontalSpace(1.h)
                    ],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                children: [
                  productListRowDetails(context: context, title: 'Qty', subTitle: qtyValue),
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
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  //New order detail
  Widget newOrderListCard({
    required BuildContext context,
    required Color cardColor,
    required bool initialValue,
    required void Function(bool?) onChanged,
    required String productDetailText,
    required Color checkBoxBGColor,
    required String skuCodeValue,
    required String availableQtyValue,
    required String wareHouseValue,
    required String lastOD,
    required String iconName,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardWithoutIcon(
                  context: context,
                  iconName: iconName,
                  productDetailText: productDetailText,
                  iconWidget: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(.5.h)),
                    activeColor: alizarinCrimson,
                    side: BorderSide(width: 9, color: checkBoxBGColor, style: BorderStyle.solid),
                    value: initialValue,
                    onChanged: onChanged,
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                    verticalSpace(1.h),
                    productListRowDetails(context: context, title: 'Available Qty ', subTitle: availableQtyValue),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productListRowDetails(context: context, title: 'WH ', subTitle: wareHouseValue),
                    verticalSpace(1.h),
                    productListRowDetails(context: context, title: 'Last OD ', subTitle: lastOD),
                  ],
                ),
                verticalSpace(2.h)
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  //New order detail
  Widget retailerNewOrderListCard({
    required BuildContext context,
    required Color cardColor,
    required bool initialValue,
    required void Function(bool?) onChanged,
    required String productDetailText,
    required Color checkBoxBGColor,
    required String skuCodeValue,
    required String availableQtyValue,
    required String district,
    required String lastOD,
    required String iconName,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardWithoutIcon(
                  context: context,
                  iconName: iconName,
                  productDetailText: productDetailText,
                  iconWidget: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(.5.h)),
                    activeColor: alizarinCrimson,
                    side: BorderSide(width: 9, color: checkBoxBGColor, style: BorderStyle.solid),
                    value: initialValue,
                    onChanged: onChanged,
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                    verticalSpace(1.h),
                    productListRowDetails(context: context, title: 'Available Qty ', subTitle: availableQtyValue),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productListRowDetails(context: context, title: 'Disti ', subTitle: district),
                    verticalSpace(1.h),
                    productListRowDetails(context: context, title: 'Last OD ', subTitle: lastOD),
                  ],
                ),
                verticalSpace(2.h)
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  //Return order Product List Card
  Widget returnOrderProductListCard({
    required BuildContext context,
    required bool initialValue,
    required void Function(bool?) onChanged,
    required String productDetailText,
    required String skuCodeValue,
    required String availableQtyValue,
    required Color cardColor,
    required Color checkBoxColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5.h)),
        elevation: 5,
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(.5.h)),
                    activeColor: alizarinCrimson,
                    side: BorderSide(width: 9, color: checkBoxColor, style: BorderStyle.solid),
                    value: initialValue,
                    onChanged: onChanged,
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                horizontalSpace(2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                    verticalSpace(1.h),
                    productListRowDetails(context: context, title: 'Available Qty ', subTitle: availableQtyValue),
                  ],
                ),
                verticalSpace(2.h)
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  //Single Target period date tile
  Container singleTargetPeriodDateTile({
    required BuildContext context,
    required String periodDate,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            horizontalSpace(2.w),
            SvgPicture.asset(calender, color: Colors.red),
            SizedBox(width: 2.w),
            textWidgetWithW700(titleText: "Period Date : $periodDate", fontSize: 10.sp)
          ],
        ),
      ),
    );
  }

  //New Order User Name Details Tile
  Container newOrderUserNameDetailsTile({required BuildContext context, required String titleName, required String titleValue}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            horizontalSpace(2.w),
            Expanded(flex: 4, child: textWidgetWithW700(titleText: titleName, fontSize: 10.sp)),
            Expanded(flex: 4, child: textWidgetWithW400(titleText: titleValue, fontSize: 10.sp, textColor: curiousBlue)),
          ],
        ),
      ),
    );
  }

  //Text with icon in row
  Row simpleTextWithIcon({required BuildContext context, required String titleName, required String iconName, required Function() onTap, required Color bgColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          titleName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp),
          textAlign: TextAlign.start,
        ),
        //const SizedBox(width: 5),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(.6.h),
            decoration: commonDecoration(borderRadius: .7.h, bgColor: bgColor),
            child: SvgPicture.asset(
              iconName,
              height: 3.h,
            ),
          ),
        )
      ],
    );
  }

  //Total order value tile
  Container totalOrderValueTile({required BuildContext context, required String iconName, required String titleValue}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [pink, zumthor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            horizontalSpace(5.w),
            SvgPicture.asset(
              iconName,
              height: 3.h,
            ),
            horizontalSpace(1.h),
            Text(
              "Total Order Value",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                titleValue,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 14.sp, letterSpacing: .3),
                textAlign: TextAlign.end,
              ),
            ),
            horizontalSpace(5.w),
          ],
        ),
      ),
    );
  }

  //Total order value tile
  Container totalOrderQTYTileWithBGColor({required BuildContext context, required String iconName, required String titleValue}) {
    return Container(
      decoration: BoxDecoration(
        color: secondLightBlue1,
        border: Border.all(color: dottedBorderColor),
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            horizontalSpace(5.w),
            SvgPicture.asset(
              iconName,
              height: 3.h,
            ),
            horizontalSpace(4.w),
            Text(
              "Total Order Qty :",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: codGray,
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                titleValue,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 12.sp),
                textAlign: TextAlign.end,
              ),
            ),
            horizontalSpace(5.w),
          ],
        ),
      ),
    );
  }

  //Total order value tile
  Container totalOrderQTYTile({required BuildContext context, required String iconName, required String titleValue}) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: twilightBlue,
        border: Border.all(color: pattensBlue, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                'Savalia Kantilal',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
                textAlign: TextAlign.start,
              ),
            ),
            //const Spacer(),
            horizontalSpace(5.w),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                '($titleValue)',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: curiousBlue, fontWeight: FontWeight.w400, fontSize: 9.sp, letterSpacing: .3),
                textAlign: TextAlign.start,
              ),
            ),
            // horizontalSpace(5.w),
          ],
        ),
      ),
    );
  }

  //Card with 5 elevation
  Card filterByCard({required Widget widget}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: widget,
    );
  }

  Container totalOrderValueTile1(BuildContext context, String icon, String titleText, String subTitleText, List<Color> colors) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SvgPicture.asset(workingIcon),
                horizontalSpace(1.h),
                SizedBox(
                  child: Text(
                    titleText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                subTitleText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: codGray,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Tile with white background color and two text and one icon row
  Container tileWithWhiteBGAndThreeItemRow({required BuildContext context, required String icon, required String titleText, required String subTitleText}) {
    return Container(
      decoration: commonDecoration(bgColor: white, borderRadius: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SvgPicture.asset(icon),
                horizontalSpace(1.h),
                SizedBox(
                  child: Text(
                    titleText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Text(
                subTitleText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: codGray,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Order details card with status
  Widget orderDetailsCardWithStatus({
    required BuildContext context,
    required int orderId,
    required String statusTitle,
    required String orderDateValue,
    required String orderQtyValue,
    required String orderValue,
    required String buttonName,
    required Color statusColor,
    required Function() onTapOrderAgain,
    required Function() onTapOrderDetail,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  richTextInRow(titleName: 'Order No. ', titleValue: "$orderId", fontColor: curiousBlue),
                  statusContainer(statusColor: statusColor, statusTitle: statusTitle)
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 8.w,
                      height: 4.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(.7.h),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(.7.h),
                        child: SvgPicture.asset(
                          cartSvgIcon,
                          height: 3.h,
                          //width: 8.w,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(1.h),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        previousOrderListRowDetails(context: context, title: 'Order Date ', subTitle: orderDateValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Qty ', subTitle: orderQtyValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Value ', subTitle: orderValue),
                        verticalSpace(1.h),
                        Row(
                          children: [
                            dynamicButton(onTap: onTapOrderAgain, height: 4.h, width: 30.w, buttonBGColor: alizarinCrimson, titleText: buttonName, titleColor: white),
                            horizontalSpace(2.h),
                            InkWell(
                              onTap: onTapOrderDetail,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidgetWithW500(titleText: 'Order Detail', fontSize: 11.sp, textColor: curiousBlue),
                                  horizontalSpace(2.w),
                                  SvgPicture.asset(rightArrow, height: 1.5.h)
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            verticalSpace(1.h),
          ],
        ),
      ),
    );
  }

  //Order details card with status of Retailer previous order
  Widget retailerPreviousOrderCard({
    required BuildContext context,
    required String orderId,
    required String statusTitle,
    required String orderDateValue,
    required String orderQtyValue,
    required String orderValue,
    required String buttonName,
    required Color statusColor,
    required Function() onTapOrderAgain,
    required Function() onTapOrderDetail,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  richTextInRow(titleName: 'Order Number ', titleValue: orderId, fontColor: curiousBlue),
                  statusContainer(statusColor: statusColor, statusTitle: statusTitle)
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 8.w,
                      height: 4.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(.7.h),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(.7.h),
                        child: SvgPicture.asset(
                          cartSvgIcon,
                          height: 3.h,
                          //width: 8.w,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(1.h),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        previousOrderListRowDetails(context: context, title: 'Order Date ', subTitle: orderDateValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Qty ', subTitle: orderQtyValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Value ', subTitle: orderValue),
                        verticalSpace(1.h),
                        Row(
                          children: [
                            dynamicButton(onTap: onTapOrderAgain, height: 4.h, width: 30.w, buttonBGColor: alizarinCrimson, titleText: buttonName, titleColor: white),
                            horizontalSpace(2.h),
                            InkWell(
                              onTap: onTapOrderDetail,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidgetWithW500(titleText: 'Order Detail', fontSize: 11.sp, textColor: curiousBlue),
                                  horizontalSpace(2.w),
                                  SvgPicture.asset(rightArrow, height: 1.5.h)
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            verticalSpace(1.h),
          ],
        ),
      ),
    );
  }

  //Order details card with status
  Widget allInvoicesCardList({
    required BuildContext context,
    required Function(bool?) onChanged,
    required bool initialValue,
    required String businessUnit,
    required String transactionType,
    required String date,
    required String referenceOrder,
    required String salesOrder,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5.h)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customLRPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                richTextInRow(titleName: 'Business Unit ', titleValue: businessUnit, fontColor: curiousBlue),
                SvgPicture.asset(download, height: 2.5.h),
                Checkbox(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                  activeColor: alizarinCrimson,
                  side: BorderSide(width: 9, color: checkBoxColor, style: BorderStyle.solid),
                  value: initialValue,
                  onChanged: onChanged,
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          verticalSpace(2.h),
          customLRPadding(
            child: Column(
              children: [
                primaryOrderRowDetails(context: context, title: 'Transaction Type', subTitle: transactionType),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Date', subTitle: date),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Reference No', subTitle: referenceOrder),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Sales Order', subTitle: salesOrder),
              ],
            ),
          ),
          verticalSpace(2.h),
        ],
      ),
    );
  }

  //Order details card with status
  Widget retailerDealerDetailsCard({
    required BuildContext context,
    required String dealerDetails,
    required String powerDealer,
    required String iaqDealer,
    required String lightingDealer,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5.h)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                richTextInRow(
                  titleName: 'Dealer Detials ',
                  titleValue: dealerDetails,
                  fontColor: codGray,
                ),
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          verticalSpace(2.h),
          customLRPadding(
            child: Column(
              children: [
                items500FWRowDetails(context: context, title: 'Power Dealer', subTitle: powerDealer),
                verticalSpace(1.h),
                items500FWRowDetails(context: context, title: 'IAQ Dealer', subTitle: iaqDealer),
                verticalSpace(1.h),
                items500FWRowDetails(context: context, title: 'Lighting Dealer', subTitle: lightingDealer),
              ],
            ),
          ),
          verticalSpace(2.h),
        ],
      ),
    );
  }

  //Get in touch card list
  Widget getInTouchCardList({
    required BuildContext context,
    required String circleTitleText,
    required String headingName,
    required String businessUnit,
    required String role,
    required String emailID,
    required String mobileNo,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: waterlooColor,
                  child: Center(child: textWidgetWithW500(titleText: circleTitleText, fontSize: 11.sp, textColor: white)),
                ),
                horizontalSpace(3.w),
                textWidgetWithW500(titleText: headingName, fontSize: 11.sp, textColor: codGray),
                const Spacer(),
                SvgPicture.asset(callingIcon)
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Role', subTitle: role),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Email ID', subTitle: emailID),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Mobile No.', subTitle: mobileNo),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Status container
  Widget statusContainer({required Color statusColor, required String statusTitle}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(
        statusTitle,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
      )),
    );
  }

  //Rich text
  Widget richTextInRow({required String titleName, required String titleValue, required Color fontColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: titleName,
            style: TextStyle(
              color: fontColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ': ',
            style: TextStyle(
              color: fontColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: titleValue,
            style: TextStyle(
              color: fontColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  //Location map address
  Widget getAddressBlock(
      {required BuildContext context,
      required String iconPath,
      required String titleText,
      required String dateTime,
      required String address,
      required String lat,
      required String long}) {
    return Container(
      height: 15.h,
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, height: 5.h),
                Widgets().verticalSpace(1.5.h),
                textWidgetWithW700(titleText: titleText, fontSize: 13.sp),
              ],
            ),
          ),
          verticalDivider16(),
          horizontalSpace(3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateTime,
                style: TextStyle(color: alizarinCrimson, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
              ),
              verticalSpace(1.h),
              SizedBox(
                width: MediaQuery.of(context).size.width * .15.w,
                child: Text(
                  address,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 8.sp, letterSpacing: .3),
                  textAlign: TextAlign.start,
                ),
              ),
              verticalSpace(1.h),
              Text(
                lat,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
              ),
              verticalSpace(1.h),
              Text(
                long,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 9.sp, letterSpacing: .3),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getAddressBlockCompressed(
      {required BuildContext context,
      required String iconPath,
      required String titleText,
      required String dateTime,
      required String address,
      required String lat,
      required String long}) {
    return Container(
      height: 8.h,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: commonDecoration(borderRadius: 10, bgColor: white),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 2.h,
                ),
                verticalSpace(.05.h),
                Text(
                  titleText,
                  style: TextStyle(
                    color: codGray,
                    fontWeight: FontWeight.w700,
                    fontSize: 6.sp,
                  ),
                ),
              ],
            ),
          ),
          //verticalDivider10(),
          verticalDivider1(),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(.08.h),
                Text(
                  dateTime,
                  style: TextStyle(
                    color: alizarinCrimson,
                    fontWeight: FontWeight.w700,
                    fontSize: 5.sp,
                  ),
                ),
                verticalSpace(.08.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .06.w,
                  child: Text(
                    address,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: codGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 5.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                verticalSpace(.08.h),
                Text(
                  lat,
                  style: TextStyle(
                    color: codGray,
                    fontWeight: FontWeight.w700,
                    fontSize: 5.sp,
                  ),
                ),
                verticalSpace(.08.h),
                Text(
                  long,
                  style: TextStyle(
                    color: codGray,
                    fontWeight: FontWeight.w700,
                    fontSize: 5.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Order is generated bottom sheet
  Future orderIsGeneratedBottomSheet(
      {required BuildContext context,
      required String userEmailId,
      required Function() onTap,
      required String orderNo,
      required String discountedPrice,
      String? tax,
      String? discountValue,
      String? totalValue}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async {
                            Get.back();
                            CalculationController _calculationController = Get.put(CalculationController());
                            GlobalController globalController = Get.put(GlobalController());
                            await _calculationController.removeSelectedProductListItems(key: "selectedProductListItems");
                            await _calculationController.removeSelectedProductListItems(key: "totalPrice");
                            globalController.splashNavigation();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Image.asset(tick),
                  verticalSpace(2.5.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "Your Order is Generated",
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpace(2.5.h),
                  (orderNo.toString() != "")
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                              child: Text(
                                "Order number is :$orderNo",
                                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            verticalSpace(2.5.h),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                              child: Text(
                                (discountValue == "")
                                    ? "₹ $discountedPrice\nTotal Order value\n(Total - Discount)+Tax"
                                    : "₹ $discountedPrice\nTotal Order value\n(Total - Discount)+Tax\n($totalValue - $discountValue) + $tax",
                                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            verticalSpace(2.5.h),
                          ],
                        )
                      : Container(),
                  Text(
                    "Thank You, Order has been successfully placed. A confirmation message has been sent via SMS and Email : $userEmailId",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(2.h),
                  dynamicButton(onTap: onTap, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white)
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  //You successfully send beats for approval bottom sheet
  Future orderForApprovalBottomSheet({required BuildContext context, required Function() onTapOk}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Image.asset(tick),
                  verticalSpace(2.5.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "You successfully send beats for approval.",
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  verticalSpace(5.5.h),
                  dynamicButton(onTap: onTapOk, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white)
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  //Edit Order bottom sheet
  Future editOrderBottomSheet({
    required BuildContext context,
    required Widget productListCardWidget,
    required Function() saveButton,
  }) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(4.h), topLeft: Radius.circular(4.h))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, left: 6.w, right: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Order",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                ),
                verticalSpace(2.5.h),
                horizontalDivider(),
                verticalSpace(2.h),
                productListCardWidget,
                verticalSpace(1.5.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                  ),
                  child: dynamicButton(onTap: saveButton, height: 6.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "Save", titleColor: white),
                ),
                verticalSpace(1.5.h),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Previous order edit item bottom sheet
  Widget editPreviousOrderBottomSheet({
    required BuildContext context,
    required String productDetailText,
    required String qtyText,
    required Function() deleteOnTap,
    required Function() onTapDecrease,
    required Function() onTapInCrease,
    required String orderIdValue,
    required String qtyValue,
    required String amount,
    required String sqValue,
    required String totalCalculatedValue,
    required TextEditingController qtyTextController,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 5,
            offset: Offset(0, -4),
            spreadRadius: 8,
          )
        ], color: white, borderRadius: BorderRadius.circular(1.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Widgets().productListCardTopRow(
                context: context,
                iconName: pcDowmLightIcon,
                productDetailText: productDetailText,
                iconWidget: Row(
                  children: [
                    InkWell(
                      onTap: deleteOnTap,
                      child: Image.asset(deleteIcon),
                    ),
                    Widgets().horizontalSpace(1.h),
                  ],
                ),
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Widgets().verticalSpace(2.h),
            Widgets().customLRPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().richTextInRow(titleName: 'Sku Code ', titleValue: orderIdValue, fontColor: curiousBlue),
                  Widgets().verticalSpace(1.h),
                  Row(
                    children: [
                      Widgets().productListRowDetails(context: context, title: 'Qty', subTitle: qtyValue),
                      const Spacer(),
                      Widgets().productListRowDetails(context: context, title: "Amount", subTitle: amount),
                      Widgets().verticalSpace(2.h),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Row(
                    children: [
                      //  increaseDecreaseButton(
                      //   onTapDecrease: onTapDecrease,
                      //   qtyText: qtyText,
                      //   onTapInCrease: onTapInCrease,
                      // ),
                      increaseDecreaseButtonWithTextField(
                          onTapInCrease: onTapInCrease, onTapDecrease: onTapDecrease, qtyTextController: qtyTextController, onChanged: onChanged),
                      Widgets().horizontalSpace(3.w),
                      Text(
                        totalCalculatedValue,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Widgets().verticalSpace(2.h),
            (sqValue.isEmpty)
                ? Container()
                : Text(
                    "Total Ordered QTY = $sqValue * ${qtyTextController.text}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: codGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
            (sqValue.isEmpty) ? Container() : Widgets().verticalSpace(2.h),
          ],
        ),
      ),
    );
  }

  //In Out dynamic container
  Widget getInOutContainer({required Function() onTap, required String iconPath, required String titleText, required Color inOutContainerColor}) {
    return InkWell(
        onTap: onTap,
        child: Container(
          //height: 20.h,
          decoration: commonDecoration(bgColor: inOutContainerColor, borderRadius: 1.5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: 6.h,
              ),
              verticalSpace(1.5.h),
              Text(
                titleText,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
              ),
            ],
          ),
        ));
  }

  //In out in Row
  Widget getInOutContainerInRow({required Function() onTap, required String iconPath, required String titleText}) {
    return Container(
      padding: EdgeInsets.all(1.h),
      decoration: commonDecoration(borderRadius: 0, bgColor: white),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, height: 5.h),
            horizontalSpace(2.w),
            textWidgetWithW700(titleText: titleText, fontSize: 13.sp),
          ],
        ),
      ),
    );
  }

  //Promotional Activity
  Widget promotionActivity() {
    return Container(
      decoration: commonDecoration(borderRadius: 10, bgColor: white),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                height: 11.h,
                width: 22.w,
                decoration: commonDecoration(bgColor: white, borderRadius: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      promotionActivityPersonImage,
                      fit: BoxFit.fill,
                    )),
              ),
              horizontalSpace(3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ramesh Ji",
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                  ),
                  verticalSpace(1.h),
                  Row(
                    children: [
                      inOutRowWidgetWithDateTime(
                          gradientColorList: [magicMint, oysterBay], iconName: clockInIcon, titleText: 'IN', date: 'May 21, 2023', time: '12:44:25'),
                      horizontalSpace(2.w),
                      inOutRowWidgetWithDateTime(gradientColorList: [pink, zumthor], iconName: clockInIcon, titleText: 'OUT', date: 'May 21, 2023', time: '12:44:25'),
                    ],
                  ),
                  verticalSpace(1.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        nukkadMeetIcon,
                        height: 2.h,
                      ),
                      horizontalSpace(1.w),
                      Text(
                        "Nukkad Meet",
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 12.sp, letterSpacing: .3),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Container(width: 100.w, height: 1, color: lightBoulder),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              richTextInRow(titleName: 'Visit Brief ', titleValue: 'Meeting for Lighting Products ', fontColor: curiousBlue),
            ],
          ),
        )
      ]),
    );
  }

  Widget newPromotionActivity({
    required Function() onTapNukkadMeetCard,
    required String promotionActivityPersonImage,
    required String userName,
    required String dateIn,
    required String timeIn,
    required String dateOut,
    required String timeOut,
    required String visitBrief,
  }) {
    return InkWell(
      onTap: onTapNukkadMeetCard,
      child: Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Container(
          decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Row(
                children: [
                  Container(
                    height: 7.h,
                    width: 14.w,
                    decoration: commonDecoration(bgColor: white, borderRadius: .7.h),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(.8.h),
                        child: Image.asset(
                          promotionActivityPersonImage,
                          fit: BoxFit.fill,
                        )),
                  ),
                  horizontalSpace(3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidgetWithW700(titleText: userName, fontSize: 12.sp),
                      verticalSpace(1.h),
                      Row(
                        children: [
                          SvgPicture.asset(nukkadMeetIcon, height: 2.h),
                          horizontalSpace(1.w),
                          textWidgetWithW400(titleText: "Nukkad Meet", fontSize: 12.sp, textColor: codGray),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(1.h),
            Padding(
              padding: EdgeInsets.all(1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      newInOutRowWidgetWithDateTime(gradientColorList: [magicMint, oysterBay], iconName: clockInIcon, titleText: 'IN', date: dateIn, time: timeIn),
                      horizontalSpace(2.w),
                      newInOutRowWidgetWithDateTime(gradientColorList: [pink, zumthor], iconName: clockInIcon, titleText: 'OUT', date: dateOut, time: timeOut),
                    ],
                  ),
                  verticalSpace(1.h),
                  richTextInRow(titleName: 'Visit Brief ', titleValue: visitBrief, fontColor: codGray)
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  //Promotion activity helper widget
  Widget inOutRowWidgetWithDateTime(
      {required List<Color> gradientColorList, required String iconName, required String titleText, required String date, required String time}) {
    return Container(
      decoration: commonDecorationWithGradient(borderRadius: 1.h, gradientColorList: gradientColorList),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              horizontalSpace(2.w),
              SvgPicture.asset(iconName, height: 2.5.h),
              horizontalSpace(1.w),
              textWidgetWithW700(titleText: titleText, fontSize: 8.sp),
              horizontalSpace(1.w),
            ],
          ),
          verticalDividerInGradientRow(),
          horizontalSpace(1.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidgetWithW700(titleText: date, fontSize: 8.sp),
              horizontalSpace(1.w),
              textWidgetWithW700(titleText: time, fontSize: 8.sp),
              horizontalSpace(1.w),
            ],
          ),
          horizontalSpace(1.w),
        ],
      ),
    );
  }

  //Promotion activity helper widget
  Widget newInOutRowWidgetWithDateTime(
      {required List<Color> gradientColorList, required String iconName, required String titleText, required String date, required String time}) {
    return Container(
      height: 7.5.h,
      decoration: commonDecorationWithGradient(borderRadius: 1.h, gradientColorList: gradientColorList),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
            child: Row(
              children: [
                SvgPicture.asset(iconName, height: 2.5.h),
                horizontalSpace(1.w),
                textWidgetWithW700(titleText: titleText, fontSize: 8.sp),
              ],
            ),
          ),
          verticalDivider1(),
          Padding(
            padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(calender, height: 2.h),
                    verticalSpace(1.h),
                    SvgPicture.asset(clock, height: 2.h),
                  ],
                ),
                horizontalSpace(2.w),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidgetWithW700(titleText: date, fontSize: 8.sp),
                    verticalSpace(1.h),
                    textWidgetWithW700(titleText: time, fontSize: 8.sp),
                  ],
                ),
                //horizontalSpace(1.w),
              ],
            ),
          ),
          //horizontalSpace(1.w),
        ],
      ),
    );
  }

  //Meet details tile with gradient
  Widget meetDetailsTile({
    required List<Color> gradientColorsList,
    required String iconNameFirst,
    required String iconNameSecond,
    required String iconNameThird,
    required String titleTextFirst,
    required String titleTextSecond,
    required String titleTextThird,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
      decoration: commonDecorationWithGradient(borderRadius: 1.5.h, gradientColorList: gradientColorsList),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconWithTextInRow(iconName: iconNameFirst, titleText: titleTextFirst, isTextColor: true),
          iconWithTextInRow(iconName: iconNameSecond, titleText: titleTextSecond, isTextColor: true),
          iconWithTextInRow(iconName: iconNameThird, titleText: titleTextThird, isTextColor: true),
        ],
      ),
    );
  }

  //Meet details tile with Single color
  Widget meetDetailsTileWithSingleColor({
    required Color bgColor,
    required Color circleColor,
    required Color circleBorderColor,
    required Color borderColor,
    required String iconNameFirst,
    required String iconNameSecond,
    required String iconNameThird,
    required String titleTextFirst,
    required String titleTextSecond,
    required String titleTextThird,
  }) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.only(left: 3.w, right: 3.w),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(3.h), border: Border.all(color: borderColor, width: 2.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: circleBorderColor,
            child: CircleAvatar(
              radius: 6,
              backgroundColor: circleColor,
            ),
          ),
          iconWithTextInRow(iconName: iconNameFirst, titleText: titleTextFirst, isTextColor: true),
          iconWithTextInRow(iconName: iconNameSecond, titleText: titleTextSecond, isTextColor: true),
          iconWithTextInRow(iconName: iconNameThird, titleText: titleTextThird, isTextColor: true),
        ],
      ),
    );
  }

  //Icon with Text In Row
  Widget iconWithTextInRow({String? iconName, String? titleText, required bool isTextColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconName ?? "",
          height: 3.h,
        ),
        horizontalSpace(1.w),
        Text(
          titleText ?? "",
          style: TextStyle(color: isTextColor ? codGray : white, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
        ),
        // horizontalSpace(1.w),
      ],
    );
  }

  Widget iconContainerWithTextInRow({String? iconName, String? titleText, required bool isTextColor}) {
    return Row(
      children: [
        Container(
          height: 4.h,
          width: 8.w,
          decoration: commonDecoration(borderRadius: 5, bgColor: lightViolet),
          child: Padding(
            padding: EdgeInsets.all(.5.h),
            child: SvgPicture.asset(iconName ?? ""),
          ),
        ),
        horizontalSpace(3.w),
        Text(
          titleText ?? "",
          style: TextStyle(color: isTextColor ? codGray : white, fontWeight: FontWeight.w700, fontSize: 10.sp, letterSpacing: .3),
        ),
        // horizontalSpace(1.w),
      ],
    );
  }

  //Gradient container with text
  Widget gradientContainerWithText({required String titleText, required List<Color> gradientColor}) {
    return Container(
      width: 100.w,
      decoration: commonDecorationWithGradient(
        borderRadius: 1.5.h,
        gradientColorList: gradientColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(2.5.h),
        child: textWidgetWithW500(titleText: titleText, fontSize: 10.sp, textColor: codGray),
      ),
    );
  }

  //Icon With Text With Red color
  Widget iconWithTextInRowWithColor({
    String? iconName,
    String? titleText,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconName ?? "",
          height: 3.h,
        ),
        horizontalSpace(1.w),
        Text(
          titleText ?? "",
          style: TextStyle(color: alizarinCrimson, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
        ),
        // horizontalSpace(1.w),
      ],
    );
  }

  //Preview order select info bottom sheet
/*  Future previewOrderSelectInfBottomSheet({required BuildContext context, required Widget productAvailableCategoryWidget}) {
    return Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(4.h), topLeft: Radius.circular(4.h))),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.5.h, left: 5.w, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Info",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                          textAlign: TextAlign.start,
                        ),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(closeIcon))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(2.5.h),
                        horizontalDivider(),
                        verticalSpace(2.5.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Which products are available (Category)",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                                textAlign: TextAlign.start),
                            verticalSpace(2.5.h),
                            productAvailableCategoryWidget,
                          ],
                        ),
                        verticalSpace(1.5.h),
                        horizontalDivider(),
                        verticalSpace(1.5.h),
                        Text("POSM visibility (Any POSM material available)",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
                            textAlign: TextAlign.start),
                        verticalSpace(1.5.h),
                        radioButton(titleText: 'Wire', groupValue: 1, context: context, onChangedYes: (valueYes) {}, onChangedNo: (valueNo) {}),
                        verticalSpace(1.5.h),
                        horizontalDivider(),
                        verticalSpace(1.5.h),
                        radioButton(
                            titleText: 'POSM visibility (Any POSM material available)',
                            groupValue: 1,
                            context: context,
                            onChangedYes: (valueYes) {},
                            onChangedNo: (valueNo) {}),
                        verticalSpace(1.5.h),
                        dynamicButton(onTap: () {}, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white),
                        verticalSpace(1.5.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
      barrierColor: Colors.transparent,
      persistent: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
    );
  }*/

  //Preview order select info bottom sheet
  Future myBeatFullAddressBottomSheet({
    required BuildContext context,
    required TextEditingController controller,
    required String customersOnLocationText,
    required String customerName,
    required String customerCode,
    required String customerAddress,
  }) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, left: 3.w, right: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidgetWithW700(titleText: customersOnLocationText, fontSize: 13.sp),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                ),
                verticalSpace(2.5.h),
                horizontalDivider(),
                verticalSpace(2.5.h),
                Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: textFieldWidget(controller: controller, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: zumthor)),
                      verticalSpace(2.h),
                      todayBeatFullAddressExpantionCard(context: context, customerName: customerName, customerCode: customerCode, customerAddress: customerAddress),
                      verticalSpace(2.5.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Beats available
  Future beatsAvailableBottomSheet(
      {required BuildContext context, required TextEditingController controller, required Widget widget, required Function() addToCalendarOnTap}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, -4),
                  spreadRadius: 5,
                )
              ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Beats Available",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                            textAlign: TextAlign.start,
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(closeIcon))
                        ],
                      ),
                    ),
                    verticalSpace(2.5.h),
                    horizontalDivider(),
                    verticalSpace(2.5.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: textFieldWidget(controller: controller, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: zumthor),
                    ),
                    widget,
                    customLRPadding(
                        child: dynamicButton(
                            onTap: addToCalendarOnTap, height: 5.h, width: 100.w, buttonBGColor: alizarinCrimson, titleText: "Add to Calendar", titleColor: white)),
                    verticalSpace(2.5.h),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  //Radio button in row
  Widget radioButton(
      {required String titleText,
      required int groupValue,
      required void Function(int?) onChangedYes,
      required void Function(int?) onChangedNo,
      required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Text(
            titleText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ":",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
          textAlign: TextAlign.start,
        ),
        const Spacer(),
        Radio(
          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
          activeColor: alizarinCrimson,
          value: 1,
          groupValue: groupValue,
          onChanged: onChangedYes,
        ),
        Text(
          "Yes",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
          textAlign: TextAlign.start,
        ),
        horizontalSpace(3.w),
        Radio(
          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
          activeColor: alizarinCrimson,
          value: 0,
          groupValue: groupValue,
          onChanged: onChangedNo,
        ),
        Text(
          "No",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
          textAlign: TextAlign.start,
        )
      ],
    );
  }

  //Three simple text in row
  Widget simpleTextInRow({required String titleText, required String valueText, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: Text(
            titleText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 10.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          ": ",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 10.sp, letterSpacing: .3),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Text(
            valueText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 10.sp, letterSpacing: .3),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  //Customer profile view heat map
  Widget tileWithTwoIconAndSingleText(
      {required BuildContext context,
      required String title,
      required String titleIcon,
      required String subtitleIcon,
      required List<Color> tileGradientColor,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: tileGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                titleIcon,
                height: 3.h,
              ),
              horizontalSpace(2.w),
              SizedBox(
                width: 60.w,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 11.sp, letterSpacing: .3),
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                subtitleIcon,
                height: 2.5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Customer profile view heat map
  Widget tileWithTwoTextAndSingleIcon(
      {required BuildContext context, required String customerName, required String customerCount, required String subtitleIcon, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        //decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.5.h), border: Border.all(color: boulder)),
        child: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                customerName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 11.sp, letterSpacing: .3),
                textAlign: TextAlign.start,
              ),
              const Spacer(),
              Text(
                customerCount,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 11.sp, letterSpacing: .3),
                textAlign: TextAlign.start,
              ),
              horizontalSpace(2.w),
              SvgPicture.asset(
                subtitleIcon,
                height: 2.5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Beat allocation bulk upload
  Widget beatAllocationBulkUploadTile(
      {required BuildContext context,
      required String title,
      required String titleIcon,
      required String subtitleIcon,
      required List<Color> tileGradientColor,
      required Function() onTapOnTile}) {
    return InkWell(
      onTap: onTapOnTile,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: tileGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                bulkUpload,
                height: 20,
                width: 20,
              ),
              horizontalSpace(2.w),
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 11.sp, letterSpacing: .3),
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                subtitleIcon,
                height: 2.5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Customer Profile expantion card
  Widget customerProfileExpantionCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String creditLimit,
    required String outstanding,
    required String overdue,
    required Function() callingOnTap,
    required Function() noteDetailsOnTap,
    required Function() locationOnTap,
    required Function() viewDetailsOnTap,
    bool? isVerified = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 5, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                            Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
                            (isVerified!)
                                ? Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                      shopVerified,
                                      height: 2.h,
                                    ))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: .5.h),
                        child: Column(
                          children: [
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                            verticalSpace(1.h),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                            verticalSpace(1.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Credit Limit', subTitle: creditLimit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Overdue ', subTitle: overdue),
                verticalSpace(1.h),
                InkWell(onTap: viewDetailsOnTap, child: textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue)),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: noteDetailsOnTap,
                  child: SvgPicture.asset(
                    noteDetailsIcon,
                    height: 6.w,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 6.w,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: () async {
                    locationOnTap();
                  },
                  child: SvgPicture.asset(
                    locationIcon,
                    height: 6.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Customer details expantion card
  Widget customerDetailsExpantionCard({
    required BuildContext context,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String creditLimit,
    required String outstanding,
    required String overdue,
    required String phoneNumber,
    required String verify,
    required Function() callingOnTap,
    required Function() locationOnTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Credit Limit', subTitle: creditLimit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Overdue ', subTitle: overdue),
                verticalSpace(1.h),
                //primaryOrderRowDetails(context: context, title: 'Phone Number ', subTitle: phoneNumber),
                primaryOrderRowDetailsWithStatus(context: context, title: 'Phone Number ', subTitle: phoneNumber, verify: verify),

                //textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 4.h,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: locationOnTap,
                  child: SvgPicture.asset(
                    locationIcon,
                    height: 4.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Customer Service Detials  card
  Widget customerServiceDetailsCardCard({
    required BuildContext context,
    required String businessUnit,
    required String zone,
    required String title,
    required String employeeCode,
    required String state,
    required String city,
    required String customerService,
    required String dateAndTime,
    required String remark,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: textWidgetWithW400(titleText: title, fontSize: 9.sp, textColor: Colors.black),
                ),
                Expanded(
                  flex: 1,
                  child: textWidgetWithW400(titleText: "(Employee Code : $employeeCode)", fontSize: 9.sp, textColor: curiousBlue),
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Zone', subTitle: zone),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Customer Service', subTitle: customerService),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Date & Time', subTitle: dateAndTime),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Remark', subTitle: remark),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Customer FMCD Details card
  Widget customerFMCDDetailsCardCard({
    required BuildContext context,
    required String businessUnit,
    required String zone,
    required String title,
    required String employeeCode,
    required String state,
    required String city,
    required String information,
    required String dateAndTime,
    required String address,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                textWidgetWithW400(titleText: title, fontSize: 9.sp, textColor: Colors.black),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 1,
                  child: textWidgetWithW400(titleText: "(Employee Code : $employeeCode)", fontSize: 9.sp, textColor: curiousBlue),
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Date & Time', subTitle: dateAndTime),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Zone', subTitle: zone),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Information', subTitle: information),
                verticalSpace(1.h),
                SizedBox(
                  width: 100.w,
                  height: 45.h,
                  child: ClipRRect(borderRadius: BorderRadius.circular(1.5.h), child: Image.asset(customerFMCDDetails, fit: BoxFit.fill)),
                ),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Customer Service  card
  Widget customerServiceCard({
    required BuildContext context,
    required String title,
    required String employeeCode,
    required String customerService,
    required String remark,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: textWidgetWithW500(titleText: title, fontSize: 9.sp, textColor: Colors.black),
                ),
                Expanded(
                  flex: 1,
                  child: textWidgetWithW400(titleText: "(Customer Code : $employeeCode)", fontSize: 9.sp, textColor: curiousBlue),
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Customer Service', subTitle: customerService),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Remark', subTitle: remark),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Customer FMCD  card
  Widget customerFMCDCard({
    required BuildContext context,
    required String title,
    required String customerCode,
    required String businessUnit,
    required String dateAndTime,
    required String infromation,
    required String address,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                textWidgetWithW500(titleText: title, fontSize: 9.sp, textColor: Colors.black),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 1,
                  child: textWidgetWithW400(titleText: "(Customer Code : $customerCode)", fontSize: 9.sp, textColor: curiousBlue),
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Date & Time', subTitle: dateAndTime),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Information', subTitle: infromation),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Beat TargetScreen  card
  Widget targetScreenCardCard({
    required BuildContext context,
    required String periodDate,
    required String achievedAmount,
    required String targetAmount,
    required String type,
    required String businessUnit,
    required String division,
    required String category,
    required String subBrand,
    required String creationDate,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h, bottom: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: textWidgetWithW400(titleText: "Period Date : $periodDate", fontSize: 9.sp, textColor: curiousBlue),
                )
              ],
            ),
          ),
          Container(width: 100.w, height: 1, color: lightBoulder),
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Achieved Amount', subTitle: achievedAmount),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Target Amount', subTitle: targetAmount),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Type', subTitle: type),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Division', subTitle: division),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Category', subTitle: category),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Sub Brand', subTitle: subBrand),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Creation Date', subTitle: creationDate),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Beat Single Target Screen  card
  Widget targetSingleScreenCard({
    required BuildContext context,
    required String achievedAmount,
    required String targetAmount,
    required String type,
    required String businessUnit,
    required String division,
    required String category,
    required String subBrand,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customLRPadding(
            child: Column(
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Achieved Amount', subTitle: achievedAmount),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Target Amount', subTitle: targetAmount),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Type', subTitle: type),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Division', subTitle: division),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Category', subTitle: category),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Sub Brand', subTitle: subBrand),
                verticalSpace(2.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Beat ProductCatelogue expantion card
  Widget beatProductCatelogueExpantionCard(
      {required BuildContext context,
      required String productName,
      required String bu,
      required String customerCode,
      required String mrp,
      required String primaryCategory,
      required String subCategory,
      required String productVariant,
      required String retailPrice,
      required String masterQty,
      required String status,
      required Color statusColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: textWidgetWithW400(titleText: "Code : $customerCode", fontSize: 9.sp, textColor: curiousBlue),
                        ),
                      ],
                    ),
                    children: [
                      verticalSpace(1.h),
                      productCatelogueRowDetails(context: context, title: 'Product Name', subTitle: productName),
                      verticalSpace(1.h),
                      productCatelogueRowDetails(context: context, title: 'Business Unit', subTitle: bu),
                      verticalSpace(1.h),
                      productCatelogueRowDetails(context: context, title: 'Primary Category', subTitle: primaryCategory),
                      productCatelogueRowDetails(context: context, title: 'Sub Category', subTitle: subCategory),
                      verticalSpace(1.h),
                    ],
                  ),
                ),
              ),
            ),
            customLRPadding(
              child: Column(
                children: [
                  productCatelogueRowDetails(context: context, title: 'Product Variant', subTitle: productVariant),
                  verticalSpace(1.h),
                  productCatelogueRowDetails(context: context, title: 'Retail Price ', subTitle: retailPrice),
                  verticalSpace(2.h),
                  productCatelogueRowDetails(
                    context: context,
                    title: 'MRP',
                    subTitle: mrp,
                  ),
                  verticalSpace(2.h),
                  productCatelogueRowDetails(context: context, title: 'Master QTY', subTitle: masterQty),
                  verticalSpace(2.h),
                  productCatelogueRowDetails(context: context, title: 'Status', subTitle: status, subTitleColor: statusColor),
                  verticalSpace(2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Beat Price List expantion card
  Widget beatPriceListExpantionCard(
      {required BuildContext context,
      required String customerCode,
      required String itemName,
      required String warehouse,
      required String mrp,
      required String dlp,
      required String businessUnit,
      required String masterQTY,
      required String status,
      required String createdAt,
      required String updatedAt,
      required Color statusColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: textWidgetWithW400(titleText: "(Customer Code : $customerCode)", fontSize: 9.sp, textColor: curiousBlue),
                        ),
                      ],
                    ),
                    children: [
                      verticalSpace(1.h),
                      primaryOrderRowDetails(context: context, title: 'Name', subTitle: itemName),
                      verticalSpace(1.h),
                      primaryOrderRowDetails(context: context, title: 'Warehouse', subTitle: warehouse),
                      verticalSpace(1.h),
                      primaryOrderRowDetails(context: context, title: 'MRP', subTitle: mrp),
                      verticalSpace(1.h),
                      primaryOrderRowDetails(context: context, title: 'DLP', subTitle: dlp),
                      verticalSpace(1.h),
                    ],
                  ),
                ),
              ),
            ),
            customLRPadding(
              child: Column(
                children: [
                  primaryOrderRowDetails(context: context, title: 'Business Unit', subTitle: businessUnit),
                  verticalSpace(1.h),
                  primaryOrderRowDetails(context: context, title: 'Master Qty ', subTitle: masterQTY),
                  verticalSpace(2.h),
                  rowWithStatusColorText(context: context, title: 'Status', subTitle: status, textColor: statusColor),
                  verticalSpace(2.h),
                  primaryOrderRowDetails(context: context, title: 'Created At', subTitle: createdAt),
                  verticalSpace(2.h),
                  primaryOrderRowDetails(context: context, title: 'Updated At', subTitle: updatedAt),
                  verticalSpace(2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Beat Option 1 expantion card
  Container beatOption1ExpantionCard({
    required BuildContext context,
    required String userName,
    required String userCode,
    required Function() onTapView,
    required Widget presentMonthBeatAllocationWidget,
    required bool approve,
  }) {
    return Container(
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox1(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          textWidgetWithW700(titleText: userName, fontSize: 9.sp),
                          horizontalSpace(2.w),
                          textWidgetWithW400(titleText: "(Code $userCode)", fontSize: 9.sp, textColor: curiousBlue)
                        ],
                      ),
                    ],
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(1.h),
                    presentMonthBeatAllocationWidget,
                    verticalSpace(1.h),
                    dynamicButton(onTap: onTapView, height: 5.h, width: 35.w, buttonBGColor: alizarinCrimson, titleText: approve ? 'View' : 'Approve', titleColor: white),
                    verticalSpace(1.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Customer Profile expantion card
  Widget todayBeatExpansionCard(
      {required BuildContext context,
      required List<Color> tileGradientColor,
      required String locationTitle,
      required String noOfCustomers,
      required bool initiallyExpanded,
      required Function(bool) onExpansionChanged,
      required Widget childView}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: tileGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        child: Widgets().expansionDrawerItemBox2(
          //TODO : add responsive height with Nexus one api
          () {},
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListTileTheme(
              contentPadding: const EdgeInsets.all(0),
              minVerticalPadding: 0,
              child: ExpansionTile(
                key: GlobalKey(),
                // Add a key to each ExpansionTile.

                onExpansionChanged: onExpansionChanged,
                initiallyExpanded: initiallyExpanded,

                tilePadding: const EdgeInsets.all(0),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: malachite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(1.5.h),
                            bottomLeft: Radius.circular(1.5.h),
                          )),
                      height: 7.h,
                      width: 5,
                    ),
                    horizontalSpace(4.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidgetWithW500(titleText: locationTitle, fontSize: 11.sp, textColor: codGray),
                        textWidgetWithW500(titleText: noOfCustomers, fontSize: 11.sp, textColor: codGray),
                      ],
                    )
                  ],
                ),
                children: [
                  Container(
                    color: white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: childView,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Customer Profile expantion card
  Widget todayBeatFullAddressExpantionCard({
    required BuildContext context,
    required String customerName,
    required String customerCode,
    required String customerAddress,
  }) {
    return Container(
      decoration: BoxDecoration(color: twilightBlue, borderRadius: BorderRadius.circular(1.5.h), border: Border.all(color: pattensBlue, width: 2.0)),
      child: Widgets().expansionDrawerItemBox2(
        () {},
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: 0,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(0),
              title: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: customerName,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: codGray),
                    children: <TextSpan>[
                      TextSpan(
                        text: "   (Code :  $customerCode)",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: curiousBlue),
                      ),
                    ],
                  ),
                ),
              ),
              children: [
                Container(
                  color: white,
                  child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(1.h),
                          Row(
                            children: [
                              textWidgetWithW700(titleText: 'Address', fontSize: 13.sp),
                            ],
                          ),
                          verticalSpace(1.h),
                          textWidgetWithW500(
                            titleText: customerAddress,
                            fontSize: 9.sp,
                            align: TextAlign.start,
                            textColor: codGray,
                          ),
                          verticalSpace(1.h),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Select date range tile
  Container selectDateRangeExpantionTile(
      {required BuildContext context,
      required TextEditingController orderIdController,
      required Widget datePickerWidget,
      required Function() onTapApply,
      required bool initiallyExpanded,
      required Function(bool) onExpansionChanged,
      required Function() onTap}) {
    return Container(
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: magnolia),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  initiallyExpanded: initiallyExpanded,
                  key: GlobalKey(),
                  onExpansionChanged: onExpansionChanged,
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          horizontalSpace(2.w),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: textWidgetWithW700(titleText: "Last 7 Days", fontSize: 10.sp),
                          ),
                        ],
                      ),
                      //horizontalDivider()
                    ],
                  ),
                  children: [
                    verticalSpace(1.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: textWidgetWithW700(titleText: "Current Month", fontSize: 10.sp),
                        ),
                        verticalSpace(2.h),
                        horizontalDivider(),
                        verticalSpace(2.h),
                        customLRPadding(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 6.5.h,
                                decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
                                child: previousOrderSearchTextFieldWidget(
                                    controller: orderIdController,
                                    hintText: 'Enter Order number',
                                    iconName: '',
                                    keyBoardType: TextInputType.text,
                                    fillColor: white,
                                    onTap: onTap)),
                            verticalSpace(2.h),
                            datePickerWidget,
                            verticalSpace(2.h),
                            dynamicButton(onTap: onTapApply, height: 50, width: 150, buttonBGColor: alizarinCrimson, titleText: "Apply", titleColor: white),
                            verticalSpace(2.h),
                          ],
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Invoices Period expantion card

  Container invoicesPeriodExpantionTile({required BuildContext context, required Function() onApply, required Widget dropDownWidget, required Widget datePickerWidget}) {
    return Container(
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: magnolia),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: textWidgetWithW700(titleText: "Last 7 Days", fontSize: 11.sp),
                  children: [
                    verticalSpace(1.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidgetWithW700(titleText: "Current Month", fontSize: 10.sp),
                        verticalSpace(2.h),
                        horizontalDivider(),
                        verticalSpace(2.h),
                        customLRPadding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              datePickerWidget,
                              verticalSpace(2.h),
                              dropDownWidget,
                              verticalSpace(2.h),
                              dynamicButton(
                                  onTap: () {
                                    onApply();
                                  },
                                  height: 5.h,
                                  width: 40.w,
                                  buttonBGColor: alizarinCrimson,
                                  titleText: "Apply",
                                  titleColor: white),
                              verticalSpace(2.h),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Select LAS expantion card
  Container selectLasExpansionTile(
      {required BuildContext context, required TextEditingController searchController, required Widget checkWidget, required Function(bool)? onExpansionChanged}) {
    return Container(
      decoration: commonDecoration(borderRadius: 10, bgColor: white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  onExpansionChanged: onExpansionChanged,
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: textWidgetWithW700(titleText: "Select employee", fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    verticalSpace(1.h),
                    checkWidget
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     verticalSpace(2.h),
                    //     textFieldWidgetWithOrder(controller: searchController, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                    //     verticalSpace(2.h),
                    //     checkWidget
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Checkout expantion card
  Container checkOutExpantionCard({required BuildContext context, required Widget widget}) {
    return Container(
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              "Added Product List",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 11.sp, letterSpacing: .3),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      //horizontalDivider()
                    ],
                  ),
                  children: [verticalSpace(1.h), widget],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Common decoration box
  ShapeDecoration commonDecoration({required double borderRadius, required Color bgColor}) {
    return ShapeDecoration(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      shadows: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 10,
          offset: Offset(0, 3),
          spreadRadius: 5,
        )
      ],
    );
  }

  //Common decoration box with gradient color
  ShapeDecoration commonDecorationWithGradient({required double borderRadius, required List<Color> gradientColorList}) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColorList,
        stops: const [-.10, 0.84],
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 10,
          offset: Offset(0, 3),
          spreadRadius: 5,
        )
      ],
    );
  }

  //Attendance status row like Present, absent, holiday
  Widget attendanceStatusRow({required Color color, required String titleText}) {
    return Row(
      children: [
        /*CircleAvatar(
          radius: 10,
          backgroundColor: bgColor,
          child: CircleAvatar(
            radius: 5,
            backgroundColor: white,
          ),
        ),*/
        Container(
          height: 4.h,
          width: 4.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
        ),
        horizontalSpace(2.w),
        textWidgetWithW700(titleText: titleText, fontSize: 11.sp),
      ],
    );
  }

  //Nukkad meet person full details
  Widget meetFullDetails({required BuildContext context, required String titleText, required String valueText}) {
    return Container(
      decoration: commonDecoration(bgColor: white, borderRadius: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            simpleTextInRow(context: context, titleText: titleText, valueText: valueText),
            verticalSpace(1.h),
            simpleTextInRow(context: context, titleText: titleText, valueText: valueText),
            verticalSpace(1.h),
            simpleTextInRow(context: context, titleText: titleText, valueText: valueText),
            verticalSpace(1.h),
            simpleTextInRow(context: context, titleText: titleText, valueText: valueText),
            verticalSpace(3.h),
            Column(
              children: [
                Container(
                  height: 50.h,
                  width: 100.w,
                  decoration: commonDecoration(bgColor: white, borderRadius: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        promotionActivityPersonImage,
                        fit: BoxFit.fill,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  //Customer detail Color container
  Widget colorContainer({
    required Color bgColor,
    required Color borderColor,
    required String iconName,
    Color? iconColor,
    required String titleText,
    required String subTitleText,
  }) {
    return Container(
      width: 45.w,
      height: 20.h,
      decoration: commonDecoration(borderRadius: 10, bgColor: bgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Widgets().verticalSpace(0.5.h),
          Container(
              height: 7.h,
              width: 15.w,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  iconName,
                  color: iconColor,
                )),
              )),
          Widgets().verticalSpace(0.5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              titleText,
              style: TextStyle(fontSize: 15.sp, color: codGray, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Widgets().verticalSpace(0.5.h),
          Text(
            subTitleText,
            style: TextStyle(fontSize: 12.sp, color: codGray),
          ),
        ],
      ),
    );
  }

  //Customer detail Color container
  Widget colorThreeContainerInRow({
    required Color bgColor,
    required Color borderColor,
    required String iconName,
    Color? iconColor,
    required String titleText,
    required String subTitleText,
  }) {
    return Container(
      width: 30.w,
      height: 20.h,
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: bgColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Widgets().verticalSpace(0.5.h),
            Container(
                height: 7.h,
                width: 15.w,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    iconName,
                    color: iconColor,
                  )),
                )),
            Widgets().verticalSpace(0.5.h),
            Text(
              titleText,
              style: TextStyle(fontSize: 15.sp, color: codGray, fontWeight: FontWeight.w600),
            ),
            Widgets().verticalSpace(0.5.h),
            Text(
              subTitleText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: codGray),
            ),
          ],
        ),
      ),
    );
  }

  //My beat colorful status container
  Widget myBeatColorContainer({
    required BuildContext context,
    required Color bgColor,
    required Color borderColor,
    required String iconName,
    Color? iconColor,
    bool fixWidth = true,
    required String titleText,
    required String subTitleText,
  }) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2.0)),
      child: Padding(
        padding: EdgeInsets.only(left: 3.w, bottom: 2.w, top: 2.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(1.h),
            SvgPicture.asset(
              iconName,
              color: iconColor,
            ),
            verticalSpace(1.h),
            Text(
              titleText,
              style: TextStyle(fontSize: 12.sp, color: codGray, fontWeight: FontWeight.w600),
            ),
            verticalSpace(1.h),
            SizedBox(
              width: fixWidth ? 23.w : null,
              child: Text(
                subTitleText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 9.sp, letterSpacing: .2),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Nukkad meet full details
  Card nukkadMeetDetails(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5.h)),
      elevation: 5,
      color: magnolia,
      child: Column(children: [
        //verticalSpace(2.h),
        Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              primaryOrderRowDetails(context: context, title: 'Event', subTitle: 'Nukkad Meet'),
              verticalSpace(1.h),
              primaryOrderRowDetails(context: context, title: 'Name', subTitle: 'Ramesh Ji'),
              verticalSpace(1.h),
              primaryOrderRowDetails(context: context, title: 'Visit Brief', subTitle: 'Meeting for Lighting Products'),
              verticalSpace(1.h),
              primaryOrderRowDetails(context: context, title: 'Next Action Plan', subTitle: 'Next Meeting on 28th Order Details'),
              verticalSpace(1.h),
              SizedBox(
                width: 100.w,
                height: 45.h,
                child: ClipRRect(borderRadius: BorderRadius.circular(1.5.h), child: Image.asset(meetDetails, fit: BoxFit.fill)),
              )
            ],
          ),
        ),
      ]),
    );
  }

  showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: alizarinCrimson,
      textColor: white,
      fontSize: 16.0,
    );
  }

  Widget customPadding({double? left, double? right, double? bottom, double? top, required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(left: left ?? 0, right: right ?? 0, bottom: bottom ?? 0, top: top ?? 0),
      child: child,
    );
  }

//15 padding from Right side
  Widget customLeftRightPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3.w,
        right: 3.w,
      ),
      child: child,
    );
  }

//10 padding from left side
  Widget customLeftPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(left: 1.5.h),
      child: child,
    );
  }

  //10 padding from left side
  Widget customTopPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: child,
    );
  }

  //15 padding from left side
  Widget customTop15Padding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: child,
    );
  }

  //15 padding from all side
  Widget customAll15Padding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: child,
    );
  }

  //15 padding fromLeft  Right side
  Widget customLRPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3.w,
        right: 3.w,
      ),
      child: child,
    );
  }

  //15 padding fromLeft  Right side
  Widget customLPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3.5.w,
      ),
      child: child,
    );
  }

  //20 padding fromLeft  Right side
  Widget customLRadding40({required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
      ),
      child: child,
    );
  }

  //Profile picture circle avatar
  Widget profilePictureAvatar({required String imageUrl}) {
    /* return CircleAvatar(
      radius: 8.5.h,
      backgroundColor: lightGreyBoulder,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.h),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          height: 15.h,
          width: 30.w,
          progressIndicatorBuilder: (context, url, downloadProgress) => const CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(
            CupertinoIcons.person,
            size: 2.5.h,
            color: codGray,
          ),
        ),
      ),
    );*/

    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: lightGreyBoulder,
          width: 4.0,
        ),
      ),
    );
  }

  //App bar profile picture
  Widget appBarProfilePictureAvatar({required String imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.h),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.fill,
        height: 2.0.h,
        width: 9.w,
        progressIndicatorBuilder: (context, url, downloadProgress) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => Icon(
          CupertinoIcons.person,
          size: 2.5.h,
          color: codGray,
        ),
      ),
    );
  }

  //Attendance with profile
  Widget attendanceWithProfileContainer(
      {required Function() onTapIn, required Function() onTapOut, required Function() onTapSkip, required Color inContainerColor, required Color outContainerColor}) {
    return Container(
      width: 100.w,
      height: 48.h,
      decoration: commonDecorationForTopLR9WithBGColor(bgColor: pippin),
      child: Column(
        children: [
          Widgets().verticalSpace(4.h),
          SvgPicture.asset(
            calender,
            height: 10.h,
          ),
          Widgets().verticalSpace(3.h),
          Text(
            "Would you like to Punch Today",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp, color: codGray),
          ),
          Widgets().verticalSpace(3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 18.h, width: 40.w, child: getInOutContainer(onTap: onTapIn, iconPath: clockInIcon, titleText: 'IN', inOutContainerColor: inContainerColor)),
              Widgets().horizontalSpace(5.w),
              SizedBox(
                  height: 18.h,
                  width: 40.w,
                  child: Widgets().getInOutContainer(onTap: onTapOut, iconPath: out, titleText: 'OUT', inOutContainerColor: outContainerColor)),
            ],
          ),
          Widgets().verticalSpace(1.5.h),
          InkWell(onTap: onTapSkip, child: Widgets().textWithRightArrowIcon(icon: Icons.arrow_forward, textTitle: 'Skip for Now'))
        ],
      ),
    );
  }

  //Beat allocation Bulk Upload card
  Widget beatAllocationBulkUploadCardList(
      {required BuildContext context,
      required Function() onTapExcel,
      required String uploadDate,
      required String uploadType,
      required String status,
      required String beatExtensionFormat,
      required String noOfRecords,
      required String dateFrom,
      required Color statusColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, -4),
            spreadRadius: 5,
          )
        ], color: magnolia, borderRadius: BorderRadius.circular(1.5.h)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidgetWithW700(titleText: beatExtensionFormat, fontSize: 12.sp),
                    Widgets().iconElevationButton(
                        onTap: onTapExcel,
                        icon: excel,
                        width: 25.w,
                        height: 4.5.h,
                        titleText: 'Excel',
                        isBackgroundOk: true,
                        bgColor: magicMint,
                        iconColor: codGray,
                        textColor: codGray),
                  ],
                ),
              ),
              verticalSpace(1.5.h),
              Widgets().horizontalDividerWhite(),
              verticalSpace(2.5.h),
              Padding(
                padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Widgets().productListRowDetails(context: context, title: 'Upload Date', subTitle: uploadDate),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().productListRowDetails(context: context, title: 'Upload Type', subTitle: uploadType),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().beatAllocationTextWithStatus(context: context, title: 'Status', subTitle: status, statusColor: statusColor),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().productListRowDetails(context: context, title: 'No. of Records', subTitle: noOfRecords),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().productListRowDetails(context: context, title: 'Date From', subTitle: dateFrom),
                      ],
                    ),
                    Widgets().verticalSpace(2.h)
                  ],
                ),
              ),
              Widgets().verticalSpace(1.5.h),
            ],
          ),
        ),
      ),
    );
  }

  //Stock details card
  Widget stockDetailsCardList({
    required BuildContext context,
    required Function() onTap,
    required String productCode,
    required String code,
    required String grossStock,
    required String unusableStock,
    required String warehouseCode,
    required String soldStock,
    required String sellableStock,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, -4),
            spreadRadius: 5,
          )
        ], color: white, borderRadius: BorderRadius.circular(1.5.h)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [textWidgetWithW500(titleText: "Product Code : $productCode", fontSize: 9.sp, textColor: curiousBlue)],
                ),
              ),
              Widgets().verticalSpace(1.5.h),
              Widgets().horizontalDivider(),
              Widgets().verticalSpace(2.5.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().stockDetailsRowDetails(context: context, title: 'Code', subTitle: code),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().stockDetailsRowDetails(context: context, title: 'Gross Stock', subTitle: grossStock),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().stockDetailsRowDetails(context: context, title: 'Unusable Stock', subTitle: unusableStock),
                        Widgets().verticalSpace(1.5.h),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().stockDetailsRowDetails(context: context, title: 'Warehouse Code', subTitle: warehouseCode),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().stockDetailsRowDetails(context: context, title: 'Sold Stock', subTitle: soldStock),
                        Widgets().verticalSpace(1.5.h),
                        Widgets().stockDetailsRowDetails(context: context, title: 'Sellable Stock', subTitle: sellableStock),
                      ],
                    ),
                    Widgets().verticalSpace(2.h)
                  ],
                ),
              ),
              Widgets().verticalSpace(1.5.h),
            ],
          ),
        ),
      ),
    );
  }

  //Notification screen
  Widget notificationCard(
      {required BuildContext context,
      required Color bgColor,
      required Color buttonTextColor,
      required String iconName,
      required String buttonTitle,
      required String dateAndTime,
      required String subtitle}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w, top: 2.5.h, bottom: 2.5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                    height: 7.h,
                    width: 15.w,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                    child: Center(child: SvgPicture.asset(iconName, height: 4.h)))
              ],
            ),
            Widgets().horizontalSpace(3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: bgColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                        child: colorTextWidgetWithW700(titleText: buttonTitle, fontSize: 9.sp, textColor: malachite),
                      ),
                    ),
                    Widgets().horizontalSpace(3.w),
                    Widgets().iconWithTextInRow(iconName: calender, titleText: dateAndTime, isTextColor: true),
                  ],
                ),
                Widgets().verticalSpace(2.h),
                SizedBox(width: MediaQuery.of(context).size.width * .6, child: textWidgetWithW500(titleText: subtitle, fontSize: 10.sp, textColor: codGray))
              ],
            )
          ],
        ),
      ),
    );
  }

  //Get on touch card
  Widget getInTouchCard({required String headOfficeAddress, required String phoneNumber1, required String phoneNumber2}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(1.5.h),
        child: Column(
          children: [
            Row(
              children: [Widgets().iconWithTextInRow(isTextColor: true, titleText: 'Head Office', iconName: addressSvg)],
            ),
            Widgets().verticalSpace(2.h),
            Widgets().textWidgetWithW400Max1(titleText: headOfficeAddress, fontSize: 10.sp, textColor: codGray),
            Widgets().verticalSpace(2.h),
            Row(
              children: [Widgets().iconWithTextInRow(isTextColor: true, titleText: 'Phone', iconName: phoneSvg)],
            ),
            Widgets().verticalSpace(2.h),
            Row(
              children: [
                Widgets().textWidgetWithW400(titleText: phoneNumber1, fontSize: 10.sp, textColor: codGray),
                Widgets().textWidgetWithW400(titleText: phoneNumber2, fontSize: 10.sp, textColor: codGray),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Box decoration with top right and top left radius color
  BoxDecoration boxDecorationTopLRRadius({required Color color, required double topLeft, required double topRight}) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
      ),
    );
  }

  //Draggable bottom sheet top heading container
  Widget draggableBottomSheetTopContainer({required String titleText}) {
    return Container(
      width: 100.w,
      height: 5.h,
      decoration: boxDecorationTopLRRadius(color: coralRed, topLeft: 2.h, topRight: 2.h),
      child: Center(
        child: Text(
          titleText,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: white),
        ),
      ),
    );
  }

  //Notification cart floating action button
  Widget notificationCartFAButton({required String notificationCount, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 4.h,
            backgroundColor: alizarinCrimson,
            child: SvgPicture.asset(
              cartIcon,
              height: 2.5.h,
              color: white,
            ),
          ),
          Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 1.5.h,
                backgroundColor: malachite,
                child: Center(
                  child: Widgets().textWidgetWithW500(titleText: notificationCount, fontSize: 9.sp, textColor: white),
                ),
              ))
        ],
      ),
    );
  }

  //Gradient
  LinearGradient gradientColor({required List<Color> gradientColorList}) {
    return LinearGradient(
      colors: gradientColorList,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  void loadingDataDialog({required String loadingText}) {
    Get.defaultDialog(
      title: "Processing...",
      contentPadding: const EdgeInsets.only(right: 0.0, left: 0),
      titleStyle: TextStyle(color: alizarinCrimson),
      backgroundColor: Colors.white,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, left: 4),
            child: CupertinoActivityIndicator(
              radius: 14,
            ),
          ),
          Text(loadingText),
        ],
      ),
      radius: 6.0,
      barrierDismissible: false,
    );
  }

  Widget geoCoordinatesButton({required Function() onTapGeoCoordinate, required String titleText}) {
    return Container(
      width: 32.w,
      height: 4.h,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              backgroundColor: alizarinCrimson,
              foregroundColor: white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5.h))),
          onPressed: onTapGeoCoordinate,
          icon: SvgPicture.asset(locationIcon, height: 3.h, color: white),
          label: textWidgetWithW500(titleText: titleText, fontSize: 8.sp, textColor: white)),
    );
    // return InkWell(
    //   onTap: onTapGeoCoordinate,
    //   child: Padding(
    //     padding: EdgeInsets.all(.7.h),
    //     child: Container(
    //       width: 32.w,
    //       height: 4.h,
    //       padding: EdgeInsets.all(1.5.h),
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5.h), color: alizarinCrimson),
    //       child: Row(
    //         children: [
    //           SvgPicture.asset(locationIcon, height: 3.h, color: white),
    //           horizontalSpace(1.w),
    //           textWidgetWithW500(titleText: titleText, fontSize: 8.sp, textColor: white)
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  //Ledger Report list card
  Widget ledgerReportListCard({
    required BuildContext context,
    required String invoiceNo,
    required String transactionType,
    required String chequeNo,
    required String debit,
    required String particulars,
    required String date,
    required String credit,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.5.h),
              child: richTextInRow(titleName: 'Invoice No', titleValue: invoiceNo, fontColor: curiousBlue),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            customLPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'Transaction Type', subTitle: transactionType),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Cheque No', subTitle: chequeNo),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Debit', subTitle: debit),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'Particulars', subTitle: particulars),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Date', subTitle: date),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Credit', subTitle: credit),
                        ],
                      ),
                      verticalSpace(2.h)
                    ],
                  ),
                  verticalSpace(2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Beats monthly details bottom sheet
  Future beatsMonthlyDetailsBottomSheet({
    required BuildContext context,
    required Function() onTapCountCustomerTile,
    required Function() onTapCancel,
    required Function() onTapBackWordIcon,
    required Function() onTapForwardIcon,
    required String currentDate,
    required String customerName,
    required String customerCount,
  }) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 3.w, left: 3.w, top: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(onTap: onTapBackWordIcon, child: const Icon(Icons.arrow_back_ios_rounded)),
                      horizontalSpace(3.w),
                      textWidgetWithW700(titleText: currentDate, fontSize: 13.sp),
                      horizontalSpace(3.w),
                      InkWell(onTap: onTapForwardIcon, child: const Icon(Icons.arrow_forward_ios_rounded))
                    ],
                  ),
                ),
                verticalSpace(2.h),
                customLRPadding(
                    child: tileWithTwoTextAndSingleIcon(
                        context: context,
                        customerName: customerName,
                        customerCount: customerCount,
                        subtitleIcon: rightArrowWithCircleIcon,
                        onTap: onTapCountCustomerTile)),
                verticalSpace(2.h),
                customLRPadding(child: dynamicButton(onTap: onTapCancel, height: 5.5.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white)),
                verticalSpace(2.h),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  BoxDecoration commonDecorationForTopLeftRightRadius() {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.w),
        topRight: Radius.circular(4.w),
      ),
    );
  }

  //Box decoration with background color
  BoxDecoration commonDecorationForTopLRRadiusWithBGColor({required Color bgColor}) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: bgColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.w),
        topRight: Radius.circular(4.w),
      ),
    );
  }

  //Box decoration with background color
  BoxDecoration commonDecorationForTopLR9WithBGColor({required Color bgColor}) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: bgColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(9.w),
        topRight: Radius.circular(9.w),
      ),
    );
  }

  Widget customCheckBoxWidget({required Function(bool?) onChanged, required bool initialValue, required double borderWidth}) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(.7.h)),
      activeColor: alizarinCrimson,
      side: BorderSide(width: borderWidth, color: checkBoxColor, style: BorderStyle.solid),
      value: initialValue,
      onChanged: onChanged,
    );
  }

  //Clock in out with Map screen and Image
  Widget clockInOutTileWithMapAndImageWidget({required Widget mapScreenWidget, required String imagePath, required Widget getAddressBlockCompressed}) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(1.h),
        child: Column(
          children: [
            Widgets().verticalSpace(2.h),
            SizedBox(
                width: 50.w,
                height: 24.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: mapScreenWidget,
                )),
            Widgets().verticalSpace(1.h),
            Stack(
              children: [
                SizedBox(
                  width: 50.w,
                  height: 24.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                      )),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 1.5.h,
                  child: getAddressBlockCompressed,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget drawerRowWithIconWidget({required String iconPath, required String labelText}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, height: 3.h, width: 3.w),
        horizontalSpace(5.w),
        textWidgetWithW500(titleText: labelText, fontSize: 11.sp, textColor: codGray)
      ],
    );
  }

  Widget drawerExpansionRowWithIcon({required String iconPath, required String labelText}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, height: 2.h, width: 2.w),
        Widgets().horizontalSpace(5.w),
        textWidgetWithW500(titleText: labelText, fontSize: 10.sp, textColor: codGray)
      ],
    );
  }

  Widget scaffoldWithAppBarDrawer({required Widget body, required BuildContext context, Color? backgroundColor, bool? isShowBackButton, Widget? floatingActionButton}) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MainAppBar(context, scaffoldKey, isShowBackButton: isShowBackButton ?? true),
      drawer: MainDrawer(context),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }

  Future beatsMonthlyEventDetailsBottomSheet(
      {required BuildContext context,
      required List<BeatsEventData> eventsList,
      required Function() onTapCountCustomerTile,
      required Function() onTapCancel,
      required Function() onTapBackWordIcon,
      required Function() onTapForwardIcon,
      required String currentDate,
      required Widget listViewDataWidget}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 3.w, left: 3.w, top: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(onTap: onTapBackWordIcon, child: const Icon(Icons.arrow_back_ios_rounded)),
                      horizontalSpace(3.w),
                      textWidgetWithW700(titleText: currentDate, fontSize: 13.sp),
                      horizontalSpace(3.w),
                      InkWell(onTap: onTapForwardIcon, child: const Icon(Icons.arrow_forward_ios_rounded))
                    ],
                  ),
                ),
                verticalSpace(2.h),
                listViewDataWidget,
                verticalSpace(2.h),
                customLRPadding(child: dynamicButton(onTap: onTapCancel, height: 5.5.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white)),
                verticalSpace(2.h),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Preview order select info bottom sheet
  Future myBeatFullAddressBottomSheetMyBeat(
      {required BuildContext context, required TextEditingController controller, required String customersOnLocationText, required Widget listViewDataWidget}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, left: 3.w, right: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidgetWithW700(titleText: customersOnLocationText, fontSize: 13.sp),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                ),
                verticalSpace(2.5.h),
                horizontalDivider(),
                verticalSpace(2.5.h),
                Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: textFieldWidget(controller: controller, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: zumthor)),
                      verticalSpace(2.h),
                      listViewDataWidget,
                      verticalSpace(2.5.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Customer Profile expantion card
  Widget topCustomerAdminExpansionTiles({
    required BuildContext context,
    required String customerName,
    required String customerCode,
    required String customerAddress,
  }) {
    return Container(
      decoration: BoxDecoration(color: twilightBlue, borderRadius: BorderRadius.circular(1.5.h), border: Border.all(color: pattensBlue, width: 2.0)),
      child: Widgets().expansionDrawerItemBox2(
        () {},
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: 0,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(0),
              title: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Row(children: [
                  //horizontalSpace(4.w),
                  Text(
                    customerName,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: codGray),
                  ),
                  horizontalSpace(2.w),
                  Text(
                    customerCode,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: curiousBlue),
                  )
                ]),
              ),
              children: [
                Container(
                  color: white,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(1.h),
                        textWidgetWithW700(titleText: 'Address', fontSize: 13.sp),
                        verticalSpace(1.h),
                        textWidgetWithW500(titleText: customerAddress, fontSize: 9.sp, textColor: codGray),
                        verticalSpace(1.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //adminRetaier expantion card
  Widget adminRetaierExpantionCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String address,
    required String beat,
    required String city,
    required String state,
    bool? isVerified = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 5, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                            Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
                            (isVerified!)
                                ? Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                      shopVerified,
                                      height: 2.h,
                                    ))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: .5.h),
                        child: Column(
                          children: [
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                            verticalSpace(1.h),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                            verticalSpace(1.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            verticalSpace(1.h),
          ],
        ),
      ),
    );
  }

  //Date picker
  Widget datePickerCheckout(
      {required BuildContext context,
      required Function() onTap,
      required TextEditingController controller,
      String? hintText,
      required double width,
      required Function(DateTime) onDateTimeChanged}) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(color: white, borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: Column(
                  children: [
                    Center(
                        child: SizedBox(
                      height: 30.h,
                      child: CupertinoDatePicker(
                        minimumYear: DateTime.now().year,
                        minimumDate: DateTime.now(),
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: onDateTimeChanged,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    )),
                    Widgets().dynamicButton(onTap: onTap, height: 5.5.h, width: 22.0.h, buttonBGColor: alizarinCrimson, titleText: submit, titleColor: white),
                    SizedBox(height: 2.2.h),
                  ],
                )),
          ),
          barrierColor: Colors.transparent,
          // isDismissible: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
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
                      decoration: InputDecoration.collapsed(hintText: hintText ?? "Hint Text", hintStyle: TextStyle(fontSize: 10.sp)),
                    ))),
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: SvgPicture.asset(
                dateTime,
                height: 2.3.h,
                width: 2.3.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future beatsMonthlyEventDetailsBottomSheetMyBeat(
      {required BuildContext context,
      required List<BeatsEventData> eventsList,
      required Function() onTapCountCustomerTile,
      required Function() onTapCancel,
      required String currentDate,
      required Widget listViewDataWidget}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 3.w, left: 3.w, top: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // InkWell(onTap: onTapBackWordIcon, child: const Icon(Icons.arrow_back_ios_rounded)),
                      horizontalSpace(3.w),
                      textWidgetWithW700(titleText: currentDate, fontSize: 13.sp),
                      horizontalSpace(3.w),
                      //  InkWell(onTap: onTapForwardIcon, child: const Icon(Icons.arrow_forward_ios_rounded))
                    ],
                  ),
                ),
                verticalSpace(2.h),
                listViewDataWidget,
                verticalSpace(2.h),
                customLRPadding(child: dynamicButton(onTap: onTapCancel, height: 5.5.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white)),
                verticalSpace(2.h),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Order is generated bottom sheet
  Future orderIsGeneratedForNoOrderBottomSheet({required BuildContext context, required String userEmailId, required Function() onTap, required String message}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Image.asset(tick),
                  verticalSpace(2.5.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "Your $message is submitted.",
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpace(2.5.h),
                  Text(
                    "Thank you, your $message is successful. A confirmation msg has been sent via sms and email : $userEmailId",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(2.h),
                  dynamicButton(onTap: onTap, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white)
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  Widget EmployeeAttendanceExpantionCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String login,
    required String logout,
    required String date,
    required String zone,
    required String city,
    required String state,
    required Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp),
                            ),
                            horizontalSpace(2.h),
                            textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: .5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Login Time', subTitle: login),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Log Out Time', subTitle: logout),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Date', subTitle: date),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Zone', subTitle: zone),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'State Code', subTitle: state),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                            verticalSpace(1.h),
                            GestureDetector(
                              onTap: onTap,
                              child: const Text(
                                'Track Employee',
                                style: TextStyle(color: Color(0xff5E92DF), fontSize: 10, decoration: TextDecoration.underline, fontWeight: FontWeight.w700),
                              ),
                            ),
                            verticalSpace(2.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget retialersProfileExpantionCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String creditLimit,
    required String outstanding,
    required String overdue,
    required Function() callingOnTap,
    required Function() noteDetailsOnTap,
    required Function() locationOnTap,
    required Function() viewDetailsOnTap,
    bool? isVerified = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 5, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                            Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
                            (isVerified!)
                                ? Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                      shopVerified,
                                      height: 2.h,
                                    ))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    trailing: const SizedBox(),
                  ),
                ),
              ),
            ),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    verticalSpace(1.h),
                    primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                    verticalSpace(1.h),
                    primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                    verticalSpace(1.h),
                    primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                    verticalSpace(1.h),
                    verticalSpace(1.h),
                    primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                    verticalSpace(1.h),
                  ],
                ),
                verticalSpace(1.h),
                InkWell(onTap: viewDetailsOnTap, child: textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue)),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: noteDetailsOnTap,
                  child: SvgPicture.asset(
                    noteDetailsIcon,
                    height: 4.h,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 4.h,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: locationOnTap,
                  child: SvgPicture.asset(
                    locationSvg,
                    height: 4.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget AdminDealerDetailCard({
    required BuildContext context,
    required String power,
    required String iaq,
    required String lighting,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: textWidgetWithW700(titleText: 'Dealer Details', fontSize: 9.sp)),
              ],
            ),
          ),
          Divider(color: veryLightBoulder.withOpacity(0.1), thickness: 1),
          customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Power Dealer', subTitle: power),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'IAQ Dealer', subTitle: iaq),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(
                  context: context,
                  title: 'Lighting Dealer',
                  subTitle: lighting,
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget retailercolorContainer({
    required Color bgColor,
    required Color borderColor,
    required String iconName,
    Color? iconColor,
    required String titleText,
    required String subTitleText,
  }) {
    return Container(
      width: 29.w,
      //width: 45.w,
      height: 20.h,
      decoration: commonDecoration(borderRadius: 10, bgColor: bgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Widgets().verticalSpace(0.5.h),
          Container(
              height: 7.h,
              width: 15.w,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  iconName,
                  color: iconColor,
                )),
              )),
          Widgets().verticalSpace(0.5.h),
          Text(
            titleText,
            style: TextStyle(fontSize: 15.sp, color: codGray, fontWeight: FontWeight.w600),
          ),
          Widgets().verticalSpace(0.5.h),
          Text(
            subTitleText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: codGray),
          ),
        ],
      ),
    );
  }

  Container newOrderUserNameDetailsTileWithVerify({required BuildContext context, required String titleName, required String titleValue}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [magicMint, oysterBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            horizontalSpace(2.w),
            Expanded(flex: 4, child: textWidgetWithW700(titleText: titleName, fontSize: 10.sp)),
            Expanded(flex: 4, child: textWidgetWithW400(titleText: titleValue, fontSize: 10.sp, textColor: curiousBlue)),
            SvgPicture.asset(shopVerified)
          ],
        ),
      ),
    );
  }

  Widget retailerDetailsExpantionCard({
    required BuildContext context,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String creditLimit,
    required String outstanding,
    required String overdue,
    required String phoneNumber,
    required String verify,
    required Function() callingOnTap,
    required Function() locationOnTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Credit Limit', subTitle: creditLimit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Overdue ', subTitle: overdue),
                verticalSpace(1.h),
                //primaryOrderRowDetails(context: context, title: 'Phone Number ', subTitle: phoneNumber),
                primaryOrderRowDetailsWithStatus(context: context, title: 'Phone Number ', subTitle: "+91 $phoneNumber", verify: verify),

                //textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 4.h,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: locationOnTap,
                  child: SvgPicture.asset(
                    locationIcon,
                    height: 4.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget AdmincustomerNoOrderCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String orderId,
    required String beat,
    required String city,
    required String state,
    required String date,
    required String reason,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
                // const Icon(Icons.keyboard_arrow_up)
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'No Order ID', subTitle: orderId),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Date', subTitle: date),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Reason', subTitle: reason),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AdmincustomerNoOrderDetailCard({
    required BuildContext context,
    required String reason,
    required String remark,
    required String attachment,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: textWidgetWithW700(titleText: 'No Order Details', fontSize: 9.sp)),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Reason', subTitle: reason),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Remark', subTitle: remark),
                Widgets().verticalSpace(1.h),
                rowWithStatusColorText(context: context, title: 'Attachment', subTitle: attachment, textColor: const Color(0xff2D77E5)),
                Widgets().verticalSpace(1.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget neworderListCardWithStatus({
    required BuildContext context,
    required String customerCode,
    required String statusTitle,
    required String orderDateValue,
    required String orderId,
    required String orderQtyValue,
    required String orderValue,
    required Color statusColor,
    required Function() onTapOrderDetail,
    required String customerName,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: richTextInRow2(titleName: customerName, titleValue: customerCode, fontColor: curiousBlue)),
                  statusContainer(statusColor: statusColor, statusTitle: statusTitle)
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 8.w,
                      height: 4.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(.7.h),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(.7.h),
                        child: SvgPicture.asset(
                          cartSvgIcon,
                          height: 3.h,
                          //width: 8.w,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(1.h),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        previousOrderListRowDetails(context: context, title: 'Order ID ', subTitle: orderId),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Date ', subTitle: orderDateValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Qty ', subTitle: orderQtyValue),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Order Value ', subTitle: orderValue),
                        verticalSpace(1.h),
                        Row(
                          children: [
                            InkWell(
                              onTap: onTapOrderDetail,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidgetWithW500(titleText: 'Order Detail', fontSize: 11.sp, textColor: curiousBlue),
                                  horizontalSpace(2.w),
                                  SvgPicture.asset(rightArrow, height: 1.5.h)
                                ],
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(2.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
            verticalSpace(1.h),
          ],
        ),
      ),
    );
  }

  Widget newOrderDetailListCard({required BuildContext context, required String productDetailText, required String qtyValue, required String totalPriceValue}) {
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
              child: orderListCardWithoutIcon(
                context: context,
                productDetailText: productDetailText,
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                children: [
                  productListRowDetails(context: context, title: 'QTY', subTitle: qtyValue),
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
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  Widget richTextInRow2({required String titleName, required String titleValue, required Color fontColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: titleName,
            style: TextStyle(
              color: veryLightBoulder,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: "   $titleValue",
            style: TextStyle(
              color: fontColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget orderListCardWithoutIcon({required BuildContext context, required String productDetailText}) {
    return Row(
      children: [
        Widgets().horizontalSpace(3.w),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Text(
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
        ),
        const Spacer(),
      ],
    );
  }

  Widget secRetailerNameAndCodeTile({required String retailerDetail}) {
    return Container(
      height: 6.h,
      decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: titanWhite),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 2.5.w),
            child: Widgets().textWidgetWithW500WithCenterAlign(titleText: retailerDetail, fontSize: 10.sp, textColor: codGray),
          )),
    );
  }

  Container noOrdersExpansionTile({required BuildContext context, required Widget textFiedWidget, required Widget datePickerWidget, required Function() onTap}) {
    return Container(
      decoration: commonDecoration(borderRadius: 1.5.h, bgColor: magnolia),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: textWidgetWithW700(titleText: "Last 7 Days", fontSize: 11.sp),
                  children: [
                    verticalSpace(1.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidgetWithW700(titleText: "Current Month", fontSize: 10.sp),
                        verticalSpace(2.h),
                        horizontalDivider(),
                        verticalSpace(2.h),
                        customLRPadding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textFiedWidget,
                              verticalSpace(2.h),
                              datePickerWidget,
                              verticalSpace(2.h),
                              dynamicButton(onTap: onTap, height: 5.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "Apply", titleColor: white),
                              verticalSpace(2.h),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFieldWidgetWithoutIcon(
      {required TextEditingController controller, required String hintText, required TextInputType keyBoardType, required Color fillColor}) {
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
        controller: controller,
        keyboardType: keyBoardType,
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
        ),
      ),
    );
  }

  Widget outstandingAmountCard({
    required BuildContext context,
    required String credit,
    required String outstanding,
    required String overdue,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  richTextInRow(titleName: 'Business Unit  ', titleValue: "LIGHTING", fontColor: curiousBlue),
                ],
              ),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 8.w,
                      height: 4.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(.7.h),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(.7.h),
                        child: SvgPicture.asset(
                          outstanging,
                          height: 3.h,
                          //width: 8.w,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(1.h),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        previousOrderListRowDetails(context: context, title: 'Credit Limit ', subTitle: credit),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                        verticalSpace(2.h),
                        previousOrderListRowDetails(context: context, title: 'Overdue ', subTitle: overdue),
                        verticalSpace(1.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
            verticalSpace(1.h),
          ],
        ),
      ),
    );
  }

  //Date picker
  Widget datePickerBlock({
    required BuildContext context,
    required Function() onTap,
    required TextEditingController controller,
    String? hintText,
    required double width,
    double? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(borderRadius ?? 1.h),
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
                      decoration: InputDecoration.collapsed(hintText: hintText ?? "Hint Text", hintStyle: TextStyle(fontSize: 10.sp)),
                    ))),
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: SvgPicture.asset(
                dateTime,
                height: 2.3.h,
                width: 2.3.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  //Edit Order bottom sheet
  Future editOrderSecondaryBottomSheet({
    required BuildContext context,
    required Widget productListCardWidget,
    required Function() saveButton,
  }) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(4.h), topLeft: Radius.circular(4.h))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, left: 6.w, right: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Order",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                ),
                verticalSpace(2.5.h),
                horizontalDivider(),
                verticalSpace(2.h),
                productListCardWidget,
                verticalSpace(1.5.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                  ),
                  child: dynamicButton(onTap: saveButton, height: 6.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "Save", titleColor: white),
                ),
                verticalSpace(1.5.h),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,

      // isDismissible: false,
    );
  }

  //Product list card
  Widget productListSecondayCard(
      {required BuildContext context,
      required String productDetailText,
      required Function() deleteOnTap,
      required String skuCodeValue,
      required String mrpValue,
      required String sqValue,
      required String availableQtyValue,
      required String dlpValue,
      required String mqValue,
      required String lastOdValue,
      required Function() onTapDecrease,
      required Function() onTapInCrease,
      //required String qtyText,
      required TextEditingController qtyTextController,
      required Function(String) onChanged,
      required String totalValueText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: .5.h),
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
              child: productListCardTopRow(
                  context: context,
                  iconName: pcDowmLightIcon,
                  productDetailText: productDetailText,
                  iconWidget: Row(
                    children: [InkWell(onTap: deleteOnTap, child: Image.asset(deleteIcon)), horizontalSpace(1.h)],
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            customLPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(2.h),
                  richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                  verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'RLP', subTitle: " ₹ $dlpValue"),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'SQ', subTitle: sqValue),
                          verticalSpace(1.h),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListRowDetails(context: context, title: 'MQ', subTitle: mqValue),
                          verticalSpace(1.h),
                          productListRowDetails(context: context, title: 'Last OD', subTitle: lastOdValue),
                          verticalSpace(1.h),
                        ],
                      ),
                      verticalSpace(2.h)
                    ],
                  ),
                  verticalSpace(2.h),
                  Row(
                    children: [
                      //increaseDecreaseButton(onTapDecrease: onTapDecrease, onTapInCrease: onTapInCrease, qtyText: qtyText),
                      increaseDecreaseButtonWithTextField(
                          onTapInCrease: onTapInCrease, onTapDecrease: onTapDecrease, qtyTextController: qtyTextController, onChanged: onChanged),
                      horizontalSpace(3.w),
                      Text(
                        totalValueText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 12.sp, letterSpacing: .3),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                  verticalSpace(2.h),
                  Text(
                    "Total Ordered QTY = $sqValue * ${qtyTextController.text}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: codGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  verticalSpace(2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //New order detail
  Widget retailerNewOrderListCard1({
    required BuildContext context,
    required Color cardColor,
    required bool initialValue,
    required void Function(bool?) onChanged,
    required String productDetailText,
    required Color checkBoxBGColor,
    required String skuCodeValue,
    required String availableQtyValue,
    required String district,
    required String lastOD,
    required String iconName,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 5,
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: productListCardWithoutIcon(
                  context: context,
                  iconName: iconName,
                  productDetailText: productDetailText,
                  iconWidget: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(.5.h)),
                    activeColor: alizarinCrimson,
                    side: BorderSide(width: 9, color: checkBoxBGColor, style: BorderStyle.solid),
                    value: initialValue,
                    onChanged: onChanged,
                  )),
            ),
            Container(width: 100.w, height: 1, color: lightBoulder),
            verticalSpace(2.h),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextInRow(titleName: 'SKU Code ', titleValue: skuCodeValue, fontColor: curiousBlue),
                verticalSpace(1.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: productListRowDetails1(context: context, title: 'Disti ', subTitle: district),
                    ),
                    verticalSpace(1.h),
                    Expanded(flex: 1, child: productListRowDetails1(context: context, title: 'Last OD ', subTitle: lastOD)),
                  ],
                ),
              ],
            )),
            verticalSpace(2.h)
          ],
        ),
      ),
    );
  }

  Widget productListRowDetails1({required BuildContext context, required String title, required String subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          " :",
          style: TextStyle(
            color: codGray,
            fontWeight: FontWeight.w700,
            fontSize: 9.sp,
          ),
          textAlign: TextAlign.center,
        ),
        //Widgets().horizontalSpace(1.h),
        Expanded(
          flex: 1,
          child: Text(
            subTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: codGray,
              fontWeight: FontWeight.w400,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  //Order is generated bottom sheet
  Future orderRetailerCheckoutBottomSheet(
      {required BuildContext context, required String userEmailId, required Function() onTap, required String message, required String orderNumber}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Image.asset(tick),
                  verticalSpace(2.5.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "Your $message is submitted.\nOrder number : $orderNumber",
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpace(2.5.h),
                  Text(
                    "Thank you, your $message is successful. A confirmation msg has been sent via sms and email : $userEmailId",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: codGray, fontWeight: FontWeight.w400, fontSize: 11.sp, letterSpacing: .3),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(2.h),
                  dynamicButton(onTap: onTap, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white)
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  Widget adminDealerDetailCard({
    required BuildContext context,
    required String power,
    required String iaq,
    required String lighting,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: textWidgetWithW700(titleText: 'Dealer Details', fontSize: 9.sp)),
              ],
            ),
          ),
          Divider(color: veryLightBoulder.withOpacity(0.1), thickness: 1),
          customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Power Dealer', subTitle: power),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'IAQ Dealer', subTitle: iaq),
                Widgets().verticalSpace(1.h),
                primaryOrderRowDetails(
                  context: context,
                  title: 'Lighting Dealer',
                  subTitle: lighting,
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Genric Drop Down Button
  Widget commonDropdownGenric<T>({
    void Function(T?)? onChanged,
    double? width,
    required String hintText,
    T? selectedValue,
    required List<DropdownMenuItem<T>> items,
  }) {
    return Container(
      height: 6.h,
      width: width ?? 100.w,
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Center(
        child: DropdownButton<T>(
          underline: DropdownButtonHideUnderline(child: Container()),
          isExpanded: true,
          isDense: true,
          focusColor: alizarinCrimson,
          // Adjust color as needed
          iconSize: 3.h,
          icon: const Icon(Icons.keyboard_arrow_down_sharp),
          value: selectedValue,
          style: const TextStyle(color: Colors.black),
          iconEnabledColor: codGray,
          items: items,
          hint: Text(
            hintText,
            style: TextStyle(fontSize: 10.sp),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  //Retailer Profile expantion card
  Widget retailerProfileExpantionCard({
    required BuildContext context,
    required String shopTitleText,
    required String customerCode,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String remark,
    required Function() callingOnTap,
    required Function() noteDetailsOnTap,
    required Function() locationOnTap,
    required Function() viewDetailsOnTap,
    required bool isVerified,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().expansionDrawerItemBox1(
              () {},
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 5, child: textWidgetWithW700(titleText: shopTitleText, fontSize: 9.sp)),
                            Expanded(flex: 4, child: textWidgetWithW400(titleText: customerCode, fontSize: 9.sp, textColor: curiousBlue)),
                            Expanded(
                                flex: 1,
                                child: SvgPicture.asset(
                                  shopVerified,
                                  color: isVerified ? null : Colors.grey,
                                  height: 2.h,
                                ))
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: .5.h),
                        child: Column(
                          children: [
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                            verticalSpace(1.h),
                            verticalSpace(1.h),
                            primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                            verticalSpace(1.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                primaryOrderRowDetails(context: context, title: 'Remark', subTitle: remark),
                verticalSpace(1.h),
                InkWell(onTap: viewDetailsOnTap, child: textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue)),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: noteDetailsOnTap,
                  child: SvgPicture.asset(
                    noteDetailsIcon,
                    height: 6.w,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 6.w,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: () async {
                    locationOnTap();
                  },
                  child: SvgPicture.asset(
                    locationIcon,
                    height: 6.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //This bootom sheet can be used to show verification message
  Future verificationBottomSheet({required BuildContext context, String? imgIcon, required Function() onTapOk, required String message, bool showCloseIcon = false}) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 5,
            )
          ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCloseIcon)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(closeIcon))
                      ],
                    ),
                  Image.asset(imgIcon ?? tick),
                  verticalSpace(2.5.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      message,
                      style: TextStyle(color: codGray, fontWeight: FontWeight.w700, fontSize: 13.sp, letterSpacing: .3),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  verticalSpace(5.5.h),
                  dynamicButton(onTap: onTapOk, height: 4.7.h, width: 40.w, buttonBGColor: alizarinCrimson, titleText: "OK", titleColor: white)
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  /// Retailer Profile Details Card
  Widget retailerProfileDetailsExpantionCard({
    required BuildContext context,
    required String address,
    required String beat,
    required String city,
    required String state,
    required String creditLimit,
    required String outstanding,
    required String overdue,
    required String phoneNumber,
    required bool verify,
    required Function() callingOnTap,
    required Function() locationOnTap,
    required Function() onVerifyClick,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Container(
        decoration: commonDecoration(borderRadius: 1.5.h, bgColor: white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customLRPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(2.h),
                primaryOrderRowDetails(context: context, title: 'Address', subTitle: address),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Beat', subTitle: beat),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'City', subTitle: city),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'State', subTitle: state),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Credit Limit', subTitle: creditLimit),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Outstanding ', subTitle: outstanding),
                verticalSpace(1.h),
                primaryOrderRowDetails(context: context, title: 'Overdue ', subTitle: overdue),
                verticalSpace(1.h),
                // primaryOrderRowDetails(context: context, title: 'Phone Number ', subTitle: phoneNumber),
                primaryOrderRowDetailsWithStatus(
                    context: context,
                    title: 'Phone Number ',
                    subTitle: "+91 $phoneNumber",
                    verify: verify ? "" : "Verify",
                    onVerifyClick: () {
                      onVerifyClick();
                    }),

                //textWidgetWithW500(titleText: "View details>>", fontSize: 11.sp, textColor: curiousBlue),
              ],
            )),
            verticalSpace(1.h),
            Container(width: 100.w, height: 1, color: lightBoulder),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: callingOnTap,
                  child: SvgPicture.asset(
                    callingIcon,
                    height: 4.h,
                  ),
                ),
                verticalDivider8(),
                InkWell(
                  onTap: locationOnTap,
                  child: SvgPicture.asset(
                    locationIcon,
                    height: 4.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
