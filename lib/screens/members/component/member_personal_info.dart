import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class MemberPersonalInfo extends StatefulWidget {
  final TabController? tabController;
  final CustomUser? personalData;
  final Permission mode;
  const MemberPersonalInfo(
      {Key? key,
      this.tabController,
      this.personalData,
      this.mode = Permission.view})
      : super(key: key);

  @override
  _MemberPersonalInfoState createState() => _MemberPersonalInfoState();
}

class _MemberPersonalInfoState extends State<MemberPersonalInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  final _formKey = GlobalKey<FormState>();
  final nationalityController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final wardController = TextEditingController();
  final detailAddressController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();
  final identityNumberController = TextEditingController();
  final healthInsuranceNumberController = TextEditingController();
  final passportNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.personalData != null) {
      nationalityController.text = widget.personalData?.nationality ?? "";
      countryController.text = widget.personalData?.country ?? "";
      cityController.text = widget.personalData?.city ?? "";
      districtController.text = widget.personalData?.district ?? "";
      wardController.text = widget.personalData?.ward ?? "";
      detailAddressController.text = widget.personalData?.detailAddress ?? "";
      fullNameController.text = widget.personalData?.fullName ?? "";
      emailController.text = widget.personalData?.email ?? "";
      phoneNumberController.text = widget.personalData!.phoneNumber;
      birthdayController.text = widget.personalData?.birthday ?? "";
      genderController.text = widget.personalData?.gender ?? "";
      identityNumberController.text = widget.personalData?.identityNumber ?? "";
      healthInsuranceNumberController.text =
          widget.personalData?.healthInsuranceNumber ?? "";
      passportNumberController.text = widget.personalData?.passportNumber ?? "";
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Input(
              label: 'Mã số',
              enabled: false,
              initValue: widget.personalData?.code.toString(),
            ),
            Input(
              label: 'Họ và tên',
              required: widget.mode == Permission.view ? false : true,
              textCapitalization: TextCapitalization.words,
              controller: fullNameController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Số điện thoại',
              required: widget.mode == Permission.view ? false : true,
              type: TextInputType.phone,
              controller: phoneNumberController,
              enabled: widget.mode == Permission.add ? true : false,
              validatorFunction: phoneValidator,
            ),
            Input(
              label: 'Email',
              type: TextInputType.emailAddress,
              controller: emailController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              validatorFunction: emailValidator,
            ),
            Input(
              label: 'Số CMND/CCCD',
              required: widget.mode == Permission.view ? false : true,
              type: TextInputType.number,
              controller: identityNumberController,
              enabled: widget.mode == Permission.add ? true : false,
            ),
            DropdownInput(
              label: 'Quốc tịch',
              hint: 'Quốc tịch',
              required: widget.mode == Permission.view ? false : true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
              selectedItem: nationalityController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput<KeyValue>(
              label: 'Giới tính',
              hint: 'Chọn giới tính',
              required: widget.mode == Permission.view ? false : true,
              itemValue: genderList,
              itemAsString: (KeyValue? u) => u!.name,
              maxHeight: 112,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: genderList.safeFirstWhere(
                  (gender) => gender.id == genderController.text),
              onChanged: (value) {
                genderController.text = value!.id;
              },
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DateInput(
              label: 'Ngày sinh',
              required: widget.mode == Permission.view ? false : true,
              controller: birthdayController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            ),
            DropdownInput(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: widget.mode == Permission.view ? false : true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
              selectedItem: countryController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: widget.mode == Permission.view ? false : true,
              itemValue: ['TP. Hồ Chí Minh', 'Đà Nẵng', 'Hà Nội', 'Bình Dương'],
              selectedItem: cityController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: widget.mode == Permission.view ? false : true,
              itemValue: ['Gò Vấp', 'Quận 1', 'Quận 2', 'Quận 3'],
              selectedItem: districtController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: widget.mode == Permission.view ? false : true,
              itemValue: ['1', '2', '3', '4'],
              selectedItem: wardController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Số nhà, Đường, Thôn/Xóm/Ấp',
              required: widget.mode == Permission.view ? false : true,
              controller: detailAddressController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Mã số BHXH/Thẻ BHYT',
              controller: healthInsuranceNumberController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Số Hộ chiếu',
              controller: passportNumberController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            if (widget.tabController != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    _submit();
                    // widget.tabController!.animateTo(1);
                  },
                  child: (widget.mode == Permission.add ||
                          widget.mode == Permission.edit)
                      ? Text("Lưu và tiếp tục")
                      : Text('Tiếp theo'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      // final registerResponse = await register(loginDataForm(
      //   phoneNumberController.text,
      //   phoneNumberController.text,
      // ));
      // if (registerResponse.success) {
      await Future.delayed(const Duration(milliseconds: 3000));
      EasyLoading.dismiss();
      // } else {
      //   EasyLoading.dismiss();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(registerResponse.message)),
      // );
      // }
    }
  }
}
