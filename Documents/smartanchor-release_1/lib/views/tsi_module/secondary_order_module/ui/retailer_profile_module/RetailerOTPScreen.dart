import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_profile_controller/RetailerController.dart';
import '../../../../../common/CustomLoadingWrapper.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../constants/labelConst.dart';
import '../../../../login_module/otp_screen/PinPutWidget/PinPut.dart';

class RetailerVerifyOTPScreen extends StatefulWidget {
  const RetailerVerifyOTPScreen({Key? key, required this.retailerCode}) : super(key: key);
  final String retailerCode;
  @override
  State<RetailerVerifyOTPScreen> createState() => _RetailerVerifyOTPScreenState();
}

class _RetailerVerifyOTPScreenState extends State<RetailerVerifyOTPScreen> {
  RetailerController controller = Get.put(RetailerController());
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<RetailerController>(
        init: controller,
        builder: (controller) => Scaffold(
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
                              Widgets().titleText(titleText: otpSentMessage, isStar: false, fontSize: 12.sp),

                              //Otp field
                              Widgets().verticalSpace(2.h),
                              PinPutExample(
                                otpLength: 4,
                                validator: (validatorValue) {
                                  return null;
                                },
                                onCompleted: (onCompletedValue) {
                                  controller.otpController.text = onCompletedValue;
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
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     controller.otpController.timerText !=
                                    //             "0:00"
                                    //         ? Widgets().textWidgetWithW500(
                                    //             titleText: controller
                                    //                 .otpController.timerText,
                                    //             fontSize: 12.sp,
                                    //             textColor: alizarinCrimson)
                                    //         : Container(),
                                    //     controller.otpController.timerText ==
                                    //             "0:00"
                                    //         ? InkWell(
                                    //             onTap: () {
                                    //               controller.otpController
                                    //                   .startTimer();
                                    //               controller.otpController
                                    //                   .sendOtp();
                                    //             },
                                    //             child: Widgets()
                                    //                 .textWidgetWithW500(
                                    //                     titleText: "Resend OTP",
                                    //                     fontSize: 12.sp,
                                    //                     textColor: curiousBlue))
                                    //         : Container()
                                    //     //todo : add api call here
                                    //   ],
                                    // ),

                                    Widgets().verticalSpace(2.h),
                                    Row(
                                      children: [
                                        Widgets().dynamicButton(
                                            onTap: () async {
                                              if (controller.otpController.text.isEmpty) {
                                                Widgets().showToast("Please fill otp");
                                                return;
                                              }
                                              isLoading = true;
                                              setState(() {});
                                              final result = await controller.verifyUserValidateOTP(widget.retailerCode);
                                              isLoading = false;
                                              controller.update();
                                              if (result != null) {
                                                setState(() {});
                                                Get.back(result: result);
                                              }
                                            },
                                            height: 6.5.h,
                                            width: 35.w,
                                            buttonBGColor: alizarinCrimson,
                                            titleText: "Okay",
                                            titleColor: white),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Widgets().verticalSpace(4.h),
                              InkWell(
                                  onTap: () {
                                    Get.back(result: false);
                                  },
                                  child: Widgets().textWithArrowIcon(icon: Icons.arrow_back, textTitle: "Back to Retailer/SubStockist")),
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
      ),
    );
  }
}
