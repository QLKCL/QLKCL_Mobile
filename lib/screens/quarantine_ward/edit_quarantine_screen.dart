import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/utils/constant.dart';
import 'component/quarantine_form.dart';

class EditQuarantine extends StatefulWidget {
  static const String routeName = "/quarantine-list/edit";


  @override
  _EditQuarantineState createState() => _EditQuarantineState();
}

class _EditQuarantineState extends State<StatefulWidget> {
 

  final appBar = AppBar(
    title: Text('Cập nhật khu cách ly'),
    centerTitle: true,
  );
  @override
  Widget build(BuildContext context) {
    return  DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: QuarantineForm(
          mode: Permission.edit,
        ),
      ),
    );
  }
}
