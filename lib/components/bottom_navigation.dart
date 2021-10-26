import 'package:flutter/material.dart';
import 'package:qlkcl/components/tab_item.dart';
import 'package:qlkcl/theme/app_theme.dart';

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
