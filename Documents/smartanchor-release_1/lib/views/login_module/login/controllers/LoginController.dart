import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/login_module/otp_screen/ui/OtpScreen.dart';

import '../../../../common/widgets.dart';
import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../../login_module/login/models/response/GetAuthenticatePasswordResponse.dart';
import '../models/response/GetFullNameResponse.dart';
import '../models/response/PasswordResetFirstTimeResponse.dart';
import '../models/response/PasswordResetForgotResponse.dart';

class LoginController extends GetxController {
  bool obSecureText = false;
  bool readOnlyPassword = true;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());
  GetFullNameResponse? getFullNameResponse;
  PasswordResetForgotResponse? passwordResetForgotResponse;
  GetAuthenticatePasswordResponse? getAuthenticatePasswordResponse;
  String? customerEmailAddress;
  bool isButtonClickable = true;
  bool isLoading = false;

  bool isForReadOnly() {
    if (userNameController.text.isNotEmpty && readOnlyPassword) {
      return true;
    }
    return false;
  }

  Future<void> onNameChanged() async {
    isLoading = true;
    update();
    getFullNameResponse = null;
    await getCustomerNameApi(userNameController.text.toString()).then((value) {
      if (value != null) {
        if (value.errorMessage != null) {
          readOnlyPassword = true;
          passwordController.text = '';

          Widgets().showToast(value.errorMessage.toString());
        } else {
          readOnlyPassword = false;
          getFullNameResponse = value;
          customerEmailAddress = value.emailAddress;
          globalController.setCustomerEmailAddress(
              customerEmailAddress: customerEmailAddress!);
        }
        update();
      } else {
        Widgets().showToast('please try again later !!');
      }
    });

    isLoading = false;
    update();
  }

  bool loginValidation() {
    if (userNameController.text.isEmpty) {
      Widgets().showToast("Employee Code / Username can not be empty !!");
      Get.back();

      return false;
    }
    if (passwordController.text.isEmpty) {
      Widgets().showToast("Password can not be empty !!");
      Get.back();

      return false;
    }

    return true;
  }

  Future<void> verifyPassword() async {
    isLoading = true;
    update();
    if (loginValidation()) {
      await getAuthenticationCustomerWithPasswordApi(
              userNameController.text, passwordController.text)
          .then((value) {
        if (value != null) {
          if (value.errorMessage != null) {
            Widgets().showToast(value.errorMessage.toString());
          }
          if (value.custemerFullName != null && value.custermerCode != null) {
            getAuthenticatePasswordResponse = null;
            getAuthenticatePasswordResponse = value;

            Get.to(() => OtpScreen(
                  navigationTag: "login",
                  screenName: userNameController.text,
                  getFullNameResponse: getFullNameResponse,
                  getAuthenticatePasswordResponse:
                      getAuthenticatePasswordResponse,
                  passwordResetForgotResponse: null,
                  isSendOTP: true,
                ));

            // call api for otp here
          }
        } else {
          Widgets().showToast('please try again later !!');
        }
      });
    }
    isLoading = false;
    update();
  }

  onForgotPasswordOtp() async {
    isLoading = true;
    update();
    passwordResetForgotResponse = null;
    await passwordResetForgotPasswordApi(userNameController.text).then((value) {
      if (value != null) {
        if (value.errorMessage != null) {
          Widgets().showToast(value.errorMessage.toString());
        }
        if (value.otpValue != null) {
          passwordResetForgotResponse = value;
        } else {
          Widgets().showToast('please try again later !!');
        }
      } else {
        Widgets().showToast('please try again later !!');
      }
    });

    isLoading = false;
    update();
  }

//api calls here
  Future<GetFullNameResponse?> getCustomerNameApi(String customerScreenName) {
    var map = {"customerScreenName": customerScreenName};
//AP0POW001
    var requestJson = jsonEncode(map);

    printMe("Request : $requestJson");

    return ApiService.postRequest(ApiConstants.getCustomerName, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetFullNameResponse getCustomerNameResponse =
              GetFullNameResponse.fromJson(value);
          return getCustomerNameResponse;
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

//**********
  Future<GetAuthenticatePasswordResponse?>
      getAuthenticationCustomerWithPasswordApi(
          String customerScreenName, String password) {
    var map = {"customerScreenName": customerScreenName, "password": password};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.getAuthenticationCustomerWithPassword, requestJson)
        .then((value) {
      try {
        if (value != null) {
          GetAuthenticatePasswordResponse getAuthenticatePasswordResponse =
              GetAuthenticatePasswordResponse.fromJson(value);
          return getAuthenticatePasswordResponse;
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

//***********************
  Future<PasswordResetFirstTimeResponse?> passwordResetFirstTimeApi(
    String customerScreenName,
    String password,
  ) {
    var map = {"customerScreenName": customerScreenName, "password": password};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.passwordResetFirstTime, requestJson)
        .then((value) {
      try {
        if (value != null) {
          PasswordResetFirstTimeResponse passwordResetFirstTimeResponse =
              PasswordResetFirstTimeResponse.fromJson(value);
          return passwordResetFirstTimeResponse;
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

//***********************
  Future<PasswordResetForgotResponse?> passwordResetForgotPasswordApi(
    String customerScreenName,
  ) {
    var map = {"customerScreenName": customerScreenName};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(
            ApiConstants.passwordResetForgotPassword, requestJson)
        .then((value) {
      try {
        if (value != null) {
          PasswordResetForgotResponse passwordResetResponse =
              PasswordResetForgotResponse.fromJson(value);
          return passwordResetResponse;
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

  togglePasswordVisibility() {
    obSecureText = !obSecureText;
    update();
  }

  void handleButtonClick() {
    if (isButtonClickable) {
      // Perform your button click action here
      print('Button Clicked!');

      // Disable the button for 1 second
      isButtonClickable = false;

      Future.delayed(Duration(seconds: 1), () {
        // Enable the button after 1 second
        isButtonClickable = true;
      });
    }
    update();
  }

  void changeButtonClickState(bool value) {
    isButtonClickable = value;
    update();
  }
}
