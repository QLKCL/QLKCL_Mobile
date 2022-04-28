import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/members/component/member_shared_data.dart';
import 'package:qlkcl/utils/api.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MemberPersonalInfo extends StatefulWidget {
  final TabController? tabController;
  final CustomUser? personalData;
  final Permission mode;
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

  final cityKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final districtKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final wardKey = GlobalKey<DropdownSearchState<KeyValue>>();

  late MemberSharedDataState state;

  List<KeyValue> countryList = [];
  List<KeyValue> cityList = [];
  List<KeyValue> districtList = [];
  List<KeyValue> wardList = [];

  KeyValue? initCountry;
  KeyValue? initCity;
  KeyValue? initDistrict;
  KeyValue? initWard;

  List<KeyValue> professionalList = [];
  KeyValue? initProfessional;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = MemberSharedData.of(context);
    if (widget.personalData != null) {
      state.codeController.text =
          widget.personalData?.code != null ? widget.personalData!.code : "";
      state.nationalityController.text =
          widget.personalData?.nationality != null
              ? widget.personalData!.nationality['code']
              : "";
      state.countryController.text = widget.personalData?.country != null
          ? widget.personalData!.country['code']
          : "VNM";
      state.cityController.text = widget.personalData?.city != null
          ? widget.personalData!.city['id'].toString()
          : "";
      state.districtController.text = widget.personalData?.district != null
          ? widget.personalData!.district['id'].toString()
          : "";
      state.wardController.text = widget.personalData?.ward != null
          ? widget.personalData!.ward['id'].toString()
          : "";
      state.detailAddressController.text =
          widget.personalData?.detailAddress ?? "";
      state.fullNameController.text = widget.personalData?.fullName ?? "";
      state.emailController.text = widget.personalData?.email ?? "";
      state.phoneNumberController.text = widget.personalData!.phoneNumber;
      state.birthdayController.text = widget.personalData?.birthday != null
          ? DateFormat('dd/MM/yyyy')
              .parse(widget.personalData?.birthday)
              .toIso8601String()
          : "";
      state.genderController.text = widget.personalData?.gender ?? "";
      state.identityNumberController.text =
          widget.personalData?.identityNumber ?? "";
      state.healthInsuranceNumberController.text =
          widget.personalData?.healthInsuranceNumber ?? "";
      state.passportNumberController.text =
          widget.personalData?.passportNumber ?? "";
      state.professionalController.text =
          widget.personalData?.professional != null
              ? widget.personalData!.professional['code'].toString()
              : "";
      state.statusController.text = widget.personalData?.status ?? "AVAILABLE";

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
      initProfessional = (widget.personalData?.professional != null)
          ? KeyValue.fromJson(widget.personalData!.professional)
          : null;
    }
    fetchCountry().then((value) {
      if (mounted) {
        setState(() {
          countryList = value;
        });
      }
    });
    if (state.countryController.text != "") {
      fetchCity({'country_code': state.countryController.text}).then((value) {
        if (mounted) {
          setState(() {
            cityList = value;
          });
        }
      });
    }
    if (state.cityController.text != "") {
      fetchDistrict({'city_id': state.cityController.text}).then((value) {
        if (mounted) {
          setState(() {
            districtList = value;
          });
        }
      });
    }
    if (state.districtController.text != "") {
      fetchWard({'district_id': state.districtController.text}).then((value) {
        if (mounted) {
          setState(() {
            wardList = value;
          });
        }
      });
    }
    fetchProfessional().then((value) {
      if (mounted) {
        setState(() {
          professionalList = value;
        });
      }
    });
  }

  Future<List<KeyValue>> fetchProfessional() async {
    final ApiHelper api = ApiHelper();
    final response = await api.postHTTP(Api.filterProfessional, null);
    return response != null && response['data'] != null
        ? KeyValue.fromJsonList(response['data'])
        : [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.infoFromIdentityCard != null) {
      state.fullNameController.text = widget.infoFromIdentityCard![2];
      state.identityNumberController.text = widget.infoFromIdentityCard![0];
      state.genderController.text = genderList
          .safeFirstWhere(
              (gender) => gender.name == widget.infoFromIdentityCard![4])
          ?.id;
    }
    return SingleChildScrollView(
      controller: ScrollController(),
      primary: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Input(
                  label: 'Mã định danh',
                  enabled: false,
                  controller: state.codeController,
                ),
                Input(
                  label: 'Họ và tên',
                  required: widget.mode != Permission.view,
                  textCapitalization: TextCapitalization.words,
                  controller: state.fullNameController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Số điện thoại',
                  required: widget.mode != Permission.view,
                  type: TextInputType.phone,
                  controller: state.phoneNumberController,
                  enabled: widget.mode == Permission.add,
                  validatorFunction: phoneValidator,
                ),
                Input(
                  label: 'Email',
                  type: TextInputType.emailAddress,
                  controller: state.emailController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  validatorFunction: emailValidator,
                ),
                Input(
                  label: 'Số CMND/CCCD',
                  required: widget.mode != Permission.view,
                  type: TextInputType.number,
                  controller: state.identityNumberController,
                  enabled: widget.mode == Permission.add ||
                      (widget.mode == Permission.edit &&
                          state.identityNumberController.text == ""),
                  validatorFunction: identityValidator,
                ),
                DropdownInput<KeyValue>(
                  label: 'Quốc tịch',
                  hint: 'Quốc tịch',
                  required: widget.mode != Permission.view,
                  itemValue: nationalityList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 66,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: (widget.personalData?.nationality != null)
                      ? KeyValue.fromJson(widget.personalData!.nationality)
                      : const KeyValue(id: "VNM", name: 'Việt Nam'),
                  onChanged: (value) {
                    if (value == null) {
                      state.nationalityController.text = "";
                    } else {
                      state.nationalityController.text = value.id.toString();
                    }
                  },
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                DropdownInput<KeyValue>(
                  label: 'Giới tính',
                  hint: 'Chọn giới tính',
                  required: widget.mode != Permission.view,
                  itemValue: genderList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 112,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: genderList.safeFirstWhere(
                      (gender) => gender.id == state.genderController.text),
                  onChanged: (value) {
                    if (value == null) {
                      state.genderController.text = "";
                    } else {
                      state.genderController.text = value.id;
                    }
                  },
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                NewDateInput(
                  label: 'Ngày sinh',
                  required: widget.mode != Permission.view,
                  controller: state.birthdayController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  maxDate: DateTime.now(),
                ),
                DropdownInput<KeyValue>(
                  label: 'Quốc gia',
                  hint: 'Quốc gia',
                  required: widget.mode != Permission.view,
                  itemValue: countryList,
                  selectedItem: countryList.isEmpty
                      ? initCountry
                      : countryList.safeFirstWhere((type) =>
                          type.id.toString() == state.countryController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: countryList.isEmpty
                      ? (String? filter) => fetchCountry()
                      : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        state.countryController.text = "";
                      } else {
                        state.countryController.text = value.id;
                      }
                      state.cityController.clear();
                      state.districtController.clear();
                      state.wardController.clear();
                      cityList = [];
                      districtList = [];
                      wardList = [];
                      initCountry = null;
                      initCity = null;
                      initDistrict = null;
                      initWard = null;
                    });
                    if (state.countryController.text != "") {
                      fetchCity({'country_code': state.countryController.text})
                          .then((data) => setState(() {
                                cityList = data;
                                cityKey.currentState?.openDropDownSearch();
                              }));
                    }
                  },
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
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
                  widgetKey: cityKey,
                  label: 'Tỉnh/thành',
                  hint: 'Tỉnh/thành',
                  itemValue: cityList,
                  required: widget.mode != Permission.view,
                  selectedItem: cityList.isEmpty
                      ? initCity
                      : cityList.safeFirstWhere((type) =>
                          type.id.toString() == state.cityController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: cityList.isEmpty && state.countryController.text != ""
                      ? (String? filter) => fetchCity({
                            'country_code': state.countryController.text,
                            'search': filter
                          })
                      : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        state.cityController.text = "";
                      } else {
                        state.cityController.text = value.id.toString();
                      }
                      state.districtController.clear();
                      state.wardController.clear();
                      districtList = [];
                      wardList = [];
                      initCity = null;
                      initDistrict = null;
                      initWard = null;
                    });
                    if (state.cityController.text != "") {
                      fetchDistrict({'city_id': state.cityController.text})
                          .then((data) => setState(() {
                                districtList = data;
                                districtKey.currentState?.openDropDownSearch();
                              }));
                    }
                  },
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
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
                  widgetKey: districtKey,
                  label: 'Quận/huyện',
                  hint: 'Quận/huyện',
                  itemValue: districtList,
                  required: widget.mode != Permission.view,
                  selectedItem: districtList.isEmpty
                      ? initDistrict
                      : districtList.safeFirstWhere((type) =>
                          type.id.toString() == state.districtController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind:
                      districtList.isEmpty && state.cityController.text != ""
                          ? (String? filter) => fetchDistrict({
                                'city_id': state.cityController.text,
                                'search': filter,
                              })
                          : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        state.districtController.text = "";
                      } else {
                        state.districtController.text = value.id.toString();
                      }
                      state.wardController.clear();
                      wardList = [];
                      initDistrict = null;
                      initWard = null;
                    });
                    if (state.districtController.text != "") {
                      fetchWard({'district_id': state.districtController.text})
                          .then((data) => setState(() {
                                wardList = data;
                                wardKey.currentState?.openDropDownSearch();
                              }));
                    }
                  },
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
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
                  widgetKey: wardKey,
                  label: 'Phường/xã',
                  hint: 'Phường/xã',
                  itemValue: wardList,
                  required: widget.mode != Permission.view,
                  selectedItem: wardList.isEmpty
                      ? initWard
                      : wardList.safeFirstWhere((type) =>
                          type.id.toString() == state.wardController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind:
                      wardList.isEmpty && state.districtController.text != ""
                          ? (String? filter) => fetchWard({
                                'district_id': state.districtController.text,
                                'search': filter,
                              })
                          : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        state.wardController.text = "";
                      } else {
                        state.wardController.text = value.id.toString();
                      }
                      initWard = null;
                    });
                  },
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
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
                  required: widget.mode != Permission.view,
                  controller: state.detailAddressController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Mã số BHXH/Thẻ BHYT',
                  controller: state.healthInsuranceNumberController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Số hộ chiếu',
                  controller: state.passportNumberController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  textCapitalization: TextCapitalization.characters,
                  validatorFunction: passportValidator,
                ),
                DropdownInput<KeyValue>(
                  widgetKey: cityKey,
                  label: 'Nghề nghiệp',
                  hint: 'Nghề nghiệp',
                  itemValue: professionalList,
                  selectedItem: professionalList.isEmpty
                      ? initProfessional
                      : professionalList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          state.professionalController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: professionalList.isEmpty &&
                          state.professionalController.text != ""
                      ? (String? filter) => fetchProfessional()
                      : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        state.professionalController.text = "";
                      } else {
                        state.professionalController.text = value.id.toString();
                      }
                    });
                  },
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
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
                  popupTitle: 'Nghề nghiệp',
                ),
                if (widget.tabController != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: widget.mode == Permission.edit
                          ? const Text('Lưu')
                          : const Text('Tiếp theo'),
                    ),
                  ),
              ],
            ),
          ),
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
        if (widget.mode == Permission.add) {
          widget.tabController!.animateTo(1);
        }
        if (widget.mode == Permission.edit) {
          final CancelFunc cancel = showLoading();
          final response = await updateMember(updateMemberDataForm(
            code: widget.personalData!.code,
            fullName: state.fullNameController.text,
            email: state.emailController.text,
            birthday: DateFormat("dd/MM/yyyy")
                .format(DateTime.parse(state.birthdayController.text)),
            gender: state.genderController.text,
            nationality: "VNM",
            country: state.countryController.text,
            city: state.cityController.text,
            district: state.districtController.text,
            ward: state.wardController.text,
            address: state.detailAddressController.text,
            healthInsurance: state.healthInsuranceNumberController.text,
            identity: state.identityNumberController.text,
            passport: state.passportNumberController.text,
            professional: state.professionalController.text,
          ));
          cancel();
          showNotification(response);
        }
      }
    }
  }
}
