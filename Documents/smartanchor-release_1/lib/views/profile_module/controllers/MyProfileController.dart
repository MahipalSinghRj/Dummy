import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/utils/FileUtils.dart';
import 'package:dio/dio.dart' as dioAPI;
import '../../../configurations/ApiConstants.dart';
import '../../../configurations/AppConfigs.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../../login_module/otp_screen/controllers/OtpController.dart';
import '../models/ProfileDetailsModal.dart';

class MyProfileController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  FileUtils filesService = Get.put(FileUtils());
  OtpController otpController = Get.put(OtpController());
  bool isLoading = false;
  bool emailOTPUpdateResult = false;
  bool phoneOTPUpdateResult = false;
  ProfileDetailsModal profileModal = ProfileDetailsModal();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpFieldController = TextEditingController();
  TextEditingController changeEmailController = TextEditingController();
  TextEditingController changePhoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> passwordChangeFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchProfileDetails();
  }

  @override
  void onClose() async {
    // TODO: implement onInit
    super.onClose();
    // newPasswordController.dispose();
    // currentPasswordController.dispose();
    // confirmPasswordController.dispose();
  }

  fetchProfileDetails() async {
    isLoading = true;
    update();
    final value = await fetchProfileDetailsAPI();
    if (value != null) {
      profileModal = value;
      globalController.setUserProfilePic("${AppConfigs.baseUrl}${profileModal.image}");
    }
    isLoading = false;
    update();
    return value;
  }

  Future<ProfileDetailsModal?> fetchProfileDetailsAPI() {
    return ApiService.getRequest(
      ApiConstants.getProfileDetails(globalController.userId.toString()),
    ).then((value) {
      try {
        if (value != null) {
          ProfileDetailsModal profileDetails =
              ProfileDetailsModal.fromJson(value);
          return profileDetails;
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

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  updatePassword() async {
    isLoading = true;
    update();
    if (passwordChangeFormKey.currentState!.validate()) {
      var map = {
        "currentPassword": currentPasswordController.text,
        "newPassword": newPasswordController.text,
        "userId": globalController.userId
      };
      final result = await updatePasswordAPI(map);
      if (result) {
        newPasswordController.clear();
        currentPasswordController.clear();
        confirmPasswordController.clear();
        Widgets().showToast("Password Update Successfully");
      } else {
        Widgets().showToast("Wrong or Invalid Password");
      }
    }

    isLoading = false;
    update();
  }

  Future<bool> updatePasswordAPI(Map<String, dynamic> map) async {
    final data = jsonEncode(map);
    return ApiService.postRequest(ApiConstants.updatePassword, data).then(
        (value) {
      try {
        if (value != null) {
          return value['success'] ?? false;
        } else {
          return false;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return false;
      }
    }, onError: (e) {
      return null;
    });
  }

  updateProfileImage() async {
    final file = await filesService.takeSelfieWithCamera();
    if (file == null || file.path.isEmpty) {
      Widgets().showToast("Image Not Captured");
      return;
    } else if (file.path.isNotEmpty) {
      isLoading = true;
      update();
      final result = await updateProfileImageAPI(file);
      if (result) {
        Widgets().showToast("Profile Image Update Successfully");
        await fetchProfileDetails();
      } else {
        Widgets().showToast("Profile Image Not Updated");
      }
    } else {
      Widgets().showToast("Some Error Occured");
      return;
    }

    isLoading = false;
    update();
  }

  Future<bool> updateProfileImageAPI(File file) async {
    return await ApiService.postRequestWithMultipart(
            ApiConstants.updateUserData(globalController.userId.toString()), "file", file)
        .then((value) {
      try {
        if (value != null) {
          return value['success'] ?? false;
        } else {
          return false;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return false;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<bool> sendOtp(
      {required bool otpForPhone,
      required bool otpForEmail,
      required String currentEmail,
      required String currentPhone}) async {
    isLoading = true;
    update();

    var map = {
      "email": otpForEmail ? changeEmailController.text : currentEmail,
      "phone": otpForPhone ? changePhoneController.text : currentPhone,
      "userId": globalController.userId
    };
    final result = await sendOtpAPI(map);
    if (result) {
      if (otpForPhone) {
        Widgets().showToast("Otp sent on your number.");
      } else if (otpForEmail) {
        Widgets().showToast("Otp sent on your email.");
      }
      isLoading = false;
      update();
      return true;
    } else {
      Widgets().showToast("Otp not sent.");
      Get.back(result: false);
      isLoading = false;
      update();
      return false;
    }
  }

  Future<bool> sendOtpAPI(Map<String, dynamic> map) async {
    final data = jsonEncode(map);
    return ApiService.postRequest(ApiConstants.sendProfileOtp, data).then(
        (value) {
      try {
        if (value != null) {
          return value['success'] ?? false;
        } else {
          return false;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return false;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<bool> otpVerify(
      {required bool otpForPhone,
      required bool otpForEmail,
      required String currentEmail,
      required String currentPhone}) async {
    isLoading = true;
    update();

    var map = {
      "otp": otpController.otpInput,
      "email": otpForEmail ? changeEmailController.text : currentEmail,
      "phone": otpForPhone ? changePhoneController.text : currentPhone,
      "userId": globalController.userId
    };

    final result = await otpVerifyAPI(map);
    otpController.otpInput = '';
    if (result) {
      if (otpForPhone) {
        Widgets().showToast("Phone number updated successfully.");
      } else if (otpForEmail) {
        Widgets().showToast("Email updated successfully.");
      }
      await fetchProfileDetails();
      isLoading = false;
      update();
      return true;
    } else {
      if (otpForPhone) {
        Widgets().showToast("Phone number  not updated.");
      } else if (otpForEmail) {
        Widgets().showToast("Email not updated.");
      }
      isLoading = false;
      update();
      return false;
    }
  }

  Future<bool> otpVerifyAPI(Map<String, dynamic> map) async {
    final data = jsonEncode(map);
    return ApiService.postRequest(ApiConstants.updateMobileEmail, data).then(
        (value) {
      try {
        if (value != null) {
          return value['success'] ?? false;
        } else {
          return false;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return false;
      }
    }, onError: (e) {
      return null;
    });
  }
}
