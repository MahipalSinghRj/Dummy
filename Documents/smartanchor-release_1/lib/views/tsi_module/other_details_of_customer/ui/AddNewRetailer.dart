import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/login_module/login/controllers/LoginController.dart';
import 'package:smartanchor/views/login_module/otp_screen/ui/OtpScreen.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class AddNewRetailer extends StatefulWidget {
  const AddNewRetailer({Key? key}) : super(key: key);

  @override
  State<AddNewRetailer> createState() => _AddNewRetailerState();
}

class _AddNewRetailerState extends State<AddNewRetailer> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedValue;
  String? selectedBu;

  //TODO add all respective controllers
  //TODO add all respective dropdown values

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Widgets().verticalSpace(2.h),
                            Widgets().titleText(titleText: 'Shop Name', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Proprietor Name', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Mobile No.', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'GST No.', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Aadhar No.', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Pan Card No.', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Shop No., Building, Comapany, Apartment', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Area, Colony, Street, Sector, Village', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Landmark', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'State', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().commonDropdown(
                                hintText: "Enter Here",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedBu),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'District', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().commonDropdown(
                                hintText: "Enter Here",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedBu),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'City', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().commonDropdown(
                                hintText: "Enter Here",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedBu),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Beat', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().commonDropdown(
                                hintText: "Enter Here",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedBu),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'PIN Code', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets().textFieldWithoutIcon(passwordController, 'Enter Here', TextInputType.text),
                            Widgets().verticalSpace(1.h),
                            Widgets().titleText(titleText: 'Geo Coordinates', isStar: true, fontSize: 10.sp),
                            Widgets().verticalSpace(1.h),
                            Widgets()
                                .textFieldWithGeoCoordinatesContainer(controller: passwordController, hintText: 'Enter (Latitude, Longitude)', onTapGeoCoordinate: () {}),
                            Widgets().verticalSpace(3.h),
                            Container(
                              decoration: Widgets().commonDecoration(bgColor: magicMint, borderRadius: 1.5.h),
                              child: Widgets().customLRPadding(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textWidgetWithW700(titleText: 'Dealer Dealer', fontSize: 11.sp),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().horizontalDivider(),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW700(titleText: 'Power Dealer', fontSize: 11.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Enter Here",
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBu = value;
                                        });
                                      },
                                      itemValue: itemValue,
                                      selectedValue: selectedBu),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW700(titleText: 'IAO Dealer', fontSize: 11.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Enter Here",
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBu = value;
                                        });
                                      },
                                      itemValue: itemValue,
                                      selectedValue: selectedBu),
                                  Widgets().verticalSpace(2.h),
                                  Widgets().textWidgetWithW700(titleText: 'Lighting Dealer', fontSize: 11.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Enter Here",
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBu = value;
                                        });
                                      },
                                      itemValue: itemValue,
                                      selectedValue: selectedBu),
                                  Widgets().verticalSpace(2.h),
                                ]),
                              ),
                            ),
                            Widgets().verticalSpace(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 44.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white),
                                Widgets().dynamicButton(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                                        return OtpScreen(
                                          navigationTag: 'forgotPassword',
                                          screenName: loginController.userNameController.text,
                                          getFullNameResponse: loginController.getFullNameResponse,
                                          passwordResetForgotResponse: loginController.passwordResetForgotResponse,
                                          isSendOTP: false,
                                        );
                                      }));
                                    },
                                    height: 6.h,
                                    width: 44.w,
                                    buttonBGColor: alizarinCrimson,
                                    titleText: 'Submit',
                                    titleColor: white)
                              ],
                            ),
                            Widgets().verticalSpace(2.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
