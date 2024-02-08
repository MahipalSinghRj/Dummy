import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/AppBar.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            backgroundColor: pippin,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Widgets().customLRPadding(
                    child: Column(
                      children: [
                        Widgets().verticalSpace(2.h),
                        Image.asset(errorImage),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW700(titleText: 'Page Not Found', fontSize: 16.sp),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW400(titleText: 'The page you requested could not be found', fontSize: 12.sp, textColor: codGray),
                        Widgets().verticalSpace(10.h),
                        Widgets().dynamicButton(onTap: () {}, height: 6.h, width: 100.w, buttonBGColor: alizarinCrimson, titleText: 'Show', titleColor: white)
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
