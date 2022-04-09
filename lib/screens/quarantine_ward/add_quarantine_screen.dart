import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/utils/constant.dart';
import './component/quarantine_form.dart';

class NewQuarantine extends StatefulWidget {
  static const String routeName = "/quarantine-list/add";
  @override
  _NewQuarantineState createState() => _NewQuarantineState();
}

class _NewQuarantineState extends State<StatefulWidget> {
  final appBar = AppBar(
    title: const Text('Thêm khu cách ly'),
    centerTitle: true,
  );
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: QuarantineForm(
          mode: Permission.add,
        ),
      ),
    );
  }
}
