import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../login/ui/login.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Widgets().verticalSpace(4.h),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                anchorPanasonicLogo,
                height: 8.h,
                fit: BoxFit.fill,
              ),
            ),
            Widgets().verticalSpace(0.8.h),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                bestLogo,
                height: 15.h,
                fit: BoxFit.fill,
              ),
            ),
            Widgets().verticalSpace(4.h),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                introGroupImage1,
                height: 30.h,
                width: 80.w,
                fit: BoxFit.fill,
              ),
            ),
            Widgets().verticalSpace(4.h),
            Widgets().customLRPadding(
                child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: Widgets()
                  .commonDecoration(borderRadius: 1.5.h, bgColor: white),
              child: Column(
                children: [
                  Widgets().verticalSpace(2.h),
                  Text(
                    welcomeToPanasonic,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0.sp, fontWeight: FontWeight.w500),
                  ),
                  Widgets().verticalSpace(2.h),
                  Text(
                    welcomeDescriptionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w400,
                        color: boulder),
                  ),
                  Widgets().verticalSpace(4.h),
                  Widgets().dynamicButton(
                      onTap: () {
                        //globalController.isLogin ? Get.offAll(const ClockInOut()) :
                        Get.offAll(() => const Login());
                      },
                      height: 6.h,
                      width: 40.w,
                      buttonBGColor: alizarinCrimson,
                      titleText: getStarted,
                      titleColor: white),
                  Widgets().verticalSpace(2.h),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
