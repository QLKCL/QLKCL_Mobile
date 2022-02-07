import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class MedDeclForm extends StatefulWidget {
  const MedDeclForm({
    Key? key,
    this.mode = Permission.view,
    this.medicalDeclData,
    this.phone,
  }) : super(key: key);
  final Permission mode;
  final MedicalDecl? medicalDeclData;
  final String? phone;

  @override
  _MedDeclFormState createState() => _MedDeclFormState();
}

class _MedDeclFormState extends State<MedDeclForm> {
  //Add medical declaration
  bool isChecked = false;
  bool agree = false;

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final userNameController = TextEditingController();
  final heartBeatController = TextEditingController();
  final temperatureController = TextEditingController();
  final breathingController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final otherController = TextEditingController();
  final extraSymptomController = TextEditingController();
  final mainSymptomController = TextEditingController();
  final spo2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Data contained
    userNameController.text = widget.medicalDeclData?.user.fullName != null
        ? widget.medicalDeclData!.user.fullName
        : "";

    heartBeatController.text = widget.medicalDeclData?.heartbeat != null
        ? widget.medicalDeclData!.heartbeat.toString()
        : "";

    temperatureController.text = widget.medicalDeclData?.temperature != null
        ? widget.medicalDeclData!.temperature.toString()
        : "";

    breathingController.text = widget.medicalDeclData?.breathing != null
        ? widget.medicalDeclData!.breathing.toString()
        : "";

    bloodPressureController.text = widget.medicalDeclData?.breathing != null
        ? widget.medicalDeclData!.bloodPressure.toString()
        : "";

    spo2Controller.text = widget.medicalDeclData?.spo2 != null
        ? widget.medicalDeclData!.spo2.toString()
        : "";

    isChecked = widget.phone != null;
    phoneNumberController.text = widget.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //submit
    void _submit() async {
      // Validate returns true if the form is valid, or false otherwise.
      if (_formKey.currentState!.validate()) {
        CancelFunc cancel = showLoading();
        final registerResponse = await createMedDecl(createMedDeclDataForm(
          phoneNumber: phoneNumberController.text,
          heartBeat: int.tryParse(heartBeatController.text),
          temperature: double.tryParse(temperatureController.text),
          breathing: int.tryParse(breathingController.text),
          bloodPressure: double.tryParse(bloodPressureController.text),
          mainSymtoms: mainSymptomController.text,
          extraSymtoms: extraSymptomController.text,
          otherSymtoms: otherController.text,
          spo2: double.tryParse(spo2Controller.text),
        ));

        cancel();
        showNotification(registerResponse);
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người khai hộ

                (widget.mode == Permission.add)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTileTheme(
                            contentPadding: EdgeInsets.only(left: 8),
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
                                  type: TextInputType.phone,
                                  enabled: true,
                                  controller: phoneNumberController,
                                  validatorFunction: phoneValidator,
                                )
                              : Input(
                                  label: 'Số điện thoại',
                                  hint: 'SĐT người được khai báo',
                                  type: TextInputType.phone,
                                  enabled: false,
                                ),
                        ],
                      )
                    : Input(
                        label: 'Họ và tên',
                        controller: userNameController,
                        required: false,
                        enabled: false,
                      ),

                //Medical Declaration Info
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
                  controller: heartBeatController,
                  validatorFunction: intValidator,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Nhiệt độ cơ thể (độ C)',
                  hint: 'Nhiệt độ cơ thể (độ C)',
                  type: TextInputType.number,
                  controller: temperatureController,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Nồng độ Oxi trong máu (%)',
                  hint: 'Nồng độ Oxi trong máu (%)',
                  type: TextInputType.number,
                  controller: spo2Controller,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Nhịp thở (lần/phút)',
                  hint: 'Nhịp thở (lần/phút)',
                  type: TextInputType.number,
                  controller: breathingController,
                  validatorFunction: intValidator,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Huyết áp (mmHg)',
                  hint: 'Huyết áp (mmHg)',
                  type: TextInputType.number,
                  controller: bloodPressureController,
                  enabled: (widget.mode == Permission.add) ? true : false,
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
                  selectedItems: (widget.medicalDeclData?.mainSymptoms != null)
                      ? (widget.medicalDeclData!.mainSymptoms
                          .toString()
                          .split(',')
                          .map((e) => symptomMainList.safeFirstWhere(
                              (result) => result.id == int.parse(e))!)
                          .toList())
                      : null,
                  onChanged: (value) {
                    if (value == null) {
                      mainSymptomController.text = "";
                    } else {
                      mainSymptomController.text =
                          value.map((e) => e.id).join(",");
                    }
                  },
                  enabled: widget.mode != Permission.view ? true : false,
                  maxHeight: MediaQuery.of(context).size.height - 100,
                  popupTitle: 'Triệu chứng nghi nhiễm',
                ),

                MultiDropdownInput<KeyValue>(
                  label: 'Triệu chứng khác',
                  hint: 'Chọn triệu chứng',
                  itemValue: symptomExtraList,
                  mode: Mode.BOTTOM_SHEET,
                  dropdownBuilder: _customDropDown,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  selectedItems: (widget.medicalDeclData?.extraSymptoms != null)
                      ? (widget.medicalDeclData!.extraSymptoms
                          .toString()
                          .split(',')
                          .map((e) => symptomExtraList.safeFirstWhere(
                              (result) => result.id == int.parse(e))!)
                          .toList())
                      : null,
                  onChanged: (value) {
                    if (value == null) {
                      extraSymptomController.text = "";
                    } else {
                      extraSymptomController.text =
                          value.map((e) => e.id).join(",");
                    }
                  },
                  enabled: widget.mode != Permission.view ? true : false,
                  maxHeight: MediaQuery.of(context).size.height - 100,
                  popupTitle: 'Triệu chứng khác',
                ),

                Input(
                  label: 'Khác',
                  hint: 'Khác',
                  controller: otherController,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                SizedBox(height: 20),

                //Button add medical declaration
                if (widget.mode == Permission.add)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTileTheme(
                        contentPadding: EdgeInsets.only(left: 8),
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
                              ' Thông tin bắt buộc',
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
                          onPressed: agree
                              ? _submit
                              : () {
                                  showNotification(
                                      'Vui lòng chọn cam kết trước khi khai báo.',
                                      status: "error");
                                },
                          child: Text(
                            "Khai báo",
                            style: TextStyle(color: CustomColors.white),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  if (selectedItems.isEmpty) {
    return Text(
      "Chọn triệu chứng",
      style: TextStyle(fontSize: 16),
    );
  }

  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          // margin: EdgeInsets.symmetric(horizontal: 2),
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
