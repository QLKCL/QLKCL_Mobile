import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';

class MedDeclForm extends StatefulWidget {
  const MedDeclForm({
    Key? key,
    this.mode = Permission.view,
    this.medicalDeclData,
    this.phone,
    this.name,
  }) : super(key: key);
  final Permission mode;
  final MedicalDecl? medicalDeclData;
  final String? phone;
  final String? name;

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
  final bloodPressureMinController = TextEditingController();
  final bloodPressureMaxController = TextEditingController();
  final otherController = TextEditingController();
  final extraSymptomController = TextEditingController();
  final mainSymptomController = TextEditingController();
  final spo2Controller = TextEditingController();

  String? phoneError;

  @override
  void initState() {
    super.initState();
    //Data contained
    if (widget.medicalDeclData != null) {
      userNameController.text = widget.medicalDeclData?.user.fullName != null
          ? widget.medicalDeclData!.user.fullName
          : widget.name ?? "";

      heartBeatController.text = widget.medicalDeclData?.heartbeat != null
          ? widget.medicalDeclData!.heartbeat.toString()
          : "";

      temperatureController.text = widget.medicalDeclData?.temperature != null
          ? widget.medicalDeclData!.temperature.toString()
          : "";

      breathingController.text = widget.medicalDeclData?.breathing != null
          ? widget.medicalDeclData!.breathing.toString()
          : "";

      bloodPressureMinController.text =
          widget.medicalDeclData?.bloodPressureMin != null
              ? widget.medicalDeclData!.bloodPressureMin.toString()
              : "";

      bloodPressureMaxController.text =
          widget.medicalDeclData?.bloodPressureMax != null
              ? widget.medicalDeclData!.bloodPressureMax.toString()
              : "";

      spo2Controller.text = widget.medicalDeclData?.spo2 != null
          ? widget.medicalDeclData!.spo2.toString()
          : "";
    } else {
      isChecked = widget.phone != null;
      phoneNumberController.text = widget.phone ?? "";
      userNameController.text = widget.name ?? "";
    }
  }

  //submit
  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate() &&
        ((isChecked == false) ||
            (isChecked == true && (phoneError == null || phoneError == "")))) {
      final CancelFunc cancel = showLoading();
      final response = await createMedDecl(createMedDeclDataForm(
        phoneNumber: isChecked ? phoneNumberController.text : null,
        heartBeat: int.tryParse(heartBeatController.text),
        temperature: double.tryParse(temperatureController.text),
        breathing: int.tryParse(breathingController.text),
        bloodPressureMin: int.tryParse(bloodPressureMinController.text),
        bloodPressureMax: int.tryParse(bloodPressureMaxController.text),
        mainSymtoms: mainSymptomController.text,
        extraSymtoms: extraSymptomController.text,
        otherSymtoms: otherController.text,
        spo2: double.tryParse(spo2Controller.text),
      ));

      cancel();
      showNotification(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.mode == Permission.add)
                  ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 8),
                    child: CheckboxListTile(
                      title: const Text("Khai hộ"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ),
                if (widget.mode == Permission.add)
                  // SĐT người khai hộ
                  Input(
                    label: 'Số điện thoại',
                    hint: 'SĐT người được khai báo',
                    margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    required: isChecked,
                    type: TextInputType.phone,
                    controller: phoneNumberController,
                    validatorFunction: isChecked ? phoneValidator : null,
                    enabled: isChecked,
                    onChangedFunction: (_) async {
                      if (phoneNumberController.text.isEmpty) {
                        userNameController.text = "";
                        setState(() {});
                      } else {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        }
                      }
                    },
                    onSavedFunction: (value) async {
                      final data =
                          await getUserByPhone(data: {"phone_number": value});
                      if (data.status == Status.success) {
                        phoneError = null;
                        userNameController.text = data.data['full_name'];
                      } else {
                        phoneError = data.message;
                        userNameController.text = "";
                      }
                      setState(() {});
                    },
                    autoValidate: false,
                    error: phoneError,
                  ),
                Input(
                  label: 'Họ và tên',
                  controller: userNameController,
                  enabled: false,
                ),

                if (widget.mode == Permission.view)
                  Input(
                    label: 'Thời gian khai báo',
                    initValue: widget.medicalDeclData?.createdAt != null
                        ? DateFormat("dd/MM/yyyy HH:mm:ss")
                            .format(widget.medicalDeclData!.createdAt.toLocal())
                        : "",
                    enabled: false,
                  ),
                if (widget.mode == Permission.view &&
                    widget.medicalDeclData?.createdBy != null &&
                    widget.medicalDeclData?.createdBy.id !=
                        widget.medicalDeclData?.user.code)
                  Input(
                    label: 'Người khai báo',
                    initValue: widget.medicalDeclData!.createdBy.name,
                    enabled: false,
                  ),

                //Medical Declaration Info
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                  validatorFunction: intNullableValidator,
                  enabled: widget.mode == Permission.add,
                ),
                Input(
                  label: 'Nhiệt độ cơ thể (\u00B0C)',
                  hint: 'Nhiệt độ cơ thể (\u00B0C)',
                  type: TextInputType.number,
                  controller: temperatureController,
                  enabled: widget.mode == Permission.add,
                ),
                Input(
                  label: 'Nồng độ Oxi trong máu (%)',
                  hint: 'Nồng độ Oxi trong máu (%)',
                  type: TextInputType.number,
                  controller: spo2Controller,
                  enabled: widget.mode == Permission.add,
                ),
                Input(
                  label: 'Nhịp thở (lần/phút)',
                  hint: 'Nhịp thở (lần/phút)',
                  type: TextInputType.number,
                  controller: breathingController,
                  validatorFunction: intNullableValidator,
                  enabled: widget.mode == Permission.add,
                ),
                Input(
                  label: 'Huyết áp tâm thu (mmHg)',
                  hint: 'Huyết áp tâm thu (mmHg)',
                  type: TextInputType.number,
                  controller: bloodPressureMaxController,
                  enabled: widget.mode == Permission.add,
                  onChangedFunction: (_) async {
                    if (bloodPressureMaxController.text.isEmpty) {
                      setState(() {});
                    } else {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    }
                  },
                  required: bloodPressureMinController.text.isNotEmpty &&
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Huyết áp tâm trương (mmHg)',
                  hint: 'Huyết áp tâm trương (mmHg)',
                  type: TextInputType.number,
                  controller: bloodPressureMinController,
                  enabled: widget.mode == Permission.add,
                  onChangedFunction: (_) async {
                    if (bloodPressureMinController.text.isEmpty) {
                      setState(() {});
                    } else {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    }
                  },
                  required: bloodPressureMaxController.text.isNotEmpty &&
                      widget.mode == Permission.add,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: const Text('B/ Triệu chứng nghi nhiễm:',
                      style: TextStyle(fontSize: 16)),
                ),

                MultiDropdownInput<KeyValue>(
                  label: 'Triệu chứng nghi nhiễm',
                  hint: 'Chọn triệu chứng',
                  itemValue: symptomMainList,
                  mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                      ? Mode.DIALOG
                      : Mode.BOTTOM_SHEET,
                  dropdownBuilder: customDropDown,
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
                  enabled: widget.mode != Permission.view,
                  maxHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      100,
                  popupTitle: 'Triệu chứng nghi nhiễm',
                ),

                MultiDropdownInput<KeyValue>(
                  label: 'Triệu chứng khác',
                  hint: 'Chọn triệu chứng',
                  itemValue: symptomExtraList,
                  mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                      ? Mode.DIALOG
                      : Mode.BOTTOM_SHEET,
                  dropdownBuilder: customDropDown,
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
                  enabled: widget.mode != Permission.view,
                  maxHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      100,
                  popupTitle: 'Triệu chứng khác',
                ),

                Input(
                  label: 'Khác',
                  hint: 'Khác',
                  controller: otherController,
                  enabled: widget.mode == Permission.add,
                ),
                const SizedBox(height: 8),

                //Button add medical declaration
                if (widget.mode == Permission.add)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTileTheme(
                        contentPadding: const EdgeInsets.only(left: 8),
                        child: CheckboxListTile(
                          title: Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: const Text(
                                "Tôi cam kết hoàn toàn chịu trách nhiệm về tính chính xác và trung thực của thông tin đã cung cấp",
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
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Text(
                              '(*)',
                              style: TextStyle(
                                fontSize: 16,
                                color: error,
                              ),
                            ),
                            const Text(
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
                                      status: Status.error);
                                },
                          child: Text(
                            "Khai báo",
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
