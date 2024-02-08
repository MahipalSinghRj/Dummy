import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class Target extends StatefulWidget {
  const Target({Key? key}) : super(key: key);

  @override
  State<Target> createState() => _TargetState();
}

class _TargetState extends State<Target> {
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedValue;
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
          decoration: Widgets().commonDecorationForTopLRRadiusWithBGColor(bgColor: pippin),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().draggableBottomSheetTopContainer(titleText: "Target"),
                Widgets().verticalSpace(2.h),
                Widgets().customLRPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Widgets().verticalSpace(2.h),
                      Widgets().textWidgetWithW500(titleText: "Select Values", fontSize: 11.sp, textColor: codGray),
                      Widgets().verticalSpace(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "Monthly",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "2023",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                        ],
                      ),
                      Widgets().verticalSpace(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "June",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "June 2023",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                        ],
                      ),
                      Widgets().verticalSpace(2.h),
                      Widgets().filterByCard(
                        widget: Widgets().commonDropdown(
                          selectedValue: selectedBu,
                          hintText: "All Product Category",
                          onChanged: (value) {
                            setState(() {
                              selectedBu = value;
                            });
                          },
                          itemValue: itemValue,
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "In Thousands",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                          Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: " By Product",
                                width: 44.w,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                itemValue: itemValue,
                                selectedValue: selectedValue),
                          ),
                        ],
                      ),
                      Widgets().verticalSpace(4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white),
                          Widgets().horizontalSpace(2.w),
                          Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 45.w, buttonBGColor: alizarinCrimson, titleText: 'Show', titleColor: white)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
