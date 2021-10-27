import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
import 'package:qlkcl/screens/home/home_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/sign_in/create_password_screen.dart';
import 'package:qlkcl/screens/sign_in/forget_password_screen.dart';
import 'package:qlkcl/screens/sign_in/otp_screen.dart';
import 'package:qlkcl/screens/sign_in/sign_in_screen.dart';
import 'package:qlkcl/screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  App.routeName: (context) => App(),
  ManagerHomePage.routeName: (context) => ManagerHomePage(),
  MemberHomePage.routeName: (context) => MemberHomePage(),
  Account.routeName: (context) => Account(),
  QrCodeScan.routeName: (context) => QrCodeScan(),
  SignIn.routeName: (context) => SignIn(),
  ForgetPassword.routeName: (context) => ForgetPassword(),
  Otp.routeName: (context) => Otp(),
  CreatePassword.routeName: (context) => CreatePassword(),
  SignUp.routeName: (context) => SignUp(),
  Error.routeName: (context) => new Error(),
};
