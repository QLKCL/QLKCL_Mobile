import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';

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
            ),
            Input(
              label: 'Email',
              type: TextInputType.emailAddress,
              controller: emailController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
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
                    widget.tabController!.animateTo(1);
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
}
