import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/utils/constant.dart';

class UpdateTest extends StatefulWidget {
  static const String routeName = "/update_test";
  UpdateTest({Key? key, required this.code, this.testData}) : super(key: key);
  final String code;
  final dynamic testData;

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
        body: widget.testData != null
            ? TestForm(
                testData: Test.fromJson(widget.testData),
                mode: Permission.edit,
              )
            : FutureBuilder<dynamic>(
                future: futureTest,
                builder: (context, snapshot) {
                  showLoading();
                  if (snapshot.connectionState == ConnectionState.done) {
                    BotToast.closeAllLoading();
                    if (snapshot.hasData) {
                      return TestForm(
                        testData: Test.fromJson(snapshot.data),
                        mode: Permission.edit,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }

                  return Container();
                },
              ),
      ),
    );
  }
}
