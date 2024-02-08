import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class AddCustomerServiceScreen extends StatefulWidget {
  const AddCustomerServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerServiceScreen> createState() =>
      _AddCustomerServiceScreenState();
}

class _AddCustomerServiceScreenState extends State<AddCustomerServiceScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  int selectedToggleIndex = 0;
  List<String> itemValue = [
    "Product Quality",
    "Logistics",
    "Commercial Claim",
    "Feedbacks"
  ];
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
                    titleText: "Customer Name/Code",
                    fontSize: 11.sp,
                    textColor: codGray),
                Widgets().verticalSpace(2.h),
                Widgets().textFieldWithoutIcon(
                    customerNameController, 'Enter here', TextInputType.text),
                Widgets().verticalSpace(2.h),
                Widgets().textWidgetWithW500(
                    titleText: "Customer Service",
                    fontSize: 11.sp,
                    textColor: codGray),
                Widgets().verticalSpace(1.h),
                Widgets().commonDropdown(
                  selectedValue: selectedBu,
                  hintText: "Selected",
                  onChanged: (value) {
                    setState(() {
                      selectedBu = value;
                    });
                  },
                  itemValue: itemValue,
                ),
                Widgets().verticalSpace(2.h),
                Widgets().textWidgetWithW500(
                    titleText: "Remarks", fontSize: 11.sp, textColor: codGray),
                Widgets().verticalSpace(2.h),
                Widgets().commentContainer(
                    hintText: 'Enter here',
                    commentController: TextEditingController()),
                Widgets().verticalSpace(2.h),
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
