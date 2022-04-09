import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/utils/constant.dart';

class AddTest extends StatefulWidget {
  static const String routeName = "/add_test";
  const AddTest({Key? key, this.code, this.name}) : super(key: key);
  final String? code;
  final String? name;

  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: TestForm(
            userCode: (widget.code != null && widget.name != null)
                ? CreatedBy(code: widget.code!, fullName: widget.name!)
                : null,
            mode: Permission.add,
          ),
        ),
      ),
    );
  }
}
