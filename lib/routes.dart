import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/account/change_password_screen.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
import 'package:qlkcl/screens/home/manager_home_screen.dart';
import 'package:qlkcl/screens/home/member_home_screen.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/sign_in/create_password_screen.dart';
import 'package:qlkcl/screens/sign_in/forget_password_screen.dart';
import 'package:qlkcl/screens/sign_in/otp_screen.dart';
import 'package:qlkcl/screens/sign_in/sign_in_screen.dart';
import 'package:qlkcl/screens/sign_up/sign_up_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_no_result_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/quarantine_list_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/quarantine_detail_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/edit_quarantine_screen.dart';

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
  ChangePassword.routeName: (context) => ChangePassword(),
  Error.routeName: (context) => Error(),
  ListMedicalDeclaration.routeName: (context) => ListMedicalDeclaration(),
  ListTest.routeName: (context) => ListTest(),
  ListTestNoResult.routeName: (context) => ListTestNoResult(),
  ListAllMember.routeName: (context) => ListAllMember(),
  QuarantineListScreen.routeName: (context) => QuarantineListScreen(),
  NewQuarantine.routeName: (context) => NewQuarantine(),
  AddTest.routeName: (context) => AddTest(),
  QuarantineDetailScreen.routeName: (context) => QuarantineDetailScreen(),
  EditQuarantine.routeName: (context) => EditQuarantine(),
};
