import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/views/login_module/login/ui/login.dart';

import '../../../../configurations/ApiConstants.dart';
import '../../../../debug/printme.dart';
import '../../../../services/ApiService.dart';
import '../../login/models/response/PasswordResetResponse.dart';

class ForgotPasswordController extends GetxController {
  bool enterObscureText = true;
  bool confirmObscureText = true;

  final TextEditingController enterPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void enterPasswordVisibility() {
    enterObscureText = !enterObscureText;
    update();
  }

  void confirmPasswordVisibility() {
    confirmObscureText = !confirmObscureText;
    update();
  }

  bool checkValidation() {
    if (!validateNewPassword(enterPasswordController.text)) {
      return false;
    }
    if (enterPasswordController.text != confirmPasswordController.text) {
      Widgets().showToast("Passwords do not match, please Try Again!!");
      return false;
    }
    return true;
  }

  bool validateNewPassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!_@#$%^&*(),.?":{}|<>]'));
    bool hasNumberChar = password.contains(RegExp(r'(?=.*[0-9])'));

    if (!hasUppercase) {
      Widgets().showToast("Password must contain at least one uppercase letter");
      return false;
    }
    if (!hasLowercase) {
      Widgets().showToast("Password must contain at least one lowercase  letter");
      return false;
    }
    if (!hasSpecialChar) {
      Widgets().showToast("Password must contain at least one special character");
      return false;
    }
    if (!hasNumberChar) {
      Widgets().showToast("Password must contain at least one numeric digit");
      return false;
    }
    if (password.length < 11) {
      Widgets().showToast("Password must contain at least 11 characters");

      return false;
    }
    return true;
  }

  submitNewPasswords(String? customerScreenName) {
    if (checkValidation() && customerScreenName != null) {
      passwordReset(customerScreenName, enterPasswordController.text, confirmPasswordController.text).then((value) {
        if (value != null) {
          if (value.resultMessage != null && value.resultCode != null && value.resultCode == '200') {
            Widgets().showToast(value.resultMessage.toString());
            Get.offAll(() => const Login());
          } else if (value.errorMessage != null) {
            Widgets().showToast(value.errorMessage.toString());
          }
        } else {
          Widgets().showToast("Something went wrong, please Try Again!!");
        }
      });
    }
  }

  //***********************
  Future<PasswordResetResponse?> passwordReset(
    String customerScreenName,
    String password,
    String confirmPassword,
  ) {
    var map = {"customerScreenName": customerScreenName, "password": password, "confirm": confirmPassword};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.passwordReset, requestJson).then((value) {
      try {
        if (value != null) {
          PasswordResetResponse passwordResetResponse = PasswordResetResponse.fromJson(value);
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
}
