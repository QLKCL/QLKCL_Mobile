import 'package:flutter/material.dart';

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
