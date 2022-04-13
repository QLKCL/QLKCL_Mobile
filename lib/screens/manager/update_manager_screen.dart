import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/manager/component/manager_form.dart';

class UpdateManager extends StatefulWidget {
  static const String routeName = "/update_manager";
  final String code;
  const UpdateManager({Key? key, required this.code}) : super(key: key);

  @override
  _UpdateManagerState createState() => _UpdateManagerState();
}

class _UpdateManagerState extends State<UpdateManager> {
  late Future<dynamic> futureMember;
  late CustomUser personalData;

  @override
  void initState() {
    super.initState();
    futureMember = fetchMember(data: {'code': widget.code});
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin chi tiết"),
          centerTitle: true,
          // actions: [
          //   if (_tabController.index == 0)
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.qr_code_scanner),
          //       tooltip: "Nhập dữ liệu từ CCCD",
          //     ),
          // ],
        ),
        body: FutureBuilder<dynamic>(
          future: futureMember,
          builder: (context, snapshot) {
            showLoading();
            if (snapshot.connectionState == ConnectionState.done) {
              BotToast.closeAllLoading();
              if (snapshot.hasData) {
                personalData =
                    CustomUser.fromJson(snapshot.data["custom_user"]);
                final dynamic staffData = snapshot.data["staff"];
                return ManagerForm(
                  personalData: personalData,
                  staffData: staffData,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                  child: Text('Có lỗi xảy ra!'),
                );
              }
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
