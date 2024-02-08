import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';

class NukkadMeetDetails extends StatefulWidget {
  int index;
  NukkadMeetDetails({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<NukkadMeetDetails> createState() => _NukkadMeetDetailsState();
}

class _NukkadMeetDetailsState extends State<NukkadMeetDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: SingleChildScrollView(
            child: Widgets().customLRPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().verticalSpace(2.h),
                  Widgets().meetDetailsTile(
                      gradientColorsList: [magicMint, oysterBay],
                      iconNameFirst: clockInIcon,
                      iconNameSecond: calender,
                      iconNameThird: clock,
                      titleTextFirst: 'IN',
                      titleTextSecond: 'May 21, 2023',
                      titleTextThird: '11:49:08'),
                  Widgets().verticalSpace(1.5.h),
                  Widgets().meetDetailsTile(
                      gradientColorsList: [pink, zumthor],
                      iconNameFirst: out,
                      iconNameSecond: calender,
                      iconNameThird: clock,
                      titleTextFirst: 'OUT',
                      titleTextSecond: 'May 21, 2023',
                      titleTextThird: '11:49:08'),
                  Widgets().verticalSpace(1.h),
                  Widgets().nukkadMeetDetails(context),
                  Widgets().verticalSpace(1.h),
                ],
              ),
            ),
          )),
    );
  }
}
