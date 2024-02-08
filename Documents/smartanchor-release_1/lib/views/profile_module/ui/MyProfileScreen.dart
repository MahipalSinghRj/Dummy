import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/views/login_module/otp_screen/ui/OtpScreen.dart';
import 'package:smartanchor/views/profile_module/controllers/MyProfileController.dart';
import 'package:smartanchor/views/profile_module/ui/ProfileOTPScreen.dart';

import '../../../common/widgets.dart';
import '../../../configurations/AppConfigs.dart';
import '../../../constants/colorConst.dart';
import '../../home_module/contollers/HomeContoller.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrlr = Get.put(MyProfileController());
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: Container(
              height: 100.h,
              width: MediaQuery.of(context).size.width,
              color: alizarinCrimson,
              child: bodyChild(),
            )));
  }

  bodyChild() {
    return GetBuilder<MyProfileController>(
      builder: (controller) => CustomeLoading(
        isLoading: controller.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: pieChartBG,
                  child: Container(
                    height: 40.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            Widgets().textWidgetWithW500(
                                titleText: "Personal Profile",
                                fontSize: 16.sp,
                                textColor: codGray),
                          ]),
                        ),
                        Divider(
                          thickness: 1.5,
                          height: 5,
                          color: dottedBorderColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                      (controller.profileModal.image.isEmpty ||
                                              controller.profileModal.image ==
                                                  null)
                                          ? "https://media.istockphoto.com/id/1394781347/photo/hand-holdig-plant-growing-on-green-background-with-sunshine.jpg?s=1024x1024&w=is&k=20&c=KJIpH7RN4AousDF7cdcNkMFV4JBLKe7Ild_9tWCXFys="
                                          : "${AppConfigs.baseUrl}${controller.profileModal.image}",
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -0.5,
                                    right: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.updateProfileImage();
                                      },
                                      child: const CircleAvatar(
                                          child:
                                              Icon(Icons.camera_alt, size: 20)),
                                    ),
                                  )
                                ],
                              ),
                              Widgets().verticalSpace(2.h),
                              Widgets().textWidgetWithW500(
                                  titleText: controller.profileModal.dealerName,
                                  fontSize: 12.sp,
                                  textColor: codGray),
                              Widgets().verticalSpace(0.5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Widgets().textWidgetWithW400(
                                      titleText: "Employee Code : ",
                                      fontSize: 10.sp,
                                      textColor: Colors.grey),
                                  Widgets().textWidgetWithW400(
                                      titleText:
                                          controller.profileModal.dealerCode,
                                      fontSize: 10.sp,
                                      textColor: alizarinCrimson),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...textFiledWidget(
                            label: "First Name",
                            hint: controller.profileModal.fname,
                            controller: TextEditingController()),
                        ...textFiledWidget(
                            label: "Last Name",
                            hint: controller.profileModal.lname,
                            controller: TextEditingController()),
                        ...textFiledWidget(
                          label: "Date of Birth",
                          hint: controller.profileModal.dob,
                          controller: TextEditingController(),
                          suffixWidget: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(
                              calender,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        ...textFiledWidget(
                            label: "Reporting To",
                            hint: controller.profileModal.manager,
                            controller: TextEditingController()),
                        ...textFiledWidget(
                            label: "Reporting Manager Role",
                            hint: controller.profileModal.managerRole,
                            controller: TextEditingController()),
                        ...textFiledWidget(
                            label: "Contact No.",
                            hint: controller.profileModal.phone,
                            controller: controller.changePhoneController,
                            suffixWidget: controller.globalController.role ==
                                    "LAS"
                                ? GestureDetector(
                                    onTap: controller.phoneOTPUpdateResult
                                        ? null
                                        : () async {
                                            final result = await Get.to(
                                                () => ProfileOtpScreen(
                                                      isEmailUpdate: false,
                                                      isPhoneUpdate: true,
                                                      currentEmail: controller
                                                          .profileModal.email,
                                                      currentPhone: controller
                                                          .profileModal.phone,
                                                    ));
                                            controller.phoneOTPUpdateResult =
                                                result;
                                            controller.update();
                                          },
                                    child: controller.phoneOTPUpdateResult
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Widgets().textWidgetWithW500(
                                            titleText: 'Get OTP',
                                            fontSize: 12.sp,
                                            textColor: lochmara))
                                : null,
                            isEnabled:
                                controller.globalController.role == "LAS" &&
                                    !controller.phoneOTPUpdateResult),
                        ...textFiledWidget(
                            label: "Email ID",
                            hint: controller.profileModal.email,
                            controller: controller.changeEmailController,
                            isEnabled:
                                controller.globalController.role == "LAS" &&
                                    !controller.emailOTPUpdateResult,
                            suffixWidget: controller.globalController.role ==
                                    "LAS"
                                ? GestureDetector(
                                    onTap: controller.emailOTPUpdateResult
                                        ? null
                                        : () async {
                                            final result = await Get.to(
                                                () => ProfileOtpScreen(
                                                      isEmailUpdate: true,
                                                      isPhoneUpdate: false,
                                                      currentEmail: controller
                                                          .profileModal.email,
                                                      currentPhone: controller
                                                          .profileModal.phone,
                                                    ));
                                            controller.emailOTPUpdateResult =
                                                result;
                                            controller.update();
                                          },
                                    child: controller.emailOTPUpdateResult
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Widgets().textWidgetWithW500(
                                            titleText: 'Get OTP',
                                            fontSize: 12.sp,
                                            textColor: lochmara))
                                : null),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Widgets().textWidgetWithW500(
                                titleText: "Change Password",
                                fontSize: 14.sp,
                                textColor: Colors.black),
                          ],
                        ),
                        Widgets().verticalSpace(1.h),
                        Form(
                            key: controller.passwordChangeFormKey,
                            child: Column(
                              children: [
                                ...textFiledWidget(
                                    hint: "Current Password",
                                    isEnabled: true,
                                    onValidate: (val) {
                                      return controller
                                          .validatePassword(val ?? '');
                                    },
                                    controller:
                                        controller.currentPasswordController),
                                ...textFiledWidget(
                                    hint: "New Password",
                                    isEnabled: true,
                                    onValidate: (val) {
                                      return controller
                                          .validatePassword(val ?? '');
                                    },
                                    controller:
                                        controller.newPasswordController),
                                ...textFiledWidget(
                                  hint: "Confirm Password",
                                  isEnabled: true,
                                  onValidate: (val) {
                                    return controller
                                        .validateConfirmPassword(val ?? '');
                                  },
                                  controller:
                                      controller.confirmPasswordController,
                                ),
                              ],
                            )),
                        Widgets().verticalSpace(2.h),
                        Row(
                          children: [
                            Widgets().dynamicButton(
                                onTap: () {
                                  controller.updatePassword();
                                },
                                height: 6.h,
                                width: 50.w,
                                buttonBGColor: alizarinCrimson,
                                titleText: 'Update Password',
                                titleColor: white),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFiledWidget(
      {String? label,
      String? hint,
      String? Function(String?)? onValidate,
      TextEditingController? controller,
      Widget? suffixWidget,
      bool isEnabled = false}) {
    return [
      if (label != null)
        Row(
          children: [
            Widgets().textWidgetWithW500(
                titleText: label, fontSize: 11.sp, textColor: codGray),
          ],
        ),
      Widgets().verticalSpace(1.h),
      Widgets().textFieldWidgetWithOutlineBorder(
          controller: controller,
          onValidate: onValidate,
          fillColor: white,
          hintText: hint,
          suffixWidget: suffixWidget,
          isEnable: isEnabled),
      Widgets().verticalSpace(1.h),
    ];
  }
}
