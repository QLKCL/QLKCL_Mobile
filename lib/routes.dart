import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/account/change_password_screen.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
import 'package:qlkcl/screens/home/manager_home_screen.dart';
import 'package:qlkcl/screens/home/member_home_screen.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/quarantine_management/component/add_building_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/login/create_password_screen.dart';
import 'package:qlkcl/screens/login/forget_password_screen.dart';
import 'package:qlkcl/screens/login/otp_screen.dart';
import 'package:qlkcl/screens/login/login_screen.dart';
import 'package:qlkcl/screens/register/register_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/detail_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_no_result_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/quarantine_list_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/quarantine_detail_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/edit_quarantine_screen.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';
import 'package:qlkcl/screens/quarantine_management/building_list_screen.dart';
import 'package:qlkcl/screens/quarantine_management/building_details_screen.dart';
import 'package:qlkcl/screens/quarantine_management/floor_details_screen.dart';
import 'package:qlkcl/screens/quarantine_management/room_details_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/quarantine_management/edit_building_screen.dart';
import 'package:qlkcl/screens/quarantine_management/add_building_screen.dart';
import 'package:qlkcl/screens/quarantine_management/edit_floor_screen.dart';
import 'package:qlkcl/screens/quarantine_management/edit_room_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  App.routeName: (context) => App(),
  ManagerHomePage.routeName: (context) => ManagerHomePage(),
  MemberHomePage.routeName: (context) => MemberHomePage(),
  Account.routeName: (context) => Account(),
  QrCodeScan.routeName: (context) => QrCodeScan(),
  Login.routeName: (context) => Login(),
  ForgetPassword.routeName: (context) => ForgetPassword(),
  Otp.routeName: (context) => Otp(),
  CreatePassword.routeName: (context) => CreatePassword(),
  Register.routeName: (context) => Register(),
  ChangePassword.routeName: (context) => ChangePassword(),
  Error.routeName: (context) => Error(),
  ListMedicalDeclaration.routeName: (context) => ListMedicalDeclaration(),
  ListTest.routeName: (context) => ListTest(),
  ListTestNoResult.routeName: (context) => ListTestNoResult(),
  ListAllMember.routeName: (context) => ListAllMember(),
  QuarantineListScreen.routeName: (context) => QuarantineListScreen(),
  NewQuarantine.routeName: (context) => NewQuarantine(),
  AddTest.routeName: (context) => AddTest(),
  UpdateTest.routeName: (context) => UpdateTest(),
  DetailTest.routeName: (context) => DetailTest(),
  QuarantineDetailScreen.routeName: (context) => QuarantineDetailScreen(),
  EditQuarantine.routeName: (context) => EditQuarantine(),
  AddMember.routeName: (context) => AddMember(),
  BuildingListScreen.routeName: (context) => BuildingListScreen(),
  BuildingDetailsScreen.routeName: (context) => BuildingDetailsScreen(),
  FloorDetailsScreen.routeName: (context) => FloorDetailsScreen(),
  RoomDetailsScreen.routeName: (context) => RoomDetailsScreen(),
  MedicalDeclarationScreen.routeName: (context) => MedicalDeclarationScreen(),
  EditBuildingScreen.routeName: (context) => EditBuildingScreen(),
  AddBuildingScreen.routeName: (context) => AddBuildingScreen(),
  EditFloorScreen.routeName: (context) => EditFloorScreen(),
  EditRoomScreen.routeName: (context) => EditRoomScreen(),
};
