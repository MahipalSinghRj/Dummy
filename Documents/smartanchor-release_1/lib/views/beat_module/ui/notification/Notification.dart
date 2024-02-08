import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/AppBar.dart';
import '../../../../common/Drawer.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController filterController = TextEditingController();
  int selectedToggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          isShowBackButton : false,
          context: context,
          body: Container(
            width: 100.w,
            height: 100.h,
            color: white,
            child: bottomDetailsSheet(),
          )),
    );
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
