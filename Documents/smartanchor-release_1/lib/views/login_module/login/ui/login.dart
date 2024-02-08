import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../otp_screen/ui/OtpScreen.dart';
import '../controllers/LoginController.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: CustomeLoading(
            isLoading: controller.isLoading,
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(splashScreenBG),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 11.h,
                      ),
                      Image.asset(
                        bestSplashLogo,
                        height: 25.h,
                      ),
                      Container(
                        height: 5.h,
                      ),
                      Widgets().loginCard(
                        employeeSignIn,
                        Widgets().buildBottomContainer(Container(
                          padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 0),
                          margin: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Employee code or user name field
                              Widgets().verticalSpace(4.w),
                              Widgets().titleText(
                                  titleText: employeeCodeUsername,
                                  isStar: true,
                                  fontSize: 12.sp),

                              Widgets().verticalSpace(1.w),
                              Widgets().textFieldUserName(
                                  controller:
                                      loginController.userNameController,
                                  hintText: '',
                                  obscure: false,
                                  readOnly: false,
                                  onFieldSubmitted: (value) {
                                    // Widgets().loadingDataDialog(
                                    //     loadingText:
                                    //         'Loading Data, Please wait..');
                                    loginController
                                        .onNameChanged()
                                        .then((value) {
                                      // Get.back();
                                    });
                                  },
                                  onTap: () {},
                                  iconDataWidget: Icon(Icons.person_outline,
                                      color: alizarinCrimson)),

                              //Password field
                              Widgets().verticalSpace(2.w),
                              Widgets().titleText(
                                  titleText: password,
                                  isStar: true,
                                  fontSize: 12.sp),

                              Widgets().verticalSpace(1.h),
                              Widgets().textFieldPassword(
                                controller: loginController.passwordController,
                                hintText: '',
                                obscure: !controller.obSecureText,
                                readOnly: controller.readOnlyPassword,
                                onChanged: (value) {},
                                onTap: () {
                                  controller.togglePasswordVisibility();
                                },
                                onTapTextField: () {
                                  if (loginController.isForReadOnly()) {
                                    // Widgets().loadingDataDialog(
                                    //     loadingText:
                                    //         'Loading Data, Please wait..');
                                    loginController
                                        .onNameChanged()
                                        .then((value) {
                                      // Get.back();
                                    });
                                  }
                                },
                                iconDataWidget: !controller.obSecureText
                                    ? Icon(
                                        Icons.visibility_off_outlined,
                                        color: alizarinCrimson,
                                      )
                                    : Icon(Icons.visibility,
                                        color: alizarinCrimson),
                              ),
                              //Forgot password
                              Widgets().verticalSpace(2.h),
                              InkWell(
                                onTap: loginController.readOnlyPassword
                                    ? () {}
                                    : () async {
                                        if (controller.isButtonClickable) {
                                          controller
                                              .changeButtonClickState(false);

                                          await loginController
                                              .onForgotPasswordOtp();
                                          Get.to(() => OtpScreen(
                                                navigationTag: 'forgotPassword',
                                                screenName: loginController
                                                    .userNameController.text,
                                                getFullNameResponse:
                                                    loginController
                                                        .getFullNameResponse,
                                                passwordResetForgotResponse:
                                                    loginController
                                                        .passwordResetForgotResponse,
                                                isSendOTP: true,
                                              ));
                                        }

                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          // Enable the button after 1 second
                                          controller
                                              .changeButtonClickState(true);
                                        });
                                      },
                                child: Text(
                                  forgotPassword,
                                  style: TextStyle(
                                      color: loginController.readOnlyPassword
                                          ? curiousBlue.withOpacity(.5)
                                          : curiousBlue,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),

                              //Sign in Button
                              Widgets().verticalSpace(2.h),
                              Widgets().dynamicButton(
                                  onTap: () async {
                                    // Widgets().loadingDataDialog(
                                    //     loadingText:
                                    //         'Loading Data, Please wait..');
                                    controller.verifyPassword().then((value) {
                                      // Get.back();
                                    });

                                    //  Get.to(()=>OtpScreen(getFullNameResponse: loginController.getFullNameResponse,));
                                  },
                                  height: 6.h,
                                  width: 35.w,
                                  buttonBGColor: alizarinCrimson,
                                  titleText: signIn,
                                  titleColor: white),

                              Widgets().verticalSpace(2.h),
                              InkWell(
                                onTap: () async {
                                  if (loginController.isForReadOnly()) {
                                    await loginController.onNameChanged().then((value) {
                                    });
                                  }
                                  if (loginController.getFullNameResponse == null) {
                                    Widgets()
                                        .showToast("Please Enter valid Employee Code/ Username");
                                    return;
                                  }
                                  Get.to(() => OtpScreen(
                                        navigationTag: "login",
                                        screenName: loginController
                                            .getFullNameResponse!.customerScreenName!,
                                        getFullNameResponse:
                                            loginController.getFullNameResponse,
                                        getAuthenticatePasswordResponse: null,
                                        passwordResetForgotResponse: null,
                                        isSendOTP: false,
                                        OTPId: loginController
                                            .getFullNameResponse!.oTPId!,
                                      ));

                                  print(
                                      "Login detail : ${loginController.getFullNameResponse!.customerScreenName}");
                                },
                                child: Widgets().titleText(
                                    titleText: "Already have OTP? Click here.",
                                    isStar: false,
                                    fontSize: 12.sp),
                              )
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
