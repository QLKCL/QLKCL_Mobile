import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/data_form.dart';

class Hospitalize extends StatefulWidget {
  static const String routeName = "/hospitalize";
  final String code;

  const Hospitalize({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  State<Hospitalize> createState() => _HospitalizeState();
}

class _HospitalizeState extends State<Hospitalize> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController noteController = TextEditingController();
  TextEditingController hospitalNameController =
      TextEditingController(text: "Bệnh viện dã chiến");

  final List<String> hospitalList = const [
    "Bệnh viện dã chiến",
  ];

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chuyển viện"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownInput(
                      label: 'Bệnh viện',
                      hint: 'Chọn bệnh viện',
                      required: true,
                      itemValue: hospitalList,
                      selectedItem: "Bệnh viện dã chiến",
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            hospitalNameController.text = "";
                          } else {
                            hospitalNameController.text = value.toString();
                          }
                        });
                      },
                    ),
                    Input(
                      label: "Ghi chú",
                      hint: "Nhập ghi chú",
                      controller: noteController,
                      maxLines: 4,
                    ),
                    Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _submit,
                            child: const Text(
                              'Xác nhận',
                            ),
                          ),
                          const Spacer(),
                        ])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      final updateResponse = await hospitalizeMember(hospitalizeMemberDataForm(
        code: widget.code,
        hospitalName: hospitalNameController.text,
        note: noteController.text,
      ));
      cancel();
      showNotification(updateResponse);
    }
  }
}
