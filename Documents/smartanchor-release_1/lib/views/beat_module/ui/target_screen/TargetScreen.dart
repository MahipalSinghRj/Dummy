import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  String? selectBusinessUnit;
  String? selectCategory;
  String? selectPeriod;
  String? selectZone;

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
          decoration: Widgets().commonDecorationForTopLRRadiusWithBGColor(bgColor: white),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().draggableBottomSheetTopContainer(titleText: "Target"),
                Widgets().customAll15Padding(
                  child: Column(
                    children: [
                      Widgets().tileWithTwoIconAndSingleText(
                          context: context,
                          title: 'Search by Filter',
                          titleIcon: filter,
                          subtitleIcon: rightArrowWithCircleIcon,
                          tileGradientColor: [pink, zumthor],
                          onTap: () {
                            showNewDialog();
                          }),
                      Widgets().verticalSpace(2.h),
                      ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Widgets().targetScreenCardCard(
                              context: context,
                              periodDate: "01-03-2022",
                              achievedAmount: "₹ 530.00",
                              businessUnit: "POWER",
                              category: "WIRES CABLES AND TAPES",
                              creationDate: "26-06-2021",
                              division: "WIRING DEVICE",
                              subBrand: "Building Wire",
                              targetAmount: "₹ 1432.78",
                              type: "Trade");
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: StatefulBuilder(builder: (context1, myState) {
            return Wrap(
              spacing: 1,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(closeIcon))
                  ],
                ),
                Widgets().verticalSpace(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Widgets().filterByCard(
                        widget: Widgets().textFieldWidgetWithoutIcon(
                          controller: TextEditingController(),
                          keyBoardType: TextInputType.streetAddress,
                          fillColor: white,
                          hintText: "Search Name/Code",
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Business Unit",
                              onChanged: (value) {
                                myState(() {
                                  selectBusinessUnit = value;
                                });
                              },
                              itemValue: ["Delhi", "Mubai", "Noida"],
                              selectedValue: selectBusinessUnit),
                        ))
                  ],
                ),
                Widgets().verticalSpace(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Period",
                              onChanged: (value) {
                                myState(() {
                                  selectPeriod = value;
                                });
                              },
                              itemValue: ["Category 1", "Category 2", "Category 3"],
                              selectedValue: selectPeriod),
                        )),
                    Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Zone",
                              onChanged: (value) {
                                myState(() {
                                  selectZone = value;
                                });
                              },
                              itemValue: ["Category 1", "Category 2", "Category 3"],
                              selectedValue: selectZone),
                        ))
                  ],
                ),
                Widgets().verticalSpace(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Category",
                              onChanged: (value) {
                                myState(() {
                                  selectCategory = value;
                                });
                              },
                              itemValue: ["Category 1", "Category 2", "Category 3"],
                              selectedValue: selectCategory),
                        ))
                  ],
                ),
                Widgets().verticalSpace(1.h),
                Widgets().verticalSpace(1.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Widgets().dynamicButton(
                        onTap: () async {
                          Get.back();
                        },
                        height: 5.5.h,
                        width: 32.w,
                        buttonBGColor: alizarinCrimson,
                        titleText: 'Apply',
                        titleColor: white),
                    Widgets().horizontalSpace(2.w),
                    Widgets().dynamicButton(
                        onTap: () {
                          Get.back();
                        },
                        height: 5.5.h,
                        width: 32.w,
                        buttonBGColor: Colors.black,
                        titleText: 'Clear',
                        titleColor: white),
                    Widgets().verticalSpace(1.5.h),
                  ],
                ),
              ],
            );
          }));
        });
  }
}
