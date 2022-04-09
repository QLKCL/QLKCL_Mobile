import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/manager/component/manager_form.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class AddManager extends StatefulWidget {
  static const String routeName = "/add_manager";
  const AddManager({
    Key? key,
    this.quarantineWard,
  }) : super(key: key);

  final KeyValue? quarantineWard;

  @override
  _AddManagerState createState() => _AddManagerState();
}

class _AddManagerState extends State<AddManager> {
  List<String>? infoFromIdentityCard;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thêm quản lý, cán bộ"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => QrCodeScan()),
                    )
                    .then((value) => setState(() {
                          if (value != null) {
                            infoFromIdentityCard = value.split('|').toList();
                          }
                        }));
              },
              icon: const Icon(Icons.photo_camera_front_outlined),
              tooltip: "Nhập dữ liệu từ CCCD",
            ),
          ],
        ),
        body: ManagerForm(
          mode: Permission.add,
          infoFromIdentityCard: infoFromIdentityCard,
          quarantineWard: widget.quarantineWard,
        ),
      ),
    );
  }
}
