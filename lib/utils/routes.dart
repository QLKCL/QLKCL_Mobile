import 'package:flutter/material.dart';
import 'package:qlkcl/screens/account/account_screen.dart';
import 'package:qlkcl/screens/account/change_password_screen.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/destination_history/destination_history_screen.dart';
import 'package:qlkcl/screens/destination_history/list_destination_history_screen.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
import 'package:qlkcl/screens/home/manager_home_screen.dart';
import 'package:qlkcl/screens/home/member_home_screen.dart';
import 'package:qlkcl/screens/manager/add_manager_screen.dart';
import 'package:qlkcl/screens/manager/list_all_manager_screen.dart';
import 'package:qlkcl/screens/manager/update_manager_screen.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/confirm_member_screen.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/notification/create_request_screen.dart';
import 'package:qlkcl/screens/notification/list_notification_screen.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/screens/quarantine_history/list_quarantine_history_screen.dart';
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
  App.routeName: (context) => const App(),
  ManagerHomePage.routeName: (context) => const ManagerHomePage(),
  MemberHomePage.routeName: (context) => const MemberHomePage(),
  Account.routeName: (context) => const Account(),
  QrCodeScan.routeName: (context) => const QrCodeScan(),
  Login.routeName: (context) => const Login(),
  ForgetPassword.routeName: (context) => const ForgetPassword(),
  Otp.routeName: (context) => const Otp(email: ''),
  CreatePassword.routeName: (context) =>
      const CreatePassword(email: '', otp: ''),
  Register.routeName: (context) => const Register(),
  ChangePassword.routeName: (context) => const ChangePassword(),
  Error.routeName: (context) => const Error(),
  ListMedicalDeclaration.routeName: (context) => const ListMedicalDeclaration(),
  MedicalDeclarationScreen.routeName: (context) =>
      const MedicalDeclarationScreen(),
  ListTest.routeName: (context) => const ListTest(),
  ListTestNoResult.routeName: (context) => const ListTestNoResult(),
  AddTest.routeName: (context) => const AddTest(),
  UpdateTest.routeName: (context) => const UpdateTest(code: "-1"),
  DetailTest.routeName: (context) => const DetailTest(code: "-1"),
  QuarantineListScreen.routeName: (context) => QuarantineListScreen(),
  NewQuarantine.routeName: (context) => NewQuarantine(),
  QuarantineDetailScreen.routeName: (context) =>
      const QuarantineDetailScreen(id: "-1"),
  EditQuarantineScreen.routeName: (context) => const EditQuarantineScreen(),
  BuildingListScreen.routeName: (context) => const BuildingListScreen(),
  ListAllMember.routeName: (context) => const ListAllMember(),
  AddMember.routeName: (context) => const AddMember(),
  UpdateMember.routeName: (context) => const UpdateMember(),
  ConfirmDetailMember.routeName: (context) => const ConfirmDetailMember(),
  BuildingDetailsScreen.routeName: (context) => const BuildingDetailsScreen(),
  FloorDetailsScreen.routeName: (context) => const FloorDetailsScreen(),
  RoomDetailsScreen.routeName: (context) => const RoomDetailsScreen(),
  EditBuildingScreen.routeName: (context) => const EditBuildingScreen(),
  AddBuildingScreen.routeName: (context) => const AddBuildingScreen(),
  EditFloorScreen.routeName: (context) => const EditFloorScreen(),
  EditRoomScreen.routeName: (context) => const EditRoomScreen(),
  AddFloorScreen.routeName: (context) => const AddFloorScreen(),
  AddRoomScreen.routeName: (context) => const AddRoomScreen(),
  ListNotification.routeName: (context) => const ListNotification(),
  CreateRequest.routeName: (context) => const CreateRequest(),
  ListVaccineDose.routeName: (context) => const ListVaccineDose(),
  ListDestinationHistory.routeName: (context) => const ListDestinationHistory(),
  DestinationHistoryScreen.routeName: (context) =>
      const DestinationHistoryScreen(),
  ListQuarantineHistory.routeName: (context) => const ListQuarantineHistory(),
  ListAllManager.routeName: (context) => const ListAllManager(),
  AddManager.routeName: (context) => const AddManager(),
  UpdateManager.routeName: (context) => const UpdateManager(code: "-1"),
};
