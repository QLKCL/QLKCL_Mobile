import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';

class DetailTest extends StatefulWidget {
  static const String routeName = "/detail_test";
  const DetailTest({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  _DetailTestState createState() => _DetailTestState();
}

class _DetailTestState extends State<DetailTest> {
  late Future<dynamic> futureTest;
  late dynamic testData;

  @override
  void initState() {
    super.initState();
    futureTest = fetchTest(data: {'code': widget.code});
    futureTest.then((value) => testData = value);
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin phiếu xét nghiệm'),
          centerTitle: true,
          actions: [
            FutureBuilder(
              future: getRole(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data != 5
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateTest(
                                        code: widget.code,
                                        testData: testData)));
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: "Cập nhật",
                        )
                      : Container();
                }
                return Container();
              },
            ),
          ],
        ),
        body: FutureBuilder<dynamic>(
          future: futureTest,
          builder: (context, snapshot) {
            showLoading();
            if (snapshot.connectionState == ConnectionState.done) {
              BotToast.closeAllLoading();
              if (snapshot.hasData) {
                return TestForm(
                  testData: Test.fromJson(snapshot.data),
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
