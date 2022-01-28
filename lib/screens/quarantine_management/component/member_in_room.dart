import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';

class MemberRoom extends StatelessWidget {
  final data;
  const MemberRoom({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  MemberCard(
                    name: data[index]['full_name'] ?? "",
                    gender: data[index]['gender'] ?? "",
                    birthday: data[index]['birthday'] ?? "",
                    lastTestResult: data[index]['positive_test_now'],
                    lastTestTime: data[index]['last_tested'],
                    healthStatus: data[index]['health_status'],
                    isThreeLine: false,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => UpdateMember(
                                    code: data[index]['code'],
                                  )));
                    },
                    menus: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: CustomColors.disableText,
                      ),
                      onSelected: (result) {
                        if (result == 'update_info') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => UpdateMember(
                                        code: data[index]['code'],
                                      )));
                        } else if (result == 'create_medical_declaration') {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MedicalDeclarationScreen(
                                        phone: data[index]["phone_number"],
                                      )));
                        } else if (result == 'medical_declare_history') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => ListMedicalDeclaration(
                                        code: data[index]['code'],
                                        phone: data[index]["phone_number"],
                                      )));
                        } else if (result == 'create_test') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => AddTest(
                                        code: data[index]["code"],
                                        name: data[index]['full_name'],
                                      )));
                        } else if (result == 'test_history') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => ListTest(
                                        code: data[index]["code"],
                                        name: data[index]['full_name'],
                                      )));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('Cập nhật thông tin'),
                          value: "update_info",
                        ),
                        PopupMenuItem(
                          child: Text('Khai báo y tế'),
                          value: "create_medical_declaration",
                        ),
                        PopupMenuItem(
                          child: Text('Lịch sử khai báo y tế'),
                          value: "medical_declare_history",
                        ),
                        PopupMenuItem(
                          child: Text('Tạo phiếu xét nghiệm'),
                          value: "create_test",
                        ),
                        PopupMenuItem(
                          child: Text('Lịch sử xét nghiệm'),
                          value: "test_history",
                        ),
                      ],
                    ),
                  ),
                  index == data.length - 1 ? SizedBox(height: 70) : Container(),
                ],
              );
            },
            itemCount: data.length,
          );
  }
}
