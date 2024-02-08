import 'package:flutter/material.dart';
import '../../../debug/printme.dart';
import 'BottomNavigation.dart';
import 'TabItems.dart';
import 'TabNavigatorRoutes.dart';

class LandingPage extends StatefulWidget {
  final int selectedItemIndex;

  const LandingPage({Key? key, required this.selectedItemIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int selectedItemIndex = 0;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  var _currentTab = TabItems.home;
  final _navigatorKeys = {
    TabItems.home: GlobalKey<NavigatorState>(),
    TabItems.attendance: GlobalKey<NavigatorState>(),
    TabItems.primaryOrder: GlobalKey<NavigatorState>(),
    TabItems.secondaryOrder: GlobalKey<NavigatorState>(),
    TabItems.reports: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    setState(() {
      selectedItemIndex = widget.selectedItemIndex;
      _currentTab = selectedTab(selectedItemIndex);
    });
    super.initState();
  }

  TabItems selectedTab(int index) {
    switch (index) {
      case 0:
        {
          return TabItems.home;
        }
      case 1:
        {
          return TabItems.attendance;
        }
      case 2:
        {
          return TabItems.primaryOrder;
        }
      case 3:
        {
          return TabItems.secondaryOrder;
        }
      case 4:
        {
          return TabItems.reports;
        }

      default:
        return TabItems.home;
    }
  }

  void _selectTab(TabItems tabItem) {
    printMe("Landing page = 1");
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) {
        return route.isFirst;
      });
    } else {
      setState(() {
        selectedItemIndex = 0;
        _currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != TabItems.home) {
            setState(() {
              selectedItemIndex = 0;
            });
            _selectTab(TabItems.home);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItems.home),
            _buildOffstageNavigator(TabItems.attendance),
            _buildOffstageNavigator(TabItems.primaryOrder),
            _buildOffstageNavigator(TabItems.secondaryOrder),
            _buildOffstageNavigator(TabItems.reports),
          ]),
          bottomNavigationBar: BottomNavigation(
            selectedIndex: selectedItemIndex,
            currentTab: _currentTab,
            onSelectTab: _selectTab,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItems tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
