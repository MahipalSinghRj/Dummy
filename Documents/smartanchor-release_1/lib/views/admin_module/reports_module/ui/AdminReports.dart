import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import '../../home_module/controllers/AdminHomeController.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({Key? key}) : super(key: key);

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return SafeArea(
          child: Widgets().scaffoldWithAppBarDrawer(
              context: context,
              body: Container(
                height: 100.h,
                width: 100.w,
                color: white,
                child: bottomDetailsSheet(),
              )));
    });
  }

  Widget bottomDetailsSheet() {
    return const Center(
      child: Text(
        "Reports will be available soon",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
