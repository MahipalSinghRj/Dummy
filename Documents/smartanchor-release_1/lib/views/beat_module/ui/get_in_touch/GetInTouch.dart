import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../common/AppBar.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class GetInTouch extends StatefulWidget {
  const GetInTouch({Key? key}) : super(key: key);

  @override
  State<GetInTouch> createState() => _GetInTouchState();
}

class _GetInTouchState extends State<GetInTouch> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
                Widgets().draggableBottomSheetTopContainer(titleText: "Get In Touch"),
                Widgets().verticalSpace(3.h),
                Widgets().customLRPadding(
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets().getInTouchCard(
                          headOfficeAddress: "3rd Floor, B Wing, i Think Techno Campus, Pokhran Road No-2, Thane (West), Thane - 400 607, Maharashtra, India.",
                          phoneNumber1: "022-42228888,",
                          phoneNumber2: '022-42228888');
                    },
                  ),
                ),
                Widgets().verticalSpace(2.h),
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
                      'Level 1',
                      'Level 2',
                    ],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        selectedToggleIndex = index ?? 0;
                      });
                    },
                  ),
                ),
                Widgets().verticalSpace(2.h),
                Widgets().customLRPadding(
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets().getInTouchCardList(
                          context: context,
                          circleTitleText: 'VK',
                          headingName: 'Vinay Kumar',
                          businessUnit: 'Lighting',
                          role: 'Application Related Issue',
                          emailID: 'slconsultant.plsing@in.panasonic.com',
                          mobileNo: '+91 99049 81545');
                    },
                  ),
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
