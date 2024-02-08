import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/colorConst.dart';

class PinPutExample extends StatefulWidget {
  final String? Function(String?) validator;
  final String? Function(String) onCompleted;
  final String? Function(String) onChanged;

  final int otpLength;

  const PinPutExample({Key? key, this.otpLength = 5, required this.validator, required this.onCompleted, required this.onChanged}) : super(key: key);

  @override
  State<PinPutExample> createState() => _PinPutExampleState();
}

class _PinPutExampleState extends State<PinPutExample> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 13.5.w,
      height: 7.h,
      textStyle: TextStyle(
        fontSize: 18.sp,
        color: const Color.fromRGBO(87, 30, 76, 1.0),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.5.h), border: Border.all(color: Colors.white), color: Colors.white),
    );
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              autofocus: true,
              controller: pinController,
              length: widget.otpLength,
              focusNode: focusNode,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => SizedBox(width: 4.5.w),
              validator: widget.validator,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: widget.onCompleted,
              onChanged: widget.onChanged,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 5.w,
                    height: 2,
                    color: boulder,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(1.5.h),
                  border: Border.all(color: Colors.white),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.5.h),
                  border: Border.all(color: Colors.white),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
