import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/ui/ClockInOut.dart';

import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../../../utils/PermissionController.dart';
import '../../../admin_module/home_module/bottomNavigation/LandingPageAdmin.dart';
import '../../../attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';
import '../../../home_module/BottomNavigation/LandingPage.dart';
import '../../intro_screen/ui/IntroScreen.dart';
import '../../login/ui/login.dart';
import '../../otp_screen/controllers/OtpController.dart';
import 'location_check_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Duration duration = const Duration(seconds: 3);
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  OtpController otpController = Get.put(OtpController());
  PermissionController permissionController = Get.put(PermissionController());

  @override
  void initState() {
    super.initState();

    printMe("App Role : ${globalController.role}");

    Future.delayed(duration, () {
      checkPermission();
    });
  }

  checkPermission() async {
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String appVersion = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      printMe("Device appName : $appName");
      printMe("Device packageName : $packageName");
      printMe("Device version : $appVersion");
      printMe("Device buildNumber : $buildNumber");

      setState(() {
        globalController.setAppVersion(appVersion);
      });
    }

    bool status = await permissionController.locationServiceAndPermissionEnabled();
    printMe("Location Permission : $status");
    if (!status) {
      Get.to(LocationCheckScreen(
          title: "Use your location",
          subTitle: "To see the map for auto-fetch latitude and longitude from current location.",
          useCaseText: "BEST application collect the location data to show current location on the map even when the app is closed or not in use.",
          image: locationMapIcon,
          btnNameLeft: "DENY",
          btnNameRight: "CONTINUE",
          onTapLeft: () {
            Get.back();
            splashNavigation();
          },
          onTapRight: () async {
            ViewLocationOnMapController viewLocationOnMapController = Get.put(ViewLocationOnMapController());
            await viewLocationOnMapController.checkLocationPermissionAndService();
            Get.back();
            splashNavigation();
          }));
    } else {
      splashNavigation();
    }
  }

  void splashNavigation() async {
    if (globalController.isFirstTimeIntro) {
      globalController.saveLoginState(isFirstTimeIntro: false);
      Get.off(const IntroScreen());
    } else if (globalController.isLogin) {
      await otpController.saveLoginFromUserDetails(globalController.customerScreenName.toString());
      if (globalController.role == "ASM" || globalController.role == "ZSM" || globalController.role == "NSM") {
        // new admin
        Get.offAll(() => const LandingPageAdmin(selectedItemIndex: 0));
      } else {
        globalController.isClockIn
            ? Get.offAll(() => const LandingPage(selectedItemIndex: 0))
            : dateTimeUtils.isMorning
                ? Get.offAll(() => const ClockInOut())
                : Get.offAll(() => const LandingPage(selectedItemIndex: 0));
      }
    } else {
      Get.offAll(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 8.h, 0, 4.h),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(splashScreenBG), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset(bestSplashLogo),
            Center(
              child: Text(
                "© 2023 - Panasonic Electric Works India Pvt Ltd for the copyrights",
                style: TextStyle(color: white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
