import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/home/home_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/sign_in/sign_in_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  ManagerHomePage.routeName: (context) => ManagerHomePage(),
  MemberHomePage.routeName: (context) => MemberHomePage(),
  Account.routeName: (context) => Account(),
  QrCodeScan.routeName: (context) => QrCodeScan(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
