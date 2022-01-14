import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';

class MemberPersonalInfo extends StatefulWidget {
  final TabController? tabController;
  final CustomUser? personalData;
  final Permission mode;
  static var userCode;
  const MemberPersonalInfo(
      {Key? key,
      this.tabController,
      this.personalData,
      this.mode = Permission.edit})
      : super(key: key);

  @override
  _MemberPersonalInfoState createState() => _MemberPersonalInfoState();
}

class _MemberPersonalInfoState extends State<MemberPersonalInfo>
    with AutomaticKeepAliveClientMixin<MemberPersonalInfo> {
  @override
  bool get wantKeepAlive => true;

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
  final codeController = TextEditingController();
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
    super.build(context);
    if (widget.personalData != null) {
      codeController.text =
          widget.personalData?.code != null ? widget.personalData!.code : "";
      nationalityController.text = widget.personalData?.nationality != null
          ? widget.personalData!.nationality['code']
          : "";
      countryController.text = widget.personalData?.country != null
          ? widget.personalData!.country['code']
          : "";
      cityController.text = widget.personalData?.city != null
          ? widget.personalData!.city['id'].toString()
          : "";
      districtController.text = widget.personalData?.district != null
          ? widget.personalData!.district['id'].toString()
          : "";
      wardController.text = widget.personalData?.ward != null
          ? widget.personalData!.ward['id'].toString()
          : "";
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
    } else {
      nationalityController.text = "VNM";
      countryController.text = "VNM";
      genderController.text = "MALE";
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Input(
              label: 'Mã số',
              enabled: false,
              controller: codeController,
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
              enabled: (widget.mode == Permission.add ||
                      (widget.mode == Permission.edit &&
                          identityNumberController.text == ""))
                  ? true
                  : false,
              validatorFunction: identityValidator,
            ),
            DropdownInput<KeyValue>(
              label: 'Quốc tịch',
              hint: 'Quốc tịch',
              required: widget.mode == Permission.view ? false : true,
              itemValue: nationalityList,
              itemAsString: (KeyValue? u) => u!.name,
              maxHeight: 66,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: (widget.personalData?.nationality != null)
                  ? KeyValue.fromJson(widget.personalData!.nationality)
                  : KeyValue(id: 1, name: 'Việt Nam'),
              onChanged: (value) {
                if (value == null) {
                  nationalityController.text = "";
                } else {
                  nationalityController.text = value.id.toString();
                }
              },
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
                if (value == null) {
                  genderController.text = "";
                } else {
                  genderController.text = value.id;
                }
              },
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            NewDateInput(
              label: 'Ngày sinh',
              required: widget.mode == Permission.view ? false : true,
              controller: birthdayController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            ),
            DropdownInput<KeyValue>(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: widget.mode == Permission.view ? false : true,
              selectedItem: (widget.personalData?.country != null)
                  ? KeyValue.fromJson(widget.personalData!.country)
                  : KeyValue(id: 1, name: 'Việt Nam'),
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: (String? filter) => fetchCountry(),
              onChanged: (value) {
                if (value == null) {
                  countryController.text = "";
                } else {
                  countryController.text = value.id;
                }
              },
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Quốc gia',
            ),
            DropdownInput<KeyValue>(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: widget.mode == Permission.view ? false : true,
              selectedItem: (widget.personalData?.city != null)
                  ? KeyValue.fromJson(widget.personalData!.city)
                  : null,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: (String? filter) => fetchCity({'country_code': 'VNM'}),
              onChanged: (value) {
                if (value == null) {
                  cityController.text = "";
                } else {
                  cityController.text = value.id.toString();
                }
              },
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Tỉnh/thành',
            ),
            DropdownInput<KeyValue>(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: widget.mode == Permission.view ? false : true,
              selectedItem: (widget.personalData?.district != null)
                  ? KeyValue.fromJson(widget.personalData!.district)
                  : null,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: (String? filter) =>
                  fetchDistrict({'city_id': cityController.text}),
              onChanged: (value) {
                if (value == null) {
                  districtController.text = "";
                } else {
                  districtController.text = value.id.toString();
                }
              },
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Quận/huyện',
            ),
            DropdownInput<KeyValue>(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: widget.mode == Permission.view ? false : true,
              selectedItem: (widget.personalData?.ward != null)
                  ? KeyValue.fromJson(widget.personalData!.ward)
                  : null,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: (String? filter) =>
                  fetchWard({'district_id': districtController.text}),
              onChanged: (value) {
                if (value == null) {
                  wardController.text = "";
                } else {
                  wardController.text = value.id.toString();
                }
              },
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Phường/xã',
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
                  },
                  child: (widget.mode == Permission.add ||
                          widget.mode == Permission.edit)
                      ? Text("Lưu")
                      : Text('Tiếp theo'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (widget.mode == Permission.view) {
      widget.tabController!.animateTo(1);
    } else {
      // Validate returns true if the form is valid, or false otherwise.
      if (_formKey.currentState!.validate()) {
        EasyLoading.show();
        if (widget.mode == Permission.add) {
          final registerResponse = await createMember(createMemberDataForm(
            phoneNumber: phoneNumberController.text,
            fullName: fullNameController.text,
            email: emailController.text,
            birthday: birthdayController.text,
            gender: genderController.text,
            nationality: "VNM",
            country: countryController.text,
            city: cityController.text,
            district: districtController.text,
            ward: wardController.text,
            address: detailAddressController.text,
            healthInsurance: healthInsuranceNumberController.text,
            identity: identityNumberController.text,
            passport: passportNumberController.text,
            quarantineWard: (await getQuarantineWard()).toString(),
          ));
          if (registerResponse.success) {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(registerResponse.message)),
            );
            widget.tabController!.animateTo(1);
          } else {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(registerResponse.message)),
            );
          }
        }
        if (widget.mode == Permission.edit) {
          final registerResponse = await updateMember(updateMemberDataForm(
            code: widget.personalData!.code,
            fullName: fullNameController.text,
            email: emailController.text,
            birthday: birthdayController.text,
            gender: genderController.text,
            nationality: "VNM",
            country: countryController.text,
            city: cityController.text,
            district: districtController.text,
            ward: wardController.text,
            address: detailAddressController.text,
            healthInsurance: healthInsuranceNumberController.text,
            identity: identityNumberController.text,
            passport: passportNumberController.text,
          ));
          if (registerResponse.success) {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(registerResponse.message)),
            );
          } else {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(registerResponse.message)),
            );
          }
        }
      }
    }
  }
}
