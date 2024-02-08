import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';

class AddNewMeet extends StatefulWidget {
  const AddNewMeet({Key? key}) : super(key: key);

  @override
  State<AddNewMeet> createState() => _AddNewMeetState();
}

class _AddNewMeetState extends State<AddNewMeet> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          backgroundColor: pippin,
          body: SingleChildScrollView(
            child: Widgets().customLRPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().verticalSpace(2.h),
                  Widgets().meetDetailsTileWithSingleColor(
                      bgColor: white,
                      circleColor: malachite,
                      iconNameFirst: clockInIcon,
                      iconNameSecond: calender,
                      iconNameThird: clock,
                      titleTextFirst: 'IN',
                      titleTextSecond: 'May 21, 2023',
                      titleTextThird: '11:49:08',
                      circleBorderColor: oysterBay,
                      borderColor: malachite),
                  Widgets().verticalSpace(2.h),
                  Widgets().titleText(titleText: 'Select Event', isStar: false, fontSize: 10.sp),
                  Widgets().verticalSpace(1.h),
                  Widgets().commonDropdown(
                      hintText: "Selected",
                      onChanged: (value) {
                        setState(() {
                          selectedBu = value;
                        });
                      },
                      itemValue: itemValue,
                      selectedValue: selectedBu),
                  Widgets().verticalSpace(2.h),
                  Widgets().titleText(titleText: 'Name', isStar: false, fontSize: 10.sp),
                  Widgets().verticalSpace(1.h),
                  Widgets().textFieldWithoutIcon(nameController, 'Enter here', TextInputType.text),
                  Widgets().verticalSpace(2.h),
                  Widgets().titleText(titleText: 'Visit Brief', isStar: false, fontSize: 10.sp),
                  Widgets().verticalSpace(1.h),
                  Widgets().commentContainer(hintText: 'Enter here', commentController: commentController),
                  Widgets().verticalSpace(2.h),
                  Widgets().titleText(titleText: 'Next Action Plan', isStar: false, fontSize: 10.sp),
                  Widgets().verticalSpace(1.h),
                  Widgets().commentContainer(hintText: 'Enter here', commentController: commentController),
                  Widgets().verticalSpace(2.h),
                  Widgets().iconElevationButton(
                      onTap: () {},
                      icon: camera,
                      titleText: 'Take Your Photo',
                      isBackgroundOk: false,
                      width: 100.w,
                      bgColor: codGray,
                      textColor: alizarinCrimson,
                      iconColor: alizarinCrimson),
                  Widgets().verticalSpace(2.h),
                  Widgets().meetDetailsTileWithSingleColor(
                      bgColor: white,
                      circleColor: alizarinCrimson,
                      iconNameFirst: out,
                      iconNameSecond: calender,
                      iconNameThird: clock,
                      titleTextFirst: 'OUT',
                      titleTextSecond: 'May 21, 2023',
                      titleTextThird: '11:49:08',
                      circleBorderColor: pippin,
                      borderColor: alizarinCrimson),
                  Widgets().verticalSpace(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 44.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white),
                      Widgets().dynamicButton(
                          onTap: () {
                            // Widgets().previewOrderSelectInfBottomSheet(context: context);
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
          )),
    );
  }
}
