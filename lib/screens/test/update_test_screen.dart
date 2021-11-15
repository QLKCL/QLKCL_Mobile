import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/utils/constant.dart';

class UpdateTest extends StatefulWidget {
  static const String routeName = "/update_test";
  UpdateTest({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  _UpdateTestState createState() => _UpdateTestState();
}

class _UpdateTestState extends State<UpdateTest> {
  late Future<dynamic> futureTest;

  @override
  void initState() {
    super.initState();
    futureTest = fetchTest(data: {'code': widget.code});
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
          title: Text('Cập nhật phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: FutureBuilder<dynamic>(
          future: futureTest,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              EasyLoading.dismiss();
              if (snapshot.hasData) {
                return TestForm(
                  testData: Test.fromJson(snapshot.data),
                  mode: Permission.edit,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            EasyLoading.show();
            return TestForm(
              mode: Permission.edit,
            );
          },
        ),
      ),
    );
  }
}
