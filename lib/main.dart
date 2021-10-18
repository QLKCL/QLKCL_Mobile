import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlkcl/home/manager_home_page.dart';
import 'package:qlkcl/home/member_home_page.dart';
import 'package:qlkcl/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý khu cách ly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MemberHomePage(),
      // home: ManagerHomePage(),
    );
  }
}
