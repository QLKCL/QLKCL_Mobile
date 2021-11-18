import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';
import '../../components/input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:qlkcl/components/dropdown_field.dart';

class MedicalDeclarationScreen extends StatefulWidget {
  static const String routeName = "/medical_declaration";

  const MedicalDeclarationScreen(
      {Key? key, this.code, this.mode = Permission.view})
      : super(key: key);
  final String? code;
  final Permission mode;

  @override
  _MedicalDeclarationScreenState createState() =>
      _MedicalDeclarationScreenState();
}

class _MedicalDeclarationScreenState extends State<MedicalDeclarationScreen> {
  bool isChecked = false;
  bool agree = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Khai báo y tế'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //khai hộ
                ListTileTheme(
                  contentPadding: EdgeInsets.all(0),
                  child: CheckboxListTile(
                    title: Text("Khai hộ"),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ),

                // SĐT người khai hộ
                isChecked
                    ? Input(
                        label: 'Số điện thoại',
                        hint: 'SĐT người được khai báo',
                        required: true,
                        type: TextInputType.number,
                        enabled: true,
                        validatorFunction: phoneValidator,
                      )
                    : Input(
                        label: 'Số điện thoại',
                        hint: 'SĐT người được khai báo',
                        required: true,
                        type: TextInputType.number,
                        enabled: false,
                      ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: const Text(
                    'A/ Chỉ số sức khỏe:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Input(
                  label: 'Nhịp tim (lần/phút)',
                  hint: 'Nhịp tim (lần/phút)',
                  type: TextInputType.number,
                ),
                Input(
                  label: 'Nhiệt độ cơ thể (độ C)',
                  hint: 'Nhiệt độ cơ thể (độ C)',
                  type: TextInputType.number,
                ),
                Input(
                  label: 'Nồng độ Oxi trong máu (%)',
                  hint: 'Nồng độ Oxi trong máu (%)',
                  type: TextInputType.number,
                ),
                Input(
                  label: 'Huyết áp (mmHg)',
                  hint: 'Huyết áp (mmHg)',
                  type: TextInputType.number,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: const Text('B/ Triệu chứng nghi nhiễm:',
                      style: TextStyle(fontSize: 16)),
                ),
                MultiDropdownInput<KeyValue>(
                  label: 'Triệu chứng nghi nhiễm',
                  hint: 'Chọn triệu chứng',
                  itemValue: symptomMainList,
                  mode: Mode.BOTTOM_SHEET,
                  dropdownBuilder: _customDropDown,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  onChanged: (value) {},
                  maxHeight: 700,
                  popupTitle: 'Triệu chứng nghi nhiễm',
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: const Text('C/ Triệu chứng khác:',
                      style: TextStyle(fontSize: 16)),
                ),
                MultiDropdownInput<KeyValue>(
                  label: 'Triệu chứng nghi nhiễm',
                  hint: 'Chọn triệu chứng',
                  itemValue: symptomExtraList,
                  mode: Mode.BOTTOM_SHEET,
                  dropdownBuilder: _customDropDown,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  onChanged: (value) {},
                  maxHeight: 700,
                  popupTitle: 'Triệu chứng nghi nhiễm',
                ),
                Input(
                  label: 'Khác',
                  hint: 'Khác',
                ),
                ListTileTheme(
                  contentPadding: EdgeInsets.all(0),
                  child: CheckboxListTile(
                    title: Container(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          "Tôi cam kết hoàn toàn chịu trách nhiệm về tính chính xác và trung thực của thông tin đã cung cấp",
                          style: TextStyle(fontSize: 13),
                        )),
                    value: agree,
                    onChanged: (bool? value) {
                      setState(() {
                        agree = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        '(*)',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.error,
                        ),
                      ),
                      Text(
                        'Thông tin bắt buộc',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Khai báo",
                      style: TextStyle(color: CustomColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorLight),
          child: Text(
            e!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }).toList(),
  );
}
