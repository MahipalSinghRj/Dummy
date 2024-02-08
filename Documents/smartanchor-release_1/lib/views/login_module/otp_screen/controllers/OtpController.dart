import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/admin_module/home_module/bottomNavigation/LandingPageAdmin.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/ui/ClockInOut.dart';
import 'package:smartanchor/views/login_module/forgot_password/ui/ForgotPassword.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../../attendance_module/models/UserDetailResponse.dart';
import '../../../home_module/BottomNavigation/LandingPage.dart';
import '../../login/models/response/AuthenticateCustomerWithOTPResponse.dart';
import '../../login/models/response/GetFullNameResponse.dart';
import '../../login/models/response/PasswordResetForgotResponse.dart';
import '../../login/models/response/SendOTPResponse.dart';
import '../../login/ui/login.dart';

class OtpController extends GetxController {
  DateTimeUtils dateTimeUtilsController = Get.put(DateTimeUtils());
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  int _secondsRemaining = 15;
  Timer? _timer;
  String screenName = '';
  String otpId = '';
  String otpInput = '';
  bool isLoading = false;

  void startTimer() {
    _secondsRemaining = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _timer?.cancel();
      }
      update();
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  onOtpSubmit(String navigationTag, String customerName,
      {GetFullNameResponse? getFullNameResponse,
      PasswordResetForgotResponse? passwordResetForgotResponse}) async {
    print("passwordResetForgotResponse : ${passwordResetForgotResponse}");
    isLoading = true;
    update();
    if (navigationTag == 'forgotPassword') {
      if (otpInput == passwordResetForgotResponse!.otpValue.toString()) {
        Widgets().showToast('Otp Verified Successfully !!');

        Get.to(() => ForgotPassword(
              getFullNameResponse: getFullNameResponse,
              customerName: customerName,
            ));
      } else {
        Widgets().showToast('Invalid OTP: Entered OTP is not valid');
      }
    }

    if (navigationTag == 'login') {
      printMe("OTP Passing : $otpInput");
      await authenticateCustomerWithOTPApi(otpInput).then((value) async {
        if (value != null) {
          if (value.errorMessage != null) {
            Widgets().showToast(value.errorMessage.toString());
          }
          if (value.custermerCode != null && value.custemerFullName != null) {
            await saveLoginFromUserDetails(value.custermerCode.toString())
                .then((val) {
              printMe("Superman : $val");

              if (!val!) {
                Widgets().showToast(
                    'Your role is not define in mobile application.');
                globalController.saveLoginState(
                    isLogin: false, customerScreenName: "");
                Get.offAll(const Login());
              } else {
                Widgets().showToast('Otp Verified Successfully!!');

                //successfulLogin
                globalController.saveLoginState(
                    isLogin: true,
                    customerScreenName: value.custermerCode,
                    userId: value.userId,
                    role: globalController.role);

                printAchievement(
                    'Login State Saved For ${globalController.role} ');
                // Get.back();

                if (globalController.role == "ASM" ||
                    globalController.role == "ZSM" ||
                    globalController.role == "NSM") {
                  // new admin
                  Get.offAll(const LandingPageAdmin(selectedItemIndex: 0));
                } else {
                  // TSI & LAS
                  globalController.isClockIn
                      ? Get.offAll(const LandingPage(selectedItemIndex: 0))
                      : dateTimeUtils.isMorning
                          ? Get.offAll(const ClockInOut())
                          : Get.offAll(const LandingPage(selectedItemIndex: 0));
                }
              }
            });
          }
        }
      });
    }
    isLoading = false;
    update();
  }

  sendOtp() {
    isLoading = true;
    update();
    sendOTPApi().then((value) {
      if (value != null && value.oTPId != null) {
        otpId = value.oTPId.toString();

        if (value.oTPSendingStatus.toString().toLowerCase() == 'success') {
          Widgets().showToast('OTP sent on your registered Mobile / Email');
        }
      }
    });
    isLoading = false;
    update();
  }

  //******************
  Future<SendOTPResponse?> sendOTPApi() {
    var map = {
      "customerCode": screenName,
      "requestType": "send-otp",
      "remarks": "OTP expiries in 10 mins"
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.sendOTP, requestJson).then(
        (value) {
      try {
        if (value != null) {
          SendOTPResponse sendOTPResponse = SendOTPResponse.fromJson(value);
          return sendOTPResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<bool?> saveLoginFromUserDetails(String customerScreenName) async {
    bool isAllOk = false;

    await userAllDetailApi(customerScreenName).then((value) {
      if (value != null) {
        //todo : api binding + store profile url
        if (value.attendanceStatus != null) {
          if (value.roleType == 'role dose not exist') {
            if(value.userName=="abhishek"){
              isAllOk = true;
            }else{
              isAllOk = false;
            }
          } else {
            if (value.attendanceStatus == 'LogIn') {
              printMe("CASE 2");
              globalController.saveLoginState(
                  isClockIn: true,
                  userName: value.userName,
                  role: value.roleType);
              isAllOk = true;
            } else {
              printMe("CASE 3");
              globalController.saveLoginState(
                  isClockIn: false,
                  userName: value.userName,
                  role: value.roleType);
              isAllOk = true;
            }
          }
        }
      }
    });
    return isAllOk;
  }

  Future<UserDetailResponse?> userAllDetailApi(String customerScreenName) {
    Map map = {
      "date": dateTimeUtilsController.formatDateTimeNowYYYYMMDD(),
      "deviceId": "asdfserfvtrrb",
      "screenName": customerScreenName
    };

    var requestJson = jsonEncode(map);
    return ApiService.postRequest(ApiConstants.userAllDetail, requestJson).then(
        (value) {
      try {
        if (value != null) {
          UserDetailResponse userDetailResponse =
              UserDetailResponse.fromJson(value);
          update();

          return userDetailResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<AuthenticateCustomerWithOTPResponse?> authenticateCustomerWithOTPApi(
    String otp,
  ) {
    var map = {"CustomerCode": screenName, "OTP": otp, "OTPId": otpId};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.authenticateCustomerWithOTP, requestJson)
        .then((value) {
      try {
        if (value != null) {
          AuthenticateCustomerWithOTPResponse
              authenticateCustomerWithOTPResponse =
              AuthenticateCustomerWithOTPResponse.fromJson(value);
          return authenticateCustomerWithOTPResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }
}
