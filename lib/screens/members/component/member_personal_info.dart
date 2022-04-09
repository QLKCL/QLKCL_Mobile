import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MemberPersonalInfo extends StatefulWidget {
  final TabController? tabController;
  final CustomUser? personalData;
  final Permission mode;
  static String? userCode;
  final List<String>? infoFromIdentityCard;

  const MemberPersonalInfo(
      {Key? key,
      this.tabController,
      this.personalData,
      this.mode = Permission.edit,
      this.infoFromIdentityCard})
      : super(key: key);

  @override
  _MemberPersonalInfoState createState() => _MemberPersonalInfoState();
}

class _MemberPersonalInfoState extends State<MemberPersonalInfo>
    with AutomaticKeepAliveClientMixin<MemberPersonalInfo> {
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

  List<KeyValue> countryList = [];
  List<KeyValue> cityList = [];
  List<KeyValue> districtList = [];
  List<KeyValue> wardList = [];

  KeyValue? initCountry;
  KeyValue? initCity;
  KeyValue? initDistrict;
  KeyValue? initWard;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (widget.personalData != null) {
      codeController.text =
          widget.personalData?.code != null ? widget.personalData!.code : "";
      nationalityController.text = widget.personalData?.nationality != null
          ? widget.personalData!.nationality['code']
          : "";
      countryController.text = widget.personalData?.country != null
          ? widget.personalData!.country['code']
          : "VNM";
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

      initCountry = (widget.personalData?.country != null)
          ? KeyValue.fromJson(widget.personalData!.country)
          : null;
      initCity = (widget.personalData?.city != null)
          ? KeyValue.fromJson(widget.personalData!.city)
          : null;
      initDistrict = (widget.personalData?.district != null)
          ? KeyValue.fromJson(widget.personalData!.district)
          : null;
      initWard = (widget.personalData?.ward != null)
          ? KeyValue.fromJson(widget.personalData!.ward)
          : null;
    } else {
      nationalityController.text = "VNM";
      countryController.text = "VNM";
      genderController.text = "MALE";
    }
    super.initState();
    fetchCountry().then((value) {
      if (mounted) {
        setState(() {
          countryList = value;
        });
      }
    });
    fetchCity({'country_code': countryController.text}).then((value) {
      if (mounted) {
        setState(() {
          cityList = value;
        });
      }
    });
    fetchDistrict({'city_id': cityController.text}).then((value) {
      if (mounted) {
        setState(() {
          districtList = value;
        });
      }
    });
    fetchWard({'district_id': districtController.text}).then((value) {
      if (mounted) {
        setState(() {
          wardList = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.infoFromIdentityCard != null) {
      fullNameController.text = widget.infoFromIdentityCard![2];
      identityNumberController.text = widget.infoFromIdentityCard![0];
      genderController.text = genderList
          .safeFirstWhere(
              (gender) => gender.name == widget.infoFromIdentityCard![4])
          ?.id;
    }
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Input(
              label: 'Mã định danh',
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
              itemValue: countryList,
              selectedItem: countryList.isEmpty
                  ? initCountry
                  : countryList.safeFirstWhere(
                      (type) => type.id.toString() == countryController.text),
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: countryList.isEmpty
                  ? (String? filter) => fetchCountry()
                  : null,
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    countryController.text = "";
                  } else {
                    countryController.text = value.id;
                  }
                  cityController.clear();
                  districtController.clear();
                  wardController.clear();
                  cityList = [];
                  districtList = [];
                  wardList = [];
                  initCountry = null;
                  initCity = null;
                  initDistrict = null;
                  initWard = null;
                });
                fetchCity({'country_code': countryController.text})
                    .then((data) => setState(() {
                          cityList = data;
                        }));
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Quốc gia',
            ),
            DropdownInput<KeyValue>(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              itemValue: cityList,
              required: widget.mode == Permission.view ? false : true,
              selectedItem: cityList.isEmpty
                  ? initCity
                  : cityList.safeFirstWhere(
                      (type) => type.id.toString() == cityController.text),
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: cityList.isEmpty
                  ? (String? filter) =>
                      fetchCity({'country_code': countryController.text})
                  : null,
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    cityController.text = "";
                  } else {
                    cityController.text = value.id.toString();
                  }
                  districtController.clear();
                  wardController.clear();
                  districtList = [];
                  wardList = [];
                  initCity = null;
                  initDistrict = null;
                  initWard = null;
                });
                fetchDistrict({'city_id': cityController.text})
                    .then((data) => setState(() {
                          districtList = data;
                        }));
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Tỉnh/thành',
            ),
            DropdownInput<KeyValue>(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              itemValue: districtList,
              required: widget.mode == Permission.view ? false : true,
              selectedItem: districtList.isEmpty
                  ? initDistrict
                  : districtList.safeFirstWhere(
                      (type) => type.id.toString() == districtController.text),
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: districtList.isEmpty
                  ? (String? filter) =>
                      fetchDistrict({'city_id': cityController.text})
                  : null,
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    districtController.text = "";
                  } else {
                    districtController.text = value.id.toString();
                  }
                  wardController.clear();
                  wardList = [];
                  initDistrict = null;
                  initWard = null;
                });
                fetchWard({'district_id': districtController.text})
                    .then((data) => setState(() {
                          wardList = data;
                        }));
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Quận/huyện',
            ),
            DropdownInput<KeyValue>(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              itemValue: wardList,
              required: widget.mode == Permission.view ? false : true,
              selectedItem: wardList.isEmpty
                  ? initWard
                  : wardList.safeFirstWhere(
                      (type) => type.id.toString() == wardController.text),
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              onFind: wardList.isEmpty
                  ? (String? filter) =>
                      fetchWard({'district_id': districtController.text})
                  : null,
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    wardController.text = "";
                  } else {
                    wardController.text = value.id.toString();
                  }
                  initWard = null;
                });
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
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
              label: 'Số hộ chiếu',
              controller: passportNumberController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
              textCapitalization: TextCapitalization.characters,
              validatorFunction: passportValidator,
            ),
            if (widget.tabController != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: (widget.mode == Permission.add ||
                          widget.mode == Permission.edit)
                      ? const Text("Lưu")
                      : const Text('Tiếp theo'),
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
        CancelFunc cancel = showLoading();
        if (widget.mode == Permission.add) {
          var response = await createMember(createMemberDataForm(
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
          cancel();
          showNotification(response);
          if (response.status == Status.success) {
            widget.tabController!.animateTo(1);
          }
        }
        if (widget.mode == Permission.edit) {
          var response = await updateMember(updateMemberDataForm(
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
          cancel();
          showNotification(response);
        }
      }
    }
  }
}
