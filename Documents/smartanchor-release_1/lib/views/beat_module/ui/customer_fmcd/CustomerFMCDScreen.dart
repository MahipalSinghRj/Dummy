import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import 'AddCustomerFMCDScreen.dart';
import 'CustomerFMCDDetailsScreen.dart';

class CustomerFMCDScreen extends StatefulWidget {
  const CustomerFMCDScreen({Key? key}) : super(key: key);

  @override
  State<CustomerFMCDScreen> createState() => _CustomerFMCDScreenState();
}

class _CustomerFMCDScreenState extends State<CustomerFMCDScreen> {
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
                Widgets().draggableBottomSheetTopContainer(titleText: "Customer FMCD"),
                Widgets().customAll15Padding(
                  child: Column(
                    children: [
                      Widgets().tileWithTwoIconAndSingleText(
                          context: context,
                          title: 'Search by Filter',
                          titleIcon: filter,
                          subtitleIcon: rightArrowWithCircleIcon,
                          tileGradientColor: [pink, zumthor],
                          onTap: () {}),
                      Widgets().verticalSpace(2.h),
                      Widgets().iconElevationButton(
                        onTap: () {
                          Get.to(() => const AddCustomerFMCDScreen());
                        },
                        icon: addIcon,
                        iconColor: alizarinCrimson,
                        titleText: 'Add FMCD',
                        textColor: alizarinCrimson,
                        isBackgroundOk: false,
                        width: 100.w,
                        bgColor: codGray,
                      ),
                      Widgets().verticalSpace(2.h),
                      ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const CustomerFMCDDetailsScreen());
                            },
                            child: Widgets().customerFMCDCard(
                              context: context,
                              title: "Akshay H.",
                              address: "13 -b Basera Apartment New Lokhandwala Complex Andheri",
                              businessUnit: "Lighting",
                              customerCode: "252154",
                              dateAndTime: "May 21, 2023 | 11:49:08",
                              infromation: "Meeting for Lighting Products",
                            ),
                          );
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
}
