import 'package:flutter/material.dart';
import 'package:smartanchor/views/beat_module/ui/notification/Notification.dart';
import 'package:smartanchor/views/home_module/home/ui/HomePage.dart';
import '../../attendance_module/viewAttendance/ui/AttendanceMonth.dart';
import '../../tsi_module/primary_order_module/ui/primary_order/PrimaryOrder.dart';
import '../../tsi_module/secondary_order_module/ui/secondary_order/SecondaryOrder.dart';
import 'TabItems.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItems tabItem;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/",
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) {
              return getRouteName(tabItem, context);
            },
            maintainState: false);
      },
    );
  }

  Widget getRouteName(TabItems tabItem, BuildContext context) {
    switch (tabItem) {
      case TabItems.home:
        {
          return const HomePage();
        }
      case TabItems.attendance:
        {
          return const AttendanceMonth();
        }

      case TabItems.primaryOrder:
        {
          return const PrimaryOrder(navigationTag: "PrimaryOrder");
        }
      case TabItems.secondaryOrder:
        {
          return const SecondaryOrder();
        }

      case TabItems.reports:
        {
          return const NotificationScreen();
        }
    }
  }
}
