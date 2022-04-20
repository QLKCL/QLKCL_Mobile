import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/components/time_input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/vaccine_dose.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CreateVaccineDose extends StatefulWidget {
  static const String routeName = "/create_vaccine_dose";
  const CreateVaccineDose({Key? key, this.code}) : super(key: key);
  final String? code;

  @override
  _CreateVaccineDoseState createState() => _CreateVaccineDoseState();
}

class _CreateVaccineDoseState extends State<CreateVaccineDose> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController vaccineController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final injectionPlaceController = TextEditingController();
  final batchNumberController = TextEditingController();
  final symptomAfterInjectedController = TextEditingController();
  List<KeyValue> vaccineList = [];

  @override
  void initState() {
    super.initState();
    fetchVaccineList().then((value) => setState(() {
          vaccineList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khai báo tiêm vaccine'),
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
                  children: [
                    DropdownInput<KeyValue>(
                      label: 'Vaccine',
                      hint: 'Chọn loại vaccine',
                      required: true,
                      itemValue: vaccineList,
                      onFind: vaccineList.isEmpty
                          ? (String? filter) => fetchVaccineList()
                          : null,
                      onChanged: (value) {
                        if (value == null) {
                          vaccineController.text = "";
                        } else {
                          vaccineController.text = value.id.toString();
                        }
                      },
                      itemAsString: (KeyValue? u) => u!.name,
                      compareFn: (item, selectedItem) =>
                          item?.id == selectedItem?.id,
                      showSearchBox: true,
                      mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                          ? Mode.DIALOG
                          : Mode.BOTTOM_SHEET,
                      maxHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          100,
                      popupTitle: 'Vaccine',
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: NewDateInput(
                            label: 'Ngày',
                            controller: dateController,
                            required: true,
                            onChangedFunction: () {
                              if (timeController.text == "") {
                                timeController.text =
                                    "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
                              }
                              setState(() {});
                            },
                            maxDate: DateTime.now(),
                            margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          ),
                        ),
                        Expanded(
                          child: TimeInput(
                            label: "Thời gian",
                            controller: timeController,
                            enabled: dateController.text != "",
                            required: true,
                          ),
                        ),
                      ],
                    ),
                    Input(
                      label: 'Nơi tiêm',
                      controller: injectionPlaceController,
                      showClearButton: false,
                    ),
                    Input(
                      label: 'Số lô',
                      controller: batchNumberController,
                      showClearButton: false,
                    ),
                    Input(
                      label: 'Triệu chứng sau tiêm',
                      maxLines: 10,
                      controller: symptomAfterInjectedController,
                      showClearButton: false,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          'Khai báo',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
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
      final response = await createVaccineDose(
        data: createVaccineDoseDataForm(
          injectionDate: parseDateTimeWithTimeZone(dateController.text,
              time: timeController.text),
          userCode: widget.code ?? await getCode(),
          vaccineId: vaccineController.text,
          injectionPlace: injectionPlaceController.text,
          batchNumber: batchNumberController.text,
          symptomAfterInjected: symptomAfterInjectedController.text,
        ),
      );
      cancel();
      showNotification(response);
    }
  }
}
