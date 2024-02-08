import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/views/beat_module/ui/customer_service/addCustomerServiceScreen.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import 'CustomerServiceDetailsScreen.dart';

class CustomerServiceScreen extends StatefulWidget {
  const CustomerServiceScreen({Key? key}) : super(key: key);

  @override
  State<CustomerServiceScreen> createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
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
                    titleText: "Customer Service"),
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
                          Get.to(() => AddCustomerServiceScreen());
                        },
                        icon: addIcon,
                        iconColor: alizarinCrimson,
                        titleText: 'Add',
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
                              Get.to(() => CustomerServiceDetailsScreen());
                            },
                            child: Widgets().customerServiceCard(
                              context: context,
                              customerService: "Product Quality",
                              employeeCode: "252154",
                              remark: "Meeting for Lighting Products",
                              title: "Jalaram Electronic Shop",
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
