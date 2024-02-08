import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/views/login_module/otp_screen/controllers/OtpController.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../login/models/response/GetAuthenticatePasswordResponse.dart';
import '../../login/models/response/GetFullNameResponse.dart';
import '../../login/models/response/PasswordResetForgotResponse.dart';
import '../../login/ui/login.dart';
import '../PinPutWidget/PinPut.dart';

class OtpScreen extends StatefulWidget {
  final String navigationTag;
  final String screenName;
  final GetFullNameResponse? getFullNameResponse;
  final PasswordResetForgotResponse? passwordResetForgotResponse;
  final GetAuthenticatePasswordResponse? getAuthenticatePasswordResponse;
  final bool isSendOTP;
  final String? OTPId;

  //login
  //forgotPassword
  const OtpScreen({
    Key? key,
    required this.navigationTag,
    required this.screenName,
    required this.getFullNameResponse,
    required this.passwordResetForgotResponse,
    this.getAuthenticatePasswordResponse,
    required this.isSendOTP,
    this.OTPId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpFieldController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  OtpController otpController = Get.put(OtpController());

  @override
  void initState() {
    otpController.startTimer();
    otpController.screenName = widget.screenName;

    if (widget.navigationTag == "login" && widget.isSendOTP) {
      otpController.sendOtp();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: CustomeLoading(
            isLoading: controller.isLoading,
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(splashScreenBG),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                        otpVerification,
                        Widgets().buildBottomContainer(Container(
                          padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Otp sent message
                              Widgets().verticalSpace(4.h),
                              Widgets().titleText(
                                  titleText: otpSentMessage,
                                  isStar: false,
                                  fontSize: 12.sp),

                              //Otp field
                              Widgets().verticalSpace(2.h),
                              PinPutExample(
                                validator: (validatorValue) {
                                  return null;
                                },
                                onCompleted: (onCompletedValue) {
                                  otpController.otpInput = onCompletedValue;
                                  return null;
                                },
                                onChanged: (onChangedValue) {
                                  return null;
                                },
                              ),

                              //Timer
                              Widgets().verticalSpace(2.h),
                              //Submit in Button
                              Padding(
                                padding: EdgeInsets.only(left: 3.w, right: 3.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        controller.timerText != "0:00"
                                            ? Widgets().textWidgetWithW500(
                                                titleText: controller.timerText,
                                                fontSize: 12.sp,
                                                textColor: alizarinCrimson)
                                            : Container(),
                                        controller.timerText == "0:00"
                                            ? InkWell(
                                                onTap: () {
                                                  controller.startTimer();
                                                  otpController.sendOtp();
                                                },
                                                child: Widgets()
                                                    .textWidgetWithW500(
                                                        titleText: "Resend OTP",
                                                        fontSize: 12.sp,
                                                        textColor: curiousBlue))
                                            : Container()
                                        //todo : add api call here
                                      ],
                                    ),
                                    Widgets().verticalSpace(2.h),
                                    Row(
                                      children: [
                                        Widgets().dynamicButton(
                                            onTap: () {
                                              if (widget.OTPId != null) {
                                                otpController.otpId =
                                                    widget.OTPId!;
                                              }

                                              print("OTPId : ${widget.OTPId}");

                                              otpController.onOtpSubmit(
                                                  widget.navigationTag,
                                                  widget.getFullNameResponse
                                                          ?.customerScreenName ??
                                                      '',
                                                  getFullNameResponse: widget
                                                      .getFullNameResponse,
                                                  passwordResetForgotResponse:
                                                      widget
                                                          .passwordResetForgotResponse);
                                            },
                                            height: 6.5.h,
                                            width: 35.w,
                                            buttonBGColor: alizarinCrimson,
                                            titleText: submit,
                                            titleColor: white),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Widgets().verticalSpace(4.h),
                              InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const Login();
                                    }), (route) => false);
                                  },
                                  child: Widgets().textWithArrowIcon(
                                      icon: Icons.arrow_back,
                                      textTitle: backToChangeEmployee)),
                            ],
                          ),
                        )),
                      ),

                      // Positioned(
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 53.h,
                      //   child: Image.asset(
                      //     otpLock,
                      //   ),
                      // ),
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
