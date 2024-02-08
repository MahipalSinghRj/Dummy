import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../attandance_module/ui/AdminAttandance.dart';
import '../../primary_order_module/ui/primary_order/AdminPrimaryOrder.dart';
import '../../reports_module/ui/AdminReports.dart';
import '../../secondary_order_module/ui/AdminSecondaryOrder.dart';
import '../ui/AdminHomePage.dart';
import 'TabItemsAdmin.dart';

class TabNavigatorAdmin extends StatelessWidget {
  const TabNavigatorAdmin({Key? key, required this.navigatorKey, required this.tabItem}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItemsAdmin tabItem;

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

  Widget getRouteName(TabItemsAdmin tabItem, BuildContext context) {
    switch (tabItem) {
      case TabItemsAdmin.home:
        {
          return const AdminHomePage();
        }
      case TabItemsAdmin.attendance:
        {
          return const AdminAttendance();
        }

      case TabItemsAdmin.primaryOrder:
        {
          return const AdminPrimaryOrder();
        }
      case TabItemsAdmin.secondaryOrder:
        {
          return const AdminSecondaryOrder();
        }

      case TabItemsAdmin.reports:
        {
          return const AdminReports();
        }
    }
  }
}