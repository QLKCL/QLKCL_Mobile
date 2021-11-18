import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/constant.dart';

class MedDeclForm extends StatefulWidget {
  const MedDeclForm({
    Key? key,
    this.mode = Permission.view,
    this.medicalDeclData,
  }) : super(key: key);
  final Permission mode;
  final MedicalDecl? medicalDeclData;

  @override
  _MedDeclFormState createState() => _MedDeclFormState();
}

class _MedDeclFormState extends State<MedDeclForm> {
  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  final userNameController = TextEditingController();
  final heartBeatController = TextEditingController();
  final tempuratureController = TextEditingController();
  final breathingController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final otherController = TextEditingController();
  final extraSymptomController = TextEditingController();
  final mainSymptomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Data contained
    userNameController.text = widget.medicalDeclData?.user.fullName != null
        ? widget.medicalDeclData!.user.fullName
        : "";

    heartBeatController.text = widget.medicalDeclData?.heartbeat != null
        ? widget.medicalDeclData!.heartbeat.toString()
        : "";

    tempuratureController.text = widget.medicalDeclData?.temperature != null
        ? widget.medicalDeclData!.temperature.toString()
        : "";

    breathingController.text = widget.medicalDeclData?.breathing != null
        ? widget.medicalDeclData!.breathing.toString()
        : "";

    bloodPressureController.text = widget.medicalDeclData?.breathing != null
        ? widget.medicalDeclData!.bloodPressure.toString()
        : "";

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người khai hộ
                Input(
                  label: 'Họ và tên',
                  controller: userNameController,
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
                  controller: heartBeatController,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Nhiệt độ cơ thể (độ C)',
                  hint: 'Nhiệt độ cơ thể (độ C)',
                  type: TextInputType.number,
                  controller: tempuratureController,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                Input(
                  label: 'Nồng độ Oxi trong máu (%)',
                  hint: 'Nồng độ Oxi trong máu (%)',
                  type: TextInputType.number,
                  controller: breathingController,
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
                          .map((e) => symptomMainList[int.parse(e)])
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
                  maxHeight: 700,
                  popupTitle: 'Triệu chứng nghi nhiễm',
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
                  selectedItems: (widget.medicalDeclData?.extraSymptoms != null)
                      ? (widget.medicalDeclData!.extraSymptoms
                          .toString()
                          .split(',')
                          .map((e) => symptomExtraList[int.parse(e)])
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
                  maxHeight: 700,
                  popupTitle: 'Triệu chứng khác',
                ),

                Input(
                  label: 'Khác',
                  hint: 'Khác',
                  controller: otherController,
                  enabled: (widget.mode == Permission.add) ? true : false,
                ),
                SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  // if (selectedItems.isEmpty) {
  //   return Container();
  // }

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
