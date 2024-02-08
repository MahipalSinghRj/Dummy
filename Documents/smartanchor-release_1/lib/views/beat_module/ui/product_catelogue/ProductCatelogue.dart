import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class ProductCatelogue extends StatefulWidget {
  const ProductCatelogue({Key? key}) : super(key: key);

  @override
  State<ProductCatelogue> createState() => _ProductCatelogueState();
}

class _ProductCatelogueState extends State<ProductCatelogue> {
  String? selectBusinessUnit;
  String? selectProductVariant;
  String? selectPrimaryCategory;
  String? selectSubCategory;

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
              .commonDecorationForTopLRRadiusWithBGColor(bgColor: white),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().draggableBottomSheetTopContainer(
                    titleText: "Product Catelogue"),
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
                          return Widgets().beatProductCatelogueExpantionCard(
                              context: context,
                              customerCode: '2522154',
                              statusColor: malachite,
                              bu: 'Lighting',
                              masterQty: '2',
                              mrp: '₹ 142',
                              primaryCategory: 'Primary Category',
                              productName:
                                  'ABTM04247-ANMOL LED BATTEN 24W 6500K',
                              productVariant: 'LIGHTING',
                              retailPrice: '₹ 1432.78',
                              status: 'Active',
                              subCategory: 'Sub');
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
          return AlertDialog(
              content: StatefulBuilder(builder: (context1, myState) {
            return Wrap(
              spacing: 1,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets().textWidgetWithW700(
                        titleText: "Filter by", fontSize: 14.sp),
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

                                //  fetchDropDownData();
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
                              hintText: "Primary Category",
                              onChanged: (value) {
                                myState(() {
                                  selectPrimaryCategory = value;
                                });

                                //  fetchDropDownData();
                              },
                              itemValue: [
                                "Category 1",
                                "Category 2",
                                "Category 3"
                              ],
                              selectedValue: selectPrimaryCategory),
                        )),
                    Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Sub Category",
                              onChanged: (value) {
                                myState(() {
                                  selectSubCategory = value;
                                });
                              },
                              itemValue: [
                                "Category 1",
                                "Category 2",
                                "Category 3"
                              ],
                              selectedValue: selectSubCategory),
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
                              hintText: "Product Variant",
                              onChanged: (value) {
                                myState(() {
                                  selectProductVariant = value;
                                });
                              },
                              itemValue: [
                                "Variant 1",
                                "Variant 2",
                                "Variant 3",
                              ],
                              selectedValue: selectProductVariant),
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
                          // fetchData();
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
                          // setState(() {
                          //   isFilter = false;
                          //   selectedBu = null;
                          //   selectBusinessUnit = null;
                          //   selectState = null;
                          //   dateFromController.text = '';
                          //   dateToController.text = '';
                          // });
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
