import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/vaccine_dose.dart';
import 'package:qlkcl/networking/request_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/vaccine/vaccination_certificate_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';

class SyncVaccinePortal extends StatefulWidget {
  const SyncVaccinePortal({
    Key? key,
  }) : super(key: key);

  @override
  _SyncVaccinePortalState createState() => _SyncVaccinePortalState();
}

class _SyncVaccinePortalState extends State<SyncVaccinePortal> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();
  final identityNumberController = TextEditingController();
  final healthInsuranceNumberController = TextEditingController();
  final passportNumberController = TextEditingController();
  final otpController = TextEditingController();
  bool enableNext = false;

  @override
  void initState() {
    super.initState();
    getName().then((value) {
      fullNameController.text = value;
    });
    getPhoneNumber().then((value) {
      phoneNumberController.text = value;
    });
    getBirthday().then((value) {
      birthdayController.text = value;
    });
    getGender().then((value) {
      genderController.text = value;
      setState(() {});
    });
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
          title: const Text('Tra cứu chứng nhận tiêm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Input(
                  label: 'Họ và tên',
                  required: true,
                  textCapitalization: TextCapitalization.words,
                  controller: fullNameController,
                  //enabled: false,
                ),
                Input(
                  label: 'Số điện thoại',
                  required: true,
                  type: TextInputType.phone,
                  controller: phoneNumberController,
                  validatorFunction: phoneValidator,
                  //enabled: false,
                ),
                DropdownInput<KeyValue>(
                  label: 'Giới tính',
                  hint: 'Chọn giới tính',
                  required: true,
                  itemValue: genderList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 112,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: genderList.safeFirstWhere(
                      (gender) => gender.id == genderController.text),
                  onChanged: (value) {
                    if (value == null) {
                      genderController.text = "";
                    } else {
                      genderController.text = value.id;
                    }
                  },
                  //enabled: false,
                ),
                NewDateInput(
                  label: 'Ngày sinh',
                  required: true,
                  controller: birthdayController,
                  maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  //enabled: false,
                ),
                // Input(
                //   label: 'Số CMND/CCCD',
                //   type: TextInputType.number,
                //   controller: identityNumberController,
                // ),
                // Input(
                //   label: 'Mã số BHXH/Thẻ BHYT',
                //   controller: healthInsuranceNumberController,
                // ),
                // Input(
                //   label: 'Số hộ chiếu',
                //   controller: passportNumberController,
                //   textCapitalization: TextCapitalization.characters,
                //   validatorFunction: passportValidator,
                // ),
                Input(
                  label: 'Mã xác nhận',
                  controller: otpController,
                  type: TextInputType.number,
                  enabled: enableNext,
                  // required: enableNext,
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            enableNext = false;
                          });
                          _otp();
                        },
                        child: const Text("Nhận OTP"),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: enableNext
                            ? () {
                                _submit();
                              }
                            : null,
                        child: const Text("Tra cứu"),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _otp() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();

      RequestHelper _provider =
          RequestHelper(baseUrl: "https://tiemchungcovid19.gov.vn");

      final response = await _provider.get(
        "/api/vaccination/public/otp-search",
        params: syncVaccinePortalDataForm(
          birthday: DateFormat('dd/MM/yyyy')
              .parse(birthdayController.text)
              .copyWith(hour: 7)
              .toUtc()
              .millisecondsSinceEpoch
              .toString(),
          fullName: fullNameController.text,
          gender: genderController.text == "MALE" ? "1" : "2",
          phoneNumber: phoneNumberController.text,
        ),
      );
      cancel();
      if (response.status == Status.success) {
        if (response.data['code'] == 1) {
          showNotification(response.data['message']);
          setState(() {
            enableNext = true;
          });
        }
      } else {
        showNotification(response.data['message'], status: Status.error);
      }
    }
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();

      RequestHelper _provider =
          RequestHelper(baseUrl: "https://tiemchungcovid19.gov.vn");

      final response = await _provider.get(
        "/api/vaccination/public/patient-vaccinated",
        params: syncVaccinePortalDataForm(
          birthday: DateFormat('dd/MM/yyyy')
              .parse(birthdayController.text)
              .copyWith(hour: 7)
              .toUtc()
              .millisecondsSinceEpoch
              .toString(),
          fullName: fullNameController.text,
          gender: genderController.text == "MALE" ? "1" : "2",
          phoneNumber: phoneNumberController.text,
          otpNumber: otpController.text,
        ),
      );
      cancel();
      if (response.status == Status.success) {
        if (response.data['errorResponse']['code'] == 1) {
          showNotification(null);
          VaccinationCertification vaccineCertification =
              VaccinationCertification.fromJson(response.data);
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => VaccinationCertificationScreen(
                      vaccineCertification: vaccineCertification)));
        }
      } else {
        showNotification(response.data['errorResponse']['description'],
            status: Status.error);
      }
    }
  }
}
