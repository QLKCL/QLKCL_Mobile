import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
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
                MultiDropdownInput(
                  label: 'Triệu chứng nghi nhiễm',
                  hint: 'Chọn triệu chứng',
                  itemValue: [
                    "Ho ra máu",
                    "Thở dốc, khó thở",
                    "Đau tức ngực kéo dài",
                    "Lơ mơ, không tỉnh táo",
                  ],
                  mode: Mode.BOTTOM_SHEET,
                  dropdownBuilder: _customDropDown,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: const Text('C/ Triệu chứng khác:',
                      style: TextStyle(fontSize: 16)),
                ),
                MultiDropdownInput(
                  label: 'Triệu chứng nghi nhiễm',
                  hint: 'Chọn triệu chứng',
                  itemValue: [
                    "Mệt mỏi",
                    "Ho",
                    "Ho có đờm",
                    "Đau họng",
                    "Đau đầu",
                    "Chóng mặt",
                    "Chán ăn",
                    "Buồn nôn",
                    "Tiêu chảy",
                    "Xuất huyết ngoài da",
                    "Ớn lạnh, rét",
                    "Nổi ban ngoài da",
                    "Viêm kết mạc",
                    "Mất vị giác, khứu giác",
                    "Đau nhức cơ",
                  ],
                  mode: Mode.BOTTOM_SHEET,
                  dropdownBuilder: _customDropDown,
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

Widget _customDropDown(BuildContext context, List<String?> selectedItems) {
  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorLight),
          child: Text(
            e!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }).toList(),
  );
}
