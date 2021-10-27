import 'package:flutter/material.dart';
import 'package:qlkcl/routes.dart';
import 'package:qlkcl/screens/home/home_screen.dart';
import 'package:qlkcl/theme/app_theme.dart';

// cre: https://codewithandrea.com/articles/multiple-navigators-bottom-navigation-bar/

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTab.index,
      selectedItemColor: CustomColors.secondary,
      onTap: (index) => {
        onSelectTab(
          TabItem.values[index],
        )
      },
      items: [
        _buildItem(TabItem.homepage),
        _buildItem(TabItem.quarantine_person),
        _buildItem(TabItem.qr_code_scan),
        _buildItem(TabItem.quarantine_ward),
        _buildItem(TabItem.account),
      ],
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      label: tabName[tabItem],
      icon: Icon(tabIcon[tabItem]),
    );
  }
}

enum TabItem { homepage, quarantine_person, qr_code_scan, quarantine_ward, account }

const Map<TabItem, String> tabName = {
  TabItem.homepage: 'Trang chủ',
  TabItem.quarantine_person: 'Người cách ly',
  TabItem.qr_code_scan: 'Quét mã',
  TabItem.quarantine_ward: 'Khu cách ly',
  TabItem.account: 'Tài khoản',
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.homepage: Icons.home_outlined,
  TabItem.quarantine_person: Icons.groups_outlined,
  TabItem.qr_code_scan: Icons.qr_code_scanner,
  TabItem.quarantine_ward: Icons.apartment_outlined,
  TabItem.account: Icons.person_outline,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;
  final String role = "admin";

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: ManagerHomePage.routeName,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => routes[routeSettings.name!]!(context),
        );
      },
    );
  }
}
