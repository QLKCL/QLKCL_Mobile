import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/destination_history/list_destination_history_screen.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/change_quarantine_info.dart';
import 'package:qlkcl/screens/members/confirm_member_screen.dart';
import 'package:qlkcl/screens/members/requarantine_member_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/quarantine_history/list_quarantine_history_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum menusOptions {
  updateInfo,
  createMedicalDeclaration,
  medicalDeclareHistory,
  createTest,
  testHistory,
  vaccineDoseHistory,
  changeRoom,
  resetPassword,
  destinationHistory,
  quarantineHistory,
  completeQuarantine,
  requarantine,
  viewInfo,
  accept,
  deny,
  moveHospital,
}

const Map<menusOptions, String> menusOptionsValue = {
  menusOptions.updateInfo: 'update_info',
  menusOptions.createMedicalDeclaration: 'create_medical_declaration',
  menusOptions.medicalDeclareHistory: 'medical_declare_history',
  menusOptions.createTest: 'create_test',
  menusOptions.testHistory: 'test_history',
  menusOptions.vaccineDoseHistory: 'vaccine_dose_history',
  menusOptions.changeRoom: 'change_room',
  menusOptions.resetPassword: 'reset_password',
  menusOptions.destinationHistory: 'destination_history',
  menusOptions.quarantineHistory: 'quarantine_history',
  menusOptions.completeQuarantine: 'complete_qauarantine',
  menusOptions.requarantine: 'requarantine',
  menusOptions.viewInfo: 'view_info',
  menusOptions.accept: 'accpet',
  menusOptions.deny: 'deny',
  menusOptions.moveHospital: 'move_hospital',
};

const Map<menusOptions, String> menusOptionsTitle = {
  menusOptions.updateInfo: 'Cập nhật thông tin',
  menusOptions.createMedicalDeclaration: 'Khai báo y tế',
  menusOptions.medicalDeclareHistory: 'Lịch sử khai báo y tế',
  menusOptions.createTest: 'Tạo phiếu xét nghiệm',
  menusOptions.testHistory: 'Lịch sử xét nghiệm',
  menusOptions.vaccineDoseHistory: 'Thông tin tiêm chủng',
  menusOptions.changeRoom: 'Chuyển phòng',
  menusOptions.resetPassword: 'Đặt lại mật khẩu',
  menusOptions.destinationHistory: 'Lịch sử di chuyển',
  menusOptions.quarantineHistory: 'Lịch sử cách ly',
  menusOptions.completeQuarantine: 'Hoàn thành cách ly',
  menusOptions.requarantine: 'Tái cách ly',
  menusOptions.viewInfo: 'Xem thông tin',
  menusOptions.accept: 'Chấp nhận',
  menusOptions.deny: 'Từ chối',
  menusOptions.moveHospital: 'Chuyển viện',
};

Widget menus<T>(
  BuildContext context,
  T data, {
  GlobalKey<SfDataGridState>? tableKey,
  PagingController<int, T>? pagingController,
  List<menusOptions> showMenusItems = const [],
}) {
  if (data.runtimeType == FilterMember || data.runtimeType == FilterStaff) {
    final code = data.runtimeType == FilterMember
        ? (data as FilterMember).code
        : (data as FilterStaff).code;
    final phoneNumber = data.runtimeType == FilterMember
        ? (data as FilterMember).phoneNumber
        : (data as FilterStaff).phoneNumber;
    final fullName = data.runtimeType == FilterMember
        ? (data as FilterMember).fullName
        : (data as FilterStaff).fullName;
    final quarantineWard = data.runtimeType == FilterMember
        ? (data as FilterMember).quarantineWard
        : (data as FilterStaff).quarantineWard;

    return PopupMenuButton<menusOptions>(
        icon: Icon(
          Icons.more_vert,
          color: disableText,
        ),
        onSelected: (result) async {
          if (result == menusOptions.updateInfo) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => UpdateMember(
                          code: code,
                        )));
          } else if (result == menusOptions.createMedicalDeclaration) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => MedicalDeclarationScreen(
                          phone: phoneNumber,
                          name: fullName,
                        )));
          } else if (result == menusOptions.medicalDeclareHistory) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ListMedicalDeclaration(
                          code: code,
                          phone: phoneNumber,
                          name: fullName,
                        )));
          } else if (result == menusOptions.createTest) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => AddTest(
                          code: code,
                          name: fullName,
                        )));
          } else if (result == menusOptions.testHistory) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ListTest(
                          code: code,
                          name: fullName,
                        )));
          } else if (result == menusOptions.quarantineHistory) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ListQuarantineHistory(
                          code: code,
                        )));
          } else if (result == menusOptions.destinationHistory) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ListDestinationHistory(
                          code: code,
                        )));
          } else if (result == menusOptions.vaccineDoseHistory) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ListVaccineDose(
                          code: code,
                        )));
          } else if (result == menusOptions.resetPassword) {
            final CancelFunc cancel = showLoading();
            final response = await resetPass({'code': code});
            cancel();
            showNotification(response, duration: 5);
          } else if (result == menusOptions.changeRoom) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ChangeQuanrantineInfo(
                          code: code,
                          quarantineWard: quarantineWard,
                        )));
          } else if (result == menusOptions.completeQuarantine) {
            final CancelFunc cancel = showLoading();
            final response = await finishMember({'member_codes': code});
            cancel();
            showNotification(response);
            if (response.status == Status.success) {
              // ignore: use_build_context_synchronously
              if (Responsive.isDesktopLayout(context)) {
                tableKey?.currentState!.refresh();
              } else {
                pagingController!.refresh();
              }
            }
          } else if (result == menusOptions.requarantine) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => RequarantienMember(
                          code: code,
                        )));
          } else if (result == menusOptions.viewInfo) {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => ConfirmDetailMember(
                          code: code,
                        )));
          } else if (result == menusOptions.accept) {
            final CancelFunc cancel = showLoading();
            final response = await acceptOneMember({'code': code});
            cancel();
            showNotification(response);
            if (response.status == Status.success) {
              // ignore: use_build_context_synchronously
              if (Responsive.isDesktopLayout(context)) {
                tableKey?.currentState!.refresh();
              } else {
                pagingController!.refresh();
              }
            }
          } else if (result == menusOptions.deny) {
            final CancelFunc cancel = showLoading();
            final response = await denyMember({'member_codes': code});
            cancel();
            showNotification(response);
            if (response.status == Status.success) {
              // ignore: use_build_context_synchronously
              if (Responsive.isDesktopLayout(context)) {
                tableKey?.currentState!.refresh();
              } else {
                pagingController!.refresh();
              }
            }
          } else if (result == menusOptions.moveHospital) {
            showNotification("Chức năng chưa hỗ trợ", status: Status.error);
          }
        },
        itemBuilder: (BuildContext context) => showMenusItems
            .map((e) => PopupMenuItem(
                  child: Text(menusOptionsTitle[e]!),
                  value: e,
                ))
            .cast<PopupMenuEntry<menusOptions>>()
            .toList());
  } else {
    return const SizedBox();
  }
}
