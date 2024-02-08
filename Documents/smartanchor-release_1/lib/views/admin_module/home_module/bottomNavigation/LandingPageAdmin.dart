import 'package:flutter/material.dart';

import 'BottomNavigationAdmin.dart';
import 'TabItemsAdmin.dart';
import 'TabNavigatorAdmin.dart';

class LandingPageAdmin extends StatefulWidget {
  final int selectedItemIndex;
  const LandingPageAdmin({Key? key, required this.selectedItemIndex}) : super(key: key);

  @override
  State<LandingPageAdmin> createState() => _LandingPageAdminState();
}

class _LandingPageAdminState extends State<LandingPageAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int selectedItemIndex = 0;

  var _currentTab = TabItemsAdmin.home;
  final _navigatorKeys = {
    TabItemsAdmin.home: GlobalKey<NavigatorState>(),
    TabItemsAdmin.attendance: GlobalKey<NavigatorState>(),
    TabItemsAdmin.primaryOrder: GlobalKey<NavigatorState>(),
    TabItemsAdmin.secondaryOrder: GlobalKey<NavigatorState>(),
    TabItemsAdmin.reports: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    setState(() {
      selectedItemIndex = widget.selectedItemIndex;
      _currentTab = selectedTab(selectedItemIndex);
    });
    super.initState();
  }

  TabItemsAdmin selectedTab(int index) {
    switch (index) {
      case 0:
        {
          return TabItemsAdmin.home;
        }
      case 1:
        {
          return TabItemsAdmin.attendance;
        }
      case 2:
        {
          return TabItemsAdmin.primaryOrder;
        }
      case 3:
        {
          return TabItemsAdmin.secondaryOrder;
        }
      case 4:
        {
          return TabItemsAdmin.reports;
        }

      default:
        return TabItemsAdmin.home;
    }
  }

  void _selectTab(TabItemsAdmin tabItem) {
    print("in landing ===1");
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) {
        return route.isFirst;
      });
    } else {
      print("in landing ===2");
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
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != TabItemsAdmin.home) {
            setState(() {
              selectedItemIndex = 0;
            });
            _selectTab(TabItemsAdmin.home);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          // appBar: MainAppBar(context, _scaffoldKey),
          // drawer: MainDrawer(context),
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItemsAdmin.home),
            _buildOffstageNavigator(TabItemsAdmin.attendance),
            _buildOffstageNavigator(TabItemsAdmin.primaryOrder),
            _buildOffstageNavigator(TabItemsAdmin.secondaryOrder),
            _buildOffstageNavigator(TabItemsAdmin.reports),
          ]),
          bottomNavigationBar: BottomNavigationAdmin(
            selectedIndex: selectedItemIndex,
            currentTab: _currentTab,
            onSelectTab: _selectTab,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItemsAdmin tabItem) {
    print("in landing ===3");
    //  printing("_buildOffstageNavigator  and   navigatorKeys[tabItem] ########${_navigatorKeys[tabItem]}$tabItem");

    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigatorAdmin(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
