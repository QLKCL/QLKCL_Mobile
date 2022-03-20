import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/account/change_password_screen.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
import 'package:qlkcl/screens/home/manager_home_screen.dart';
import 'package:qlkcl/screens/home/member_home_screen.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/confirm_member_screen.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/notification/create_notification_screen.dart';
import 'package:qlkcl/screens/notification/list_notification_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/quarantine_management/add_building_screen.dart';
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
import 'package:qlkcl/screens/quarantine_management/add_floor_screen.dart';
import 'package:qlkcl/screens/quarantine_management/edit_floor_screen.dart';
import 'package:qlkcl/screens/quarantine_management/edit_room_screen.dart';
import 'package:qlkcl/screens/quarantine_management/add_room_screen.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';

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
  Otp.routeName: (context) => Otp(email: ''),
  CreatePassword.routeName: (context) => CreatePassword(email: '', otp: ''),
  Register.routeName: (context) => Register(),
  ChangePassword.routeName: (context) => ChangePassword(),
  Error.routeName: (context) => Error(),
  ListMedicalDeclaration.routeName: (context) => ListMedicalDeclaration(),
  ListTest.routeName: (context) => ListTest(),
  ListTestNoResult.routeName: (context) => ListTestNoResult(),
  AddTest.routeName: (context) => AddTest(),
  UpdateTest.routeName: (context) => UpdateTest(code: "-1"),
  DetailTest.routeName: (context) => DetailTest(code: "-1"),
  QuarantineListScreen.routeName: (context) => QuarantineListScreen(),
  NewQuarantine.routeName: (context) => NewQuarantine(),
  QuarantineDetailScreen.routeName: (context) => QuarantineDetailScreen(),
  EditQuarantineScreen.routeName: (context) => EditQuarantineScreen(),
  BuildingListScreen.routeName: (context) => BuildingListScreen(),
  ListAllMember.routeName: (context) => ListAllMember(),
  AddMember.routeName: (context) => AddMember(),
  UpdateMember.routeName: (context) => UpdateMember(),
  ConfirmDetailMember.routeName: (context) => ConfirmDetailMember(),
  BuildingDetailsScreen.routeName: (context) => BuildingDetailsScreen(),
  FloorDetailsScreen.routeName: (context) => FloorDetailsScreen(),
  RoomDetailsScreen.routeName: (context) => RoomDetailsScreen(),
  MedicalDeclarationScreen.routeName: (context) => MedicalDeclarationScreen(),
  EditBuildingScreen.routeName: (context) => EditBuildingScreen(),
  AddBuildingScreen.routeName: (context) => AddBuildingScreen(),
  EditFloorScreen.routeName: (context) => EditFloorScreen(),
  EditRoomScreen.routeName: (context) => EditRoomScreen(),
  AddFloorScreen.routeName: (context) => AddFloorScreen(),
  AddRoomScreen.routeName: (context) => AddRoomScreen(),
  ListNotification.routeName: (context) => ListNotification(),
  CreateRequest.routeName: (context) => CreateRequest(),
  ListVaccineDose.routeName: (context) => ListVaccineDose(),
};
