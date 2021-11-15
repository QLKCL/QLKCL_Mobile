import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/utils/constant.dart';

class AddTest extends StatefulWidget {
  static const String routeName = "/add_test";
  AddTest({Key? key}) : super(key: key);

  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tạo phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: TestForm(
            // testData: Test(user: CreatedBy(code: )),
            mode: Permission.add,
          ),
        ),
      ),
    );
  }
}
