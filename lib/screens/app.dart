import 'package:flutter/material.dart';
import 'package:qlkcl/components/bottom_navigation.dart';

class App extends StatefulWidget {
  static const String routeName = "/app";
  final int role;
  const App({Key? key, required this.role}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late int _role;

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
    }
  }

  @override
  void initState() {
    super.initState();
    _role = widget.role;
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
          if (_role != 5) _buildOffstageNavigator(TabItem.quarantine_person),
          if (_role != 5) _buildOffstageNavigator(TabItem.quarantine_ward),
          _buildOffstageNavigator(TabItem.account),
        ]),
        bottomNavigationBar: BottomNavigation(
          role: _role,
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
        role: _role,
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
