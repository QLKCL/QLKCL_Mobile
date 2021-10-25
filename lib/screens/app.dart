import 'package:flutter/material.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/routes.dart';
import 'package:qlkcl/components/tab_item.dart';
import 'package:qlkcl/components/tab_navigator.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _currentTab = TabItem.homepage;
  final _navigatorKeys = {
    TabItem.homepage: GlobalKey<NavigatorState>(),
    TabItem.quarantine_person: GlobalKey<NavigatorState>(),
    TabItem.qr_code_scan: GlobalKey<NavigatorState>(),
    TabItem.quarantine_ward: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);

      switch (_currentTab) {
        case TabItem.homepage:
          _navigatorKeys[tabItem]!.currentState!.pushNamed(Routes.homepage);
          break;
        case TabItem.quarantine_person:
          _navigatorKeys[tabItem]!
              .currentState!
              .pushNamed(Routes.quarantine_person);
          break;
        case TabItem.qr_code_scan:
          _navigatorKeys[tabItem]!.currentState!.pushNamed(Routes.qr_code_scan);
          break;
        case TabItem.quarantine_ward:
          _navigatorKeys[tabItem]!
              .currentState!
              .pushNamed(Routes.quarantine_ward);
          break;
        case TabItem.account:
          _navigatorKeys[tabItem]!.currentState!.pushNamed(Routes.account);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.homepage) {
            // select 'main' tab
            _selectTab(TabItem.homepage);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.homepage),
          _buildOffstageNavigator(TabItem.quarantine_person),
          _buildOffstageNavigator(TabItem.qr_code_scan),
          _buildOffstageNavigator(TabItem.quarantine_ward),
          _buildOffstageNavigator(TabItem.account),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
