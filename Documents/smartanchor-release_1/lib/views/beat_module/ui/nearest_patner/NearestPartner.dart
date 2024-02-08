import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/functionsUtils.dart';
import '../../../tsi_module/primary_order_module/ui/customer_on_map/CustomerOnMap.dart';

class NearestPartner extends StatefulWidget {
  const NearestPartner({Key? key}) : super(key: key);

  @override
  State<NearestPartner> createState() => _NearestPartnerState();
}

class _NearestPartnerState extends State<NearestPartner> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController filterController = TextEditingController();
  int selectedToggleIndex = 0;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Widgets().draggableBottomSheetTopContainer(
                    titleText: "Nearest Partners"),
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
                            [alizarinCrimson],
                          ],
                          customTextStyles: [
                            TextStyle(
                                color:
                                    selectedToggleIndex == 0 ? white : codGray,
                                fontSize: 13.sp),
                            TextStyle(
                                color:
                                    selectedToggleIndex == 1 ? white : codGray,
                                fontSize: 13.sp),
                            TextStyle(
                                color:
                                    selectedToggleIndex == 2 ? white : codGray,
                                fontSize: 13.sp)
                          ],
                          inactiveBgColor: magnolia,
                          initialLabelIndex: selectedToggleIndex,
                          totalSwitches: 3,
                          labels: const ['Customer', 'Retailer', 'Electrician'],
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
                Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Widgets().verticalSpace(2.h),
                      Widgets().textWidgetWithW500(
                          titleText: 'Nearest Customer',
                          fontSize: 12.sp,
                          textColor: codGray),
                      Widgets().verticalSpace(2.h),
                      Widgets().tileWithTwoIconAndSingleText(
                          context: context,
                          title: 'View Map',
                          titleIcon: locationIcon,
                          subtitleIcon: rightArrowWithCircleIcon,
                          tileGradientColor: [pink, zumthor],
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return CustomerOnMap();
                            }));
                          }),
                      Widgets().verticalSpace(2.h),
                      Container(
                        decoration: Widgets().commonDecoration(
                            borderRadius: 1.5.h, bgColor: white),
                        child: Widgets().textFieldWidget(
                            controller: searchController,
                            hintText: 'Search',
                            iconName: search,
                            keyBoardType: TextInputType.text,
                            fillColor: white),
                      ),
                      Widgets().verticalSpace(2.h),
                      ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Widgets().nearestPatnerAddressDetailList(
                              context: context,
                              shopName: 'Jalaram Electronic Shop',
                              customerCode: '(Code : 252154)',
                              address:
                                  '13 -b Basera Apartment New Lokhandwala Complex Andheri',
                              beat: 'Thane',
                              distance: '1.2 KM',
                              calling: () {
                                Utils().makePhoneCall("8107401889");
                              },
                              location: () {});
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
