import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/login_module/forgot_password/controllers/ForgotPasswordContrller.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../login/models/response/GetFullNameResponse.dart';

//ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  final GetFullNameResponse? getFullNameResponse;
  String? customerName;

  ForgotPassword({Key? key, required this.getFullNameResponse, required this.customerName}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(commonBG),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  //Container(height: 10.h),
                  // Image.asset(
                  //   bestSplashLogo,
                  //   height: 25.h,
                  // ),
                  Widgets().buildTopContainer(forgotPassword),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0.h,
                    child: Widgets().buildBottomContainer(Container(
                      padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 0),
                      margin: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Enter Password field
                          Widgets().verticalSpace(3.h),
                          Widgets().titleText(titleText: enterPassword, isStar: true, fontSize: 12.sp),
                          Widgets().verticalSpace(1.1.h),
                          Widgets().forgotPasswordTextFieldWidget(
                              controller: controller.enterPasswordController,
                              hintText: 'Enter Password',
                              obscure: controller.enterObscureText,
                              onSubmit: (value) {
                                controller.validateNewPassword(value);
                              },
                              onTap: () {
                                controller.enterPasswordVisibility();
                              },
                              iconDataWidget: controller.enterObscureText
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: alizarinCrimson,
                                    )
                                  : Icon(Icons.visibility, color: alizarinCrimson)),

                          //Confirm Password field
                          Widgets().verticalSpace(2.5.h),
                          Widgets().titleText(titleText: confirmPassword, isStar: true, fontSize: 12.sp),
                          Widgets().verticalSpace(1.h),
                          Widgets().forgotPasswordTextFieldWidget(
                              controller: controller.confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscure: controller.confirmObscureText,
                              onSubmit: (value) {},
                              onTap: () {
                                controller.confirmPasswordVisibility();
                              },
                              iconDataWidget: controller.confirmObscureText
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: alizarinCrimson,
                                    )
                                  : Icon(Icons.visibility, color: alizarinCrimson)),

                          //Submit Button
                          Widgets().verticalSpace(2.5.h),
                          Widgets().dynamicButton(
                              onTap: () {
                                if (controller.enterPasswordController.text.isEmpty) {
                                  Widgets().showToast("Please enter password.");
                                }
                                forgotPasswordController.submitNewPasswords(widget.customerName.toString());
                              },
                              height: 6.5.h,
                              width: 35.w,
                              buttonBGColor: alizarinCrimson,
                              titleText: submit,
                              titleColor: white),
                        ],
                      ),
                    )),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 65.h,
                    child: Image.asset(
                      bestSplashLogo,
                      height: 25.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
