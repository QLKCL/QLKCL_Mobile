import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/image_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/pandemic.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class QuarantineForm extends StatefulWidget {
  final Permission mode;
  final Quarantine? quarantineInfo;

  const QuarantineForm(
      {Key? key, this.quarantineInfo, this.mode = Permission.add})
      : super(key: key);

  @override
  _QuarantineFormState createState() => _QuarantineFormState();
}

class _QuarantineFormState extends State<QuarantineForm> {
  //Input Controller
  final _formKey = GlobalKey<FormState>();

  final cityKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final districtKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final wardKey = GlobalKey<DropdownSearchState<KeyValue>>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final wardController = TextEditingController();
  final addressController = TextEditingController();
  final typeController = TextEditingController();
  final emailController = TextEditingController();
  final managerController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final statusController = TextEditingController();
  // final lattitudeController = TextEditingController();
  // final longtitudeController = TextEditingController();
  final coordinateController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final pandemicController = TextEditingController();

  List<KeyValue> countryList = [];
  List<KeyValue> cityList = [];
  List<KeyValue> districtList = [];
  List<KeyValue> wardList = [];
  List<KeyValue> pandemicList = [];

  KeyValue? initCountry;
  KeyValue? initCity;
  KeyValue? initDistrict;
  KeyValue? initWard;
  KeyValue? initPandemic;

  @override
  void initState() {
    if (widget.quarantineInfo != null) {
      idController.text = widget.quarantineInfo?.id != null
          ? widget.quarantineInfo!.id.toString()
          : "";
      nameController.text = widget.quarantineInfo?.fullName ?? "";
      countryController.text = widget.quarantineInfo!.country != null
          ? widget.quarantineInfo?.country['code']
          : "VNM";
      cityController.text = widget.quarantineInfo?.city != null
          ? widget.quarantineInfo!.city['id'].toString()
          : "";

      districtController.text = widget.quarantineInfo?.district != null
          ? widget.quarantineInfo!.district['id'].toString()
          : "";

      wardController.text = widget.quarantineInfo?.ward != null
          ? widget.quarantineInfo!.ward['id'].toString()
          : "";

      addressController.text = widget.quarantineInfo?.address ?? "";
      typeController.text = widget.quarantineInfo?.type ?? "";
      statusController.text = widget.quarantineInfo?.status ?? "";
      emailController.text = widget.quarantineInfo?.email ?? "";
      managerController.text = widget.quarantineInfo?.mainManager != null
          ? widget.quarantineInfo!.mainManager['code']
          : "";
      phoneNumberController.text = widget.quarantineInfo?.phoneNumber ?? "";
      // longtitudeController.text = widget.quarantineInfo?.longitude ?? "";
      // lattitudeController.text = widget.quarantineInfo?.latitude ?? "";
      coordinateController.text =
          "${widget.quarantineInfo?.latitude}, ${widget.quarantineInfo?.longitude}";

      imageController.text = widget.quarantineInfo?.image ?? "";

      pandemicController.text = widget.quarantineInfo?.pandemic != null
          ? widget.quarantineInfo!.pandemic!.id.toString()
          : "";

      initCountry = (widget.quarantineInfo?.country != null)
          ? KeyValue.fromJson(widget.quarantineInfo!.country)
          : null;
      initCity = (widget.quarantineInfo?.city != null)
          ? KeyValue.fromJson(widget.quarantineInfo!.city)
          : null;
      initDistrict = (widget.quarantineInfo?.district != null)
          ? KeyValue.fromJson(widget.quarantineInfo!.district)
          : null;
      initWard = (widget.quarantineInfo?.ward != null)
          ? KeyValue.fromJson(widget.quarantineInfo!.ward)
          : null;
      initPandemic = (widget.quarantineInfo?.pandemic != null)
          ? KeyValue(
              id: widget.quarantineInfo!.pandemic!.id,
              name: widget.quarantineInfo!.pandemic!.name)
          : null;
    } else {
      countryController.text = "VNM";
      statusController.text = "RUNNING";
      typeController.text = "CONCENTRATE";
    }
    super.initState();
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
    fetchPandemic().then((value) {
      if (mounted) {
        setState(() {
          pandemicList = value;
        });
      }
    });
  }

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      if (widget.mode == Permission.add) {
        final response = await createQuarantine(createQuarantineDataForm(
          email: emailController.text,
          fullName: nameController.text,
          country: countryController.text,
          city: cityController.text,
          district: districtController.text,
          ward: wardController.text,
          status: statusController.text,
          mainManager: managerController.text,
          address: addressController.text,
          type: typeController.text,
          phoneNumber: phoneNumberController.text,
          image: imageController.text,
          latitude: coordinateController.text.split(',')[0].trim(),
          longtitude: coordinateController.text.split(',')[1].trim(),
          pandemic: pandemicController.text,
        ));
        cancel();
        showNotification(response);
      } else if (widget.mode == Permission.edit) {
        final response = await updateQuarantine(updateQuarantineDataForm(
          id: widget.quarantineInfo!.id,
          email: emailController.text,
          fullName: nameController.text,
          country: countryController.text,
          city: cityController.text,
          district: districtController.text,
          ward: wardController.text,
          status: statusController.text,
          mainManager: managerController.text,
          address: addressController.text,
          type: typeController.text,
          phoneNumber: phoneNumberController.text,
          image: imageController.text,
          latitude: coordinateController.text.split(',')[0].trim(),
          longtitude: coordinateController.text.split(',')[1].trim(),
          pandemic: pandemicController.text,
        ));
        cancel();
        showNotification(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Text(
                    'Thông tin chung',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Input(
                  label: 'Tên đầy đủ',
                  required: true,
                  controller: nameController,
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
                  popupTitle: 'Tỉnh thành',
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
                  popupTitle: 'Quận huyện',
                ),
                DropdownInput<KeyValue>(
                  widgetKey: wardKey,
                  label: 'Phường/xã',
                  hint: 'Phường/xã',
                  itemValue: wardList,
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
                  popupTitle: 'Phường xã',
                ),
                Input(
                  label: 'Địa chỉ',
                  controller: addressController,
                ),
                Input(
                  label: 'Tọa độ',
                  controller: coordinateController,
                  helper: "Ví dụ: 10.77337803132624, 106.66062122468851",
                ),
                // Input(
                //   label: 'Latitude',
                //   controller: lattitudeController,
                // ),
                // Input(
                //   label: 'Longtitude',
                //   controller: longtitudeController,
                // ),
                DropdownInput<KeyValue>(
                    label: 'Người quản lý',
                    hint: 'Chọn người quản lý',
                    required: widget.mode != Permission.view,
                    selectedItem: (widget.quarantineInfo?.mainManager != null)
                        ? KeyValue.fromJson(widget.quarantineInfo!.mainManager)
                        : null,
                    enabled: widget.mode == Permission.edit ||
                        widget.mode == Permission.add,
                    onFind: (String? filter) =>
                        fetchNotMemberList({'role_name_list': 'MANAGER'}),
                    searchOnline: false,
                    onChanged: (value) {
                      if (value == null) {
                        managerController.text = "";
                      } else {
                        managerController.text = value.id.toString();
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
                    popupTitle: 'Quản lý'),
                DropdownInput<KeyValue>(
                  label: 'Cơ sở cách ly',
                  hint: 'Cơ sở cách ly',
                  required: true,
                  itemValue: quarantineTypeList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 150,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: quarantineTypeList
                      .safeFirstWhere((type) => type.id == typeController.text),
                  onChanged: (value) {
                    if (value == null) {
                      typeController.text = "";
                    } else {
                      typeController.text = value.id;
                    }
                  },
                ),
                DropdownInput<KeyValue>(
                  label: 'Trạng thái',
                  hint: 'Trạng thái',
                  required: true,
                  itemValue: quarantineStatusList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 150,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: quarantineStatusList.safeFirstWhere(
                      (status) => status.id == statusController.text),
                  onChanged: (value) {
                    if (value == null) {
                      statusController.text = "";
                    } else {
                      statusController.text = value.id;
                    }
                  },
                ),
                DropdownInput<KeyValue>(
                  label: 'Dịch bệnh',
                  hint: 'Dịch bệnh',
                  itemValue: pandemicList,
                  selectedItem: pandemicList.isEmpty
                      ? initPandemic
                      : pandemicList.safeFirstWhere((type) =>
                          type.id.toString() == pandemicController.text),
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                  onFind: pandemicList.isEmpty
                      ? (String? filter) => fetchPandemic()
                      : null,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        pandemicController.text = "";
                      } else {
                        pandemicController.text = value.id.toString();
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
                  popupTitle: 'Dịch bệnh',
                ),
                Input(
                  label: 'Điện thoại liên lạc',
                  hint: 'Điện thoại liên lạc',
                  type: TextInputType.phone,
                  validatorFunction: phoneNullableValidator,
                  controller: phoneNumberController,
                ),
                Input(
                  label: 'Email',
                  hint: 'Email liên lạc',
                  required: true,
                  controller: emailController,
                  type: TextInputType.emailAddress,
                  validatorFunction: emailValidator,
                ),
                ImageField(
                  controller: imageController,
                  maxQuantityImage: 3,
                  type: "Quarantine_Ward",
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      (widget.mode == Permission.add) ? 'Tạo' : 'Xác nhận',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
