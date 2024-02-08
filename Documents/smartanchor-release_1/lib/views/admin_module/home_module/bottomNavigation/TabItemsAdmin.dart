import 'package:flutter/material.dart';

enum TabItemsAdmin { home, attendance, primaryOrder, secondaryOrder, reports }

const Map<TabItemsAdmin, String> tabName = {
  TabItemsAdmin.home: 'Home',
  TabItemsAdmin.attendance: 'Attendance',
  TabItemsAdmin.primaryOrder: 'Primary Order',
  TabItemsAdmin.secondaryOrder: 'Secondary Order',
  TabItemsAdmin.reports: 'Reports',
};

const Map<TabItemsAdmin, MaterialColor> activeTabColor = {
  TabItemsAdmin.home: Colors.red,
  TabItemsAdmin.attendance: Colors.red,
  TabItemsAdmin.primaryOrder: Colors.red,
  TabItemsAdmin.secondaryOrder: Colors.red,
  TabItemsAdmin.reports: Colors.red,
};
