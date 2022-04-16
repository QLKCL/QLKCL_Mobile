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
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ManagerForm extends StatefulWidget {
  final CustomUser? personalData;
  final Permission mode;
  final List<String>? infoFromIdentityCard;
  final KeyValue? quarantineWard;
  final KeyValue? quarantineBuilding;
  final List<KeyValue>? quarantineFloor;
  final dynamic staffData;
  final String? type;

  const ManagerForm({
    Key? key,
    this.personalData,
    this.mode = Permission.edit,
    this.infoFromIdentityCard,
    this.quarantineWard,
    this.quarantineBuilding,
    this.quarantineFloor,
    this.staffData,
    this.type,
  }) : super(key: key);

  @override
  _ManagerFormState createState() => _ManagerFormState();
}

class _ManagerFormState extends State<ManagerForm> {
  final _formKey = GlobalKey<FormState>();

  final buildingKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final floorKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final cityKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final districtKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final wardKey = GlobalKey<DropdownSearchState<KeyValue>>();

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

  final quarantineFloorController = TextEditingController();
  final quarantineBuildingController = TextEditingController();
  final quarantineWardController = TextEditingController();

  List<KeyValue> countryList = [];
  List<KeyValue> cityList = [];
  List<KeyValue> districtList = [];
  List<KeyValue> wardList = [];

  KeyValue? initCountry;
  KeyValue? initCity;
  KeyValue? initDistrict;
  KeyValue? initWard;

  List<KeyValue> quarantineWardList = [];
  List<KeyValue> quarantineBuildingList = [];
  List<KeyValue> quarantineFloorList = [];

  KeyValue? initQuarantineWard;
  List<KeyValue> initQuarantineBuilding = [];
  List<KeyValue> initQuarantineFloor = [];

  late String type;

  @override
  void initState() {
    super.initState();
    type = widget.type ?? "manager";
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

      quarantineWardController.text =
          widget.personalData?.quarantineWard != null
              ? "${widget.personalData!.quarantineWard?.id}"
              : "";
      initQuarantineWard = widget.personalData?.quarantineWard;

      if (widget.staffData != null) {
        type = "staff";
        widget.staffData['care_area'].forEach((e) {
          if (!initQuarantineBuilding
              .contains(KeyValue.fromJson(e['quarantine_building']))) {
            initQuarantineBuilding
                .add(KeyValue.fromJson(e['quarantine_building']));
          }
          if (!initQuarantineFloor
              .contains(KeyValue.fromJson(e['quarantine_floor']))) {
            initQuarantineFloor.add(KeyValue.fromJson(e['quarantine_floor']));
          }
        });
        quarantineBuildingController.text =
            initQuarantineBuilding.map((e) => e.id).join(',');
      }
    } else {
      nationalityController.text = "VNM";
      countryController.text = "VNM";
      genderController.text = "MALE";

      quarantineFloorController.text = widget.quarantineFloor != null
          ? widget.quarantineFloor!.map((e) => e.id).join(',')
          : "";
      quarantineBuildingController.text = widget.quarantineBuilding != null
          ? widget.quarantineBuilding!.id.toString()
          : "";
      if (widget.quarantineWard != null) {
        quarantineWardController.text = widget.quarantineWard!.id.toString();
      } else {
        getQuarantineWard().then((val) {
          setState(() {
            quarantineWardController.text = "$val";
          });
        });
      }
    }
    fetchCountry().then((value) {
      if (mounted) {
        setState(() {
          countryList = value;
        });
      }
    });
    if (countryController.text != "") {
      fetchCity({'country_code': countryController.text}).then((value) {
        if (mounted) {
          setState(() {
            cityList = value;
          });
        }
      });
    }
    if (cityController.text != "") {
      fetchDistrict({'city_id': cityController.text}).then((value) {
        if (mounted) {
          setState(() {
            districtList = value;
          });
        }
      });
    }
    if (districtController.text != "") {
      fetchWard({'district_id': districtController.text}).then((value) {
        if (mounted) {
          setState(() {
            wardList = value;
          });
        }
      });
    }
    fetchQuarantineWard({
      'page_size': pageSizeMax,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineWardList = value;
        });
      }
    });
    if (quarantineWardController.text != "") {
      fetchQuarantineBuilding({
        'quarantine_ward': quarantineWardController.text,
        'page_size': pageSizeMax,
      }).then((value) {
        if (mounted) {
          setState(() {
            quarantineBuildingList = value;
          });
        }
      });
    }
    if (quarantineBuildingController.text != "") {
      fetchCustomQuarantineFloor({
        'quarantine_building_id_list': quarantineBuildingController.text,
        'page_size': pageSizeMax,
      }).then((value) {
        if (mounted) {
          setState(() {
            quarantineFloorList = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.infoFromIdentityCard != null) {
      fullNameController.text = widget.infoFromIdentityCard![2];
      identityNumberController.text = widget.infoFromIdentityCard![0];
      genderController.text = genderList
          .safeFirstWhere(
              (gender) => gender.name == widget.infoFromIdentityCard![4])
          ?.id;
    }
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: <Widget>[
                      Radio<String>(
                        value: "manager",
                        groupValue: type,
                        onChanged: (value) {
                          if (widget.mode == Permission.add) {
                            setState(() {
                              type = value!;
                            });
                          }
                        },
                      ),
                      const Text(
                        'Quản lý',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Radio<String>(
                        value: "staff",
                        groupValue: type,
                        onChanged: (value) {
                          if (widget.mode == Permission.add) {
                            setState(() {
                              type = value!;
                            });
                          }
                        },
                      ),
                      const Text(
                        'Cán bộ',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Input(
                  label: 'Mã định danh',
                  enabled: false,
                  controller: codeController,
                ),
                DropdownInput<KeyValue>(
                  label: 'Khu cách ly',
                  hint: 'Chọn khu cách ly',
                  required: widget.mode != Permission.view,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineWardList.isEmpty
                      ? (String? filter) => fetchQuarantineWard({
                            'page_size': pageSizeMax,
                            'search': filter,
                          })
                      : null,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemValue: quarantineWardList,
                  selectedItem: widget.quarantineWard ??
                      (initQuarantineWard ??
                          quarantineWardList.safeFirstWhere((type) =>
                              type.id.toString() ==
                              quarantineWardController.text)),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        quarantineWardController.text = "";
                      } else {
                        quarantineWardController.text = value.id.toString();
                      }
                      quarantineBuildingController.clear();
                      quarantineFloorController.clear();
                      quarantineBuildingList = [];
                      quarantineFloorList = [];
                      initQuarantineWard = null;
                      initQuarantineBuilding = [];
                      initQuarantineFloor = [];
                    });
                    if (quarantineWardController.text != "") {
                      fetchQuarantineBuilding({
                        'quarantine_ward': quarantineWardController.text,
                        'page_size': pageSizeMax,
                      }).then((data) => setState(() {
                            quarantineBuildingList = data;
                            buildingKey.currentState?.openDropDownSearch();
                          }));
                    }
                  },
                  enabled: widget.mode == Permission.add,
                  showSearchBox: true,
                  mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                      ? Mode.DIALOG
                      : Mode.BOTTOM_SHEET,
                  maxHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      100,
                  popupTitle: 'Khu cách ly',
                ),
                Input(
                  label: 'Họ và tên',
                  required: widget.mode != Permission.view,
                  textCapitalization: TextCapitalization.words,
                  controller: fullNameController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Số điện thoại',
                  required: widget.mode != Permission.view,
                  type: TextInputType.phone,
                  controller: phoneNumberController,
                  enabled: widget.mode == Permission.add,
                  validatorFunction: phoneValidator,
                ),
                Input(
                  label: 'Email',
                  type: TextInputType.emailAddress,
                  controller: emailController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  validatorFunction: emailValidator,
                ),
                Input(
                  label: 'Số CMND/CCCD',
                  required: widget.mode != Permission.view,
                  type: TextInputType.number,
                  controller: identityNumberController,
                  enabled: widget.mode == Permission.add ||
                      (widget.mode == Permission.edit &&
                          identityNumberController.text == ""),
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
                      nationalityController.text = "";
                    } else {
                      nationalityController.text = value.id.toString();
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
                      (gender) => gender.id == genderController.text),
                  onChanged: (value) {
                    if (value == null) {
                      genderController.text = "";
                    } else {
                      genderController.text = value.id;
                    }
                  },
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                NewDateInput(
                  label: 'Ngày sinh',
                  required: widget.mode != Permission.view,
                  controller: birthdayController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                ),
                DropdownInput<KeyValue>(
                  label: 'Quốc gia',
                  hint: 'Quốc gia',
                  required: widget.mode != Permission.view,
                  itemValue: countryList,
                  selectedItem: countryList.isEmpty
                      ? initCountry
                      : countryList.safeFirstWhere((type) =>
                          type.id.toString() == countryController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
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
                    if (countryController.text != "") {
                      fetchCity({'country_code': countryController.text})
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
                      : cityList.safeFirstWhere(
                          (type) => type.id.toString() == cityController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: cityList.isEmpty && countryController.text != ""
                      ? (String? filter) => fetchCity({
                            'country_code': countryController.text,
                            'search': filter,
                          })
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
                    if (cityController.text != "") {
                      fetchDistrict({'city_id': cityController.text})
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
                          type.id.toString() == districtController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: districtList.isEmpty && cityController.text != ""
                      ? (String? filter) => fetchDistrict({
                            'city_id': cityController.text,
                            'search': filter,
                          })
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
                    if (districtController.text != "") {
                      fetchWard({'district_id': districtController.text})
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
                      : wardList.safeFirstWhere(
                          (type) => type.id.toString() == wardController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: wardList.isEmpty && districtController.text != ""
                      ? (String? filter) => fetchWard({
                            'district_id': districtController.text,
                            'search': filter,
                          })
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
                  controller: detailAddressController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Mã số BHXH/Thẻ BHYT',
                  controller: healthInsuranceNumberController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                Input(
                  label: 'Số hộ chiếu',
                  controller: passportNumberController,
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  textCapitalization: TextCapitalization.characters,
                  validatorFunction: passportValidator,
                ),
                if (type == "staff")
                  MultiDropdownInput<KeyValue>(
                    widgetKey: buildingKey,
                    label: 'Tòa',
                    hint: 'Chọn tòa',
                    required: widget.mode != Permission.view,
                    dropdownBuilder: customDropDown,
                    itemAsString: (KeyValue? u) => u!.name,
                    onFind: quarantineBuildingList.isEmpty &&
                            quarantineWardController.text != ""
                        ? (String? filter) => fetchQuarantineBuilding({
                              'quarantine_ward': quarantineWardController.text,
                              'page_size': pageSizeMax,
                              'search': filter,
                            })
                        : null,
                    compareFn: (item, selectedItem) =>
                        item?.id == selectedItem?.id,
                    itemValue: quarantineBuildingList,
                    selectedItems: widget.quarantineBuilding != null
                        ? [widget.quarantineBuilding!]
                        : initQuarantineBuilding.isNotEmpty
                            ? initQuarantineBuilding
                            : (quarantineBuildingController.text != ""
                                ? (quarantineBuildingList.isNotEmpty
                                    ? quarantineBuildingController.text
                                        .split(',')
                                        .map((e) => quarantineBuildingList
                                            .safeFirstWhere((result) =>
                                                result.id.toString() == e)!)
                                        .toList()
                                    : null)
                                : null),
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          quarantineBuildingController.text = "";
                        } else {
                          quarantineBuildingController.text =
                              value.map((e) => e.id).join(",");
                        }
                        quarantineFloorController.clear();
                        quarantineFloorList = [];
                        initQuarantineBuilding = [];
                        initQuarantineFloor = [];
                      });
                      if (quarantineBuildingController.text != "") {
                        fetchCustomQuarantineFloor({
                          'quarantine_building_id_list':
                              quarantineBuildingController.text,
                          'page_size': pageSizeMax,
                        }).then((data) => setState(() {
                              quarantineFloorList = data;
                              floorKey.currentState?.openDropDownSearch();
                            }));
                      }
                    },
                    enabled: widget.mode != Permission.view,
                    showSearchBox: true,
                    mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                        ? Mode.DIALOG
                        : Mode.BOTTOM_SHEET,
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        100,
                    popupTitle: 'Tòa',
                  ),
                if (type == "staff")
                  MultiDropdownInput<KeyValue>(
                    widgetKey: floorKey,
                    label: 'Tầng',
                    hint: 'Chọn tầng',
                    required: widget.mode != Permission.view,
                    dropdownBuilder: customDropDown,
                    itemAsString: (KeyValue? u) => u!.name,
                    onFind: quarantineFloorList.isEmpty &&
                            quarantineBuildingController.text != ""
                        ? (String? filter) => fetchCustomQuarantineFloor({
                              'quarantine_building_id_list':
                                  quarantineBuildingController.text,
                              'page_size': pageSizeMax,
                              'search': filter,
                            })
                        : null,
                    compareFn: (item, selectedItem) =>
                        item?.id == selectedItem?.id,
                    itemValue: quarantineFloorList,
                    selectedItems: widget.quarantineFloor ??
                        (initQuarantineFloor.isNotEmpty
                            ? initQuarantineFloor
                            : quarantineFloorList
                                .where((element) => quarantineFloorController
                                    .text
                                    .split(',')
                                    .contains(element.id.toString()))
                                .toList()),
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          quarantineFloorController.text = "";
                        } else {
                          quarantineFloorController.text =
                              value.map((e) => e.id).join(",");
                        }
                        initQuarantineFloor = [];
                      });
                    },
                    enabled: widget.mode != Permission.view,
                    showSearchBox: true,
                    mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                        ? Mode.DIALOG
                        : Mode.BOTTOM_SHEET,
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        100,
                    popupTitle: 'Tầng',
                  ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Lưu"),
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
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      if (type == "manager") {
        if (widget.mode == Permission.add) {
          final response = await createManager(createManagerDataForm(
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
            quarantineWard: quarantineWardController.text,
          ));
          cancel();
          showNotification(response);
        } else if (widget.mode == Permission.edit) {
          final response = await updateManager(updateManagerDataForm(
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
            quarantineWard: quarantineWardController.text,
          ));
          cancel();
          showNotification(response);
        }
      } else {
        if (widget.mode == Permission.add) {
          final response = await createStaff(createStaffDataForm(
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
            quarantineWard: quarantineWardController.text,
            careArea: quarantineFloorController.text,
          ));
          cancel();
          showNotification(response);
        }
        if (widget.mode == Permission.edit) {
          final response = await updateStaff(updateStaffDataForm(
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
            quarantineWard: quarantineWardController.text,
            careArea: quarantineFloorController.text,
          ));
          cancel();
          showNotification(response);
        }
      }
    }
  }
}
