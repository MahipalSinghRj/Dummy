import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../price_list/BeatPriceList.dart';
import '../stock_details/StockDetails.dart';

class PriceAndStock extends StatefulWidget {
  const PriceAndStock({Key? key}) : super(key: key);

  @override
  State<PriceAndStock> createState() => _PriceAndStockState();
}

class _PriceAndStockState extends State<PriceAndStock> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
          decoration: Widgets().commonDecorationForTopLeftRightRadius(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().draggableBottomSheetTopContainer(titleText: "Price And Stock"),
                Widgets().verticalSpace(2.h),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.h),
                        ),
                        child: ToggleSwitch(
                          minWidth: 32.w,
                          minHeight: 6.h,
                          cornerRadius: 20.0,
                          activeBgColors: [
                            [alizarinCrimson],
                            [alizarinCrimson],
                          ],
                          customTextStyles: [
                            TextStyle(color: selectedToggleIndex == 0 ? white : codGray, fontSize: 13.sp),
                            TextStyle(color: selectedToggleIndex == 1 ? white : codGray, fontSize: 13.sp),
                          ],
                          inactiveBgColor: magnolia,
                          initialLabelIndex: selectedToggleIndex,
                          totalSwitches: 2,
                          labels: const [
                            'Price List',
                            'Stock',
                          ],
                          radiusStyle: true,
                          onToggle: (index) {
                            setState(() {
                              selectedToggleIndex = index ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: selectedToggleIndex == 0,
                  child: Widgets().customLRPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Business Unit", fontSize: 11.sp, textColor: codGray),
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
                        Widgets().textWidgetWithW500(titleText: "Select Business Division", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().commonDropdown(
                          selectedValue: selectedBu,
                          hintText: "-Selected-",
                          onChanged: (value) {
                            setState(() {
                              selectedBu = value;
                            });
                          },
                          itemValue: itemValue,
                        ),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Warehouse", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWithoutIcon(wareHouseController, 'Enter here', TextInputType.text),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Select Business Division", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().commonDropdown(
                          selectedValue: selectedBu,
                          hintText: "-Selected-",
                          onChanged: (value) {
                            setState(() {
                              selectedBu = value;
                            });
                          },
                          itemValue: itemValue,
                        ),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Warehouse", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWidget(controller: searchController, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                        Widgets().verticalSpace(4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white),
                            Widgets().horizontalSpace(2.w),
                            Widgets().dynamicButton(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return const PriceList();
                                  }));
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: alizarinCrimson,
                                titleText: 'Search',
                                titleColor: white)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedToggleIndex == 1,
                  child: Widgets().customLRPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Code", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWithoutIcon(wareHouseController, 'Enter here', TextInputType.text),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Warehouse Code", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWithoutIcon(wareHouseController, 'Enter here', TextInputType.text),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: "Product Code", fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWithoutIcon(wareHouseController, 'Enter here', TextInputType.text),
                        Widgets().verticalSpace(4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 45.w, buttonBGColor: codGray, titleText: 'Cancel', titleColor: white),
                            Widgets().horizontalSpace(2.w),
                            Widgets().dynamicButton(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return const StockDetails();
                                  }));
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: alizarinCrimson,
                                titleText: 'Search',
                                titleColor: white)
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
