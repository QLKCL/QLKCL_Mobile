import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/test.dart';
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
  late Test? testData;

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

  final _formKey = GlobalKey<FormState>();
  final testCodeController = TextEditingController();
  final userCodeController = TextEditingController();
  final userNameController = TextEditingController();
  final stateController = TextEditingController();
  final typeController = TextEditingController();
  final resultController = TextEditingController();

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
                testData = Test.fromJson(snapshot.data);
                if (testData != null) {
                  testCodeController.text = testData!.code;
                  userCodeController.text = testData!.user.code;
                  userNameController.text = testData!.user.fullName;
                  stateController.text = testData!.status;
                  typeController.text = testData!.type;
                  resultController.text = testData!.result;
                }
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Input(
                          label: 'Mã phiếu',
                          enabled: false,
                          initValue: testData!.code,
                        ),
                        Input(
                          label: 'Mã người xét nghiệm',
                          enabled: false,
                          initValue: testData!.user.code,
                        ),
                        Input(
                          label: 'Họ và tên',
                          hint: 'Nhập họ và tên',
                          enabled: false,
                          initValue: testData!.user.fullName,
                        ),
                        DropdownInput<KeyValue>(
                          label: 'Trạng thái',
                          hint: 'Chọn trạng thái',
                          required: true,
                          itemValue: testStateList,
                          itemAsString: (KeyValue? u) => u!.name,
                          maxHeight: 112,
                          compareFn: (item, selectedItem) =>
                              item?.id == selectedItem?.id,
                          selectedItem: testStateList.safeFirstWhere(
                              (state) => state.id == stateController.text),
                          onChanged: (value) {
                            if (value == null) {
                              stateController.text = "";
                            } else {
                              stateController.text = value.id;
                            }
                          },
                        ),
                        DropdownInput<KeyValue>(
                          label: 'Kỹ thuật xét nghiệm',
                          hint: 'Chọn kỹ thuật xét nghiệm',
                          required: true,
                          itemValue: testTypeList,
                          itemAsString: (KeyValue? u) => u!.name,
                          maxHeight: 112,
                          compareFn: (item, selectedItem) =>
                              item?.id == selectedItem?.id,
                          selectedItem: testTypeList.safeFirstWhere(
                              (type) => type.id == typeController.text),
                          onChanged: (value) {
                            if (value == null) {
                              typeController.text = "";
                            } else {
                              typeController.text = value.id;
                            }
                          },
                        ),
                        DropdownInput<KeyValue>(
                          label: 'Kết quả',
                          hint: 'Chọn kết quả',
                          required: true,
                          itemValue: testValueList,
                          itemAsString: (KeyValue? u) => u!.name,
                          maxHeight: 168,
                          compareFn: (item, selectedItem) =>
                              item?.id == selectedItem?.id,
                          selectedItem: testValueList.safeFirstWhere(
                              (result) => result.id == resultController.text),
                          onChanged: (value) {
                            if (value == null) {
                              resultController.text = "";
                            } else {
                              resultController.text = value.id;
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Xác nhận',
                              style: TextStyle(color: CustomColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            EasyLoading.show();
            return Container();
          },
        ),
      ),
    );
  }
}
