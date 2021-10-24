import 'package:flutter/material.dart';
import 'package:qlkcl/theme/app_theme.dart';

class BottomNavigation extends StatelessWidget {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: CustomColors.secondary,
      onTap: (value) {
        // Respond to item press.
        // setState(() => _currentIndex = value);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Trang chủ',
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Người cách ly',
          icon: Icon(Icons.groups_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Quét mã',
          icon: Icon(Icons.qr_code_scanner),
        ),
        BottomNavigationBarItem(
          label: 'Khu cách ly',
          icon: Icon(Icons.apartment_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Tài khoản',
          icon: Icon(Icons.person_outline),
        ),
      ],
    );
  }
}
