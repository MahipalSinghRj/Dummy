import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/PermissionController.dart';
import '../../../attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';

class LocationCheckScreen extends StatefulWidget {
  final String title;
  final String subTitle;
  final String useCaseText;
  final String image;
  final String btnNameLeft;
  final String btnNameRight;
  final Function() onTapLeft;
  final Function() onTapRight;

  const LocationCheckScreen({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.useCaseText,
    required this.image,
    required this.btnNameLeft,
    required this.btnNameRight,
    required this.onTapLeft,
    required this.onTapRight,
  }) : super(key: key);

  @override
  State<LocationCheckScreen> createState() => _LocationCheckScreenState();
}

class _LocationCheckScreenState extends State<LocationCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets().verticalSpace(6.h),
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Widgets().verticalSpace(5.h),
            Text(
              widget.subTitle,
              style: TextStyle(
                color: codGray,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
            Widgets().verticalSpace(2.h),
            Text(
              widget.useCaseText,
              style: TextStyle(
                color: codGray,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
            Widgets().verticalSpace(10.h),
            (widget.image.isEmpty) ? const SizedBox() : Center(child: Image.asset(widget.image)),
            Widgets().verticalSpace(2.h),
            const Spacer(),
            Row(
              children: [
                // Expanded(
                //   flex: 1,
                //   child:  Widgets().dynamicButton(onTap: widget.onTapLeft, height: 5.5.h, width: 32.w, buttonBGColor: veryLightBoulder, titleText: widget.btnNameLeft, titleColor: white),),
                // SizedBox(width: 10.w,),
                Expanded(
                  flex: 1,
                  child: Widgets().dynamicButton(
                      onTap: widget.onTapRight, height: 5.5.h, width: 32.w, buttonBGColor: alizarinCrimson, titleText: widget.btnNameRight, titleColor: white),
                )
              ],
            ),
            Widgets().verticalSpace(2.h),
          ],
        ),
      ),
    ));
  }
}
