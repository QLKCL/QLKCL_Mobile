import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/theme/app_theme.dart';

class MemberPersonalInfo extends StatefulWidget {
  final TabController? tabController;
  final CustomUser? personalData;
  final String mode;
  const MemberPersonalInfo(
      {Key? key, this.tabController, this.personalData, this.mode = "detail"})
      : super(key: key);

  @override
  _MemberPersonalInfoState createState() => _MemberPersonalInfoState();
}

class _MemberPersonalInfoState extends State<MemberPersonalInfo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nationalityController =
        TextEditingController(text: widget.personalData?.nationality);
    final countryController =
        TextEditingController(text: widget.personalData?.country);
    final cityController =
        TextEditingController(text: widget.personalData?.city);
    final districtController =
        TextEditingController(text: widget.personalData?.district);
    final wardController =
        TextEditingController(text: widget.personalData?.ward);
    final detailAddressController =
        TextEditingController(text: widget.personalData?.detailAddress);
    final fullNameController =
        TextEditingController(text: widget.personalData?.fullName);
    final emailController =
        TextEditingController(text: widget.personalData?.email);
    final phoneNumberController =
        TextEditingController(text: widget.personalData?.phoneNumber);
    final birthdayController =
        TextEditingController(text: widget.personalData?.birthday);
    final genderController =
        TextEditingController(text: widget.personalData?.gender);
    final identityNumberController =
        TextEditingController(text: widget.personalData?.identityNumber);
    final healthInsuranceNumberController =
        TextEditingController(text: widget.personalData?.healthInsuranceNumber);
    final passportNumberController =
        TextEditingController(text: widget.personalData?.passportNumber);

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
              required: widget.mode == "detail" ? false : true,
              textCapitalization: TextCapitalization.words,
              controller: fullNameController,
            ),
            Input(
              label: 'Số điện thoại',
              required: widget.mode == "detail" ? false : true,
              type: TextInputType.phone,
              controller: phoneNumberController,
            ),
            Input(
              label: 'Email',
              type: TextInputType.emailAddress,
              controller: emailController,
            ),
            Input(
              label: 'Số CMND/CCCD',
              required: widget.mode == "detail" ? false : true,
              type: TextInputType.number,
              controller: identityNumberController,
            ),
            DropdownInput(
              label: 'Quốc tịch',
              hint: 'Quốc tịch',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
              selectedItem: nationalityController.text,
            ),
            DropdownInput(
              label: 'Giới tính',
              hint: 'Chọn giới tính',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['Nam', 'Nữ'],
              maxHeight: 112,
              selectedItem: genderController.text,
            ),
            DateInput(
              label: 'Ngày sinh',
              required: widget.mode == "detail" ? false : true,
              controller: birthdayController,
            ),
            DropdownInput(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
              selectedItem: countryController.text,
            ),
            DropdownInput(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['TP. Hồ Chí Minh', 'Đà Nẵng', 'Hà Nội', 'Bình Dương'],
              selectedItem: cityController.text,
            ),
            DropdownInput(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['Gò Vấp', 'Quận 1', 'Quận 2', 'Quận 3'],
              selectedItem: districtController.text,
            ),
            DropdownInput(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: widget.mode == "detail" ? false : true,
              itemValue: ['1', '2', '3', '4'],
              selectedItem: wardController.text,
            ),
            Input(
              label: 'Số nhà, Đường, Thôn/Xóm/Ấp',
              required: widget.mode == "detail" ? false : true,
              controller: detailAddressController,
            ),
            Input(
              label: 'Mã số BHXH/Thẻ BHYT',
              controller: healthInsuranceNumberController,
            ),
            Input(
              label: 'Số Hộ chiếu',
              controller: passportNumberController,
            ),
            if (widget.tabController != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    widget.tabController!.animateTo(1);
                  },
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: CustomColors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
