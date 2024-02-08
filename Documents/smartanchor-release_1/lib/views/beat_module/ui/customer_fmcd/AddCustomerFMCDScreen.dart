import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';

class AddCustomerFMCDScreen extends StatefulWidget {
  const AddCustomerFMCDScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerFMCDScreen> createState() => _AddCustomerFMCDScreenState();
}

class _AddCustomerFMCDScreenState extends State<AddCustomerFMCDScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController wareHouseController = TextEditingController();
  int selectedToggleIndex = 0;
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: Container(
            width: 100.w,
            height: 100.h,
            color: alizarinCrimson,
            child: bottomDetailsSheet(),
          )),
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: 100.h,
          decoration: Widgets()
              .commonDecorationForTopLRRadiusWithBGColor(bgColor: pippin),
          child: Widgets().customLRPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Widgets().verticalSpace(2.h),
                Widgets().textWidgetWithW500(
                    titleText: "Business Unit",
                    fontSize: 11.sp,
                    textColor: codGray),
                Widgets().verticalSpace(1.h),
                Widgets().commonDropdown(
                  selectedValue: selectedBu,
                  hintText: "Selected BU",
                  onChanged: (value) {
                    setState(() {
                      selectedBu = value;
                    });
                  },
                  itemValue: itemValue,
                ),
                Widgets().verticalSpace(2.h),
                Widgets().textWidgetWithW500(
                    titleText: "Address", fontSize: 11.sp, textColor: codGray),
                Widgets().verticalSpace(2.h),
                Widgets().textFieldWithoutIcon(
                    wareHouseController, 'Enter here', TextInputType.text),
                Widgets().verticalSpace(2.h),
                Widgets().textWidgetWithW500(
                    titleText: "Information",
                    fontSize: 11.sp,
                    textColor: codGray),
                Widgets().verticalSpace(2.h),
                Widgets().commentContainer(
                    hintText: 'Enter here',
                    commentController: TextEditingController()),
                Widgets().verticalSpace(2.h),
                Widgets().iconElevationButton(
                  onTap: () {},
                  icon: camera,
                  iconColor: alizarinCrimson,
                  titleText: 'Attachement',
                  textColor: alizarinCrimson,
                  isBackgroundOk: false,
                  width: 100.w,
                  bgColor: codGray,
                ),
                Widgets().verticalSpace(2.h),
                Widgets().verticalSpace(4.h),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Widgets().dynamicButton(
                        onTap: () {},
                        height: 6.h,
                        width: 45.w,
                        buttonBGColor: codGray,
                        titleText: 'Cancel',
                        titleColor: white),
                    Widgets().horizontalSpace(2.w),
                    Widgets().dynamicButton(
                        onTap: () {},
                        height: 6.h,
                        width: 45.w,
                        buttonBGColor: alizarinCrimson,
                        titleText: 'Submit',
                        titleColor: white)
                  ],
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
