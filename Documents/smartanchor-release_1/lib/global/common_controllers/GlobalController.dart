import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/primary_order/PrimaryOrder.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/ui/secondary_order/SecondaryOrder.dart';

import '../../views/home_module/BottomNavigation/LandingPage.dart';

class GlobalController extends GetxController {
  final box = GetStorage();

  bool get isFirstTimeIntro => box.read('isFirstTimeIntro') ?? true;

  bool get isLogin => box.read('isLogin') ?? false;

  bool get isClockIn => box.read('isClockIn') ?? false;

  String get customerScreenName => box.read('customerScreenName') ?? "";

  String get userName => box.read('userName') ?? "";

  String get customerName => box.read('customerName') ?? "";

  String get customerCode => box.read('customerCode') ?? "";

  String get role => box.read('role') ?? "";

  String get customerEmailAddress => box.read('customerEmailAddress') ?? "";

  String get lastOrderRemark => box.read('lastOrderRemark') ?? "";

  //String get userId => "2043771";

  int get userId => box.read('userId') ?? 0;

  String get userProfilePic => box.read('userProfilePic') ?? "";

  String get appVersion => box.read('appVersion') ?? "";

  // String get role => 'TSI'; = a06144
  // String get role => 'LAS';
  //String get role => 'ASM';
  //String get role => 'NSM';
  //String get role => 'ZSM';

//---------------------------------------------------------------------------------\

  saveLoginState({bool? isLogin, bool? isClockIn, bool? isFirstTimeIntro, String? customerScreenName, String? userName, String? role, int? userId}) {
    if (isLogin != null) {
      setIntroScreenFlag('isLogin', isLogin);
    }
    if (userName != null) {
      setIntroScreenFlag('userName', userName);
    }
    if (isFirstTimeIntro != null) {
      setIntroScreenFlag('isFirstTimeIntro', isFirstTimeIntro);
    }
    if (role != null) {
      setIntroScreenFlag('role', role);
    }
    if (isClockIn != null) {
      setIntroScreenFlag('isClockIn', isClockIn);
    }
    if (customerScreenName != null) {
      setIntroScreenFlag('customerScreenName', customerScreenName);
    }
    if (userId != null) {
      setIntroScreenFlag('userId', userId);
    }
  }

  setIntroScreenFlag(String key, value) {
    printAchievement("Stored data for $key : $value");
    box.write(key, value);
  }

  setCustomerName(String customerName) async {
    if (customerName.isNotEmpty) {
      await box.write('customerName', customerName);
      printMe("Customer customerName is : $customerName");
    }
  }

  setCustomerCode(String customerCode) async {
    if (customerCode.isNotEmpty) {
      await box.write('customerCode', customerCode);
      printMe("Customer code is : $customerCode");
    }
  }

  setUserProfilePic(String userProfilePic) async {
    if (userProfilePic.isNotEmpty) {
      await box.write('userProfilePic', userProfilePic);
    }
  }

  setAppVersion(String appVersion) async {
    if (appVersion.isNotEmpty) {
      await box.write('appVersion', appVersion);
    }
  }

  setCustomerEmailAddress({required String customerEmailAddress}) async {
    if (customerEmailAddress.isNotEmpty) {
      await box.write('customerEmailAddress', customerEmailAddress);
      printMe("customerEmailAddress code is : $customerEmailAddress");
    }
  }

  setLastOrderRemark({required String lastOrderRemark}) async {
    if (lastOrderRemark.isNotEmpty) {
      await box.write('lastOrderRemark', lastOrderRemark);
      printMe("Last Order Remark : $lastOrderRemark");
    }
  }

  void splashNavigation() {
    Get.offAll(() => const LandingPage(selectedItemIndex: 0));
  }

  void secondaryNavigation({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondaryOrder()));
  }

  void primaryOrderNavigation({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrimaryOrder(navigationTag: "PrimaryOrder")));
  }

  clearAllData() async {
    await box.erase();
  }
}
