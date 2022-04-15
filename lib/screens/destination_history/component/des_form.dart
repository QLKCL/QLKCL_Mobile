import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/components/time_input.dart';
import 'package:qlkcl/models/destination_history.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DestinationHistoryForm extends StatefulWidget {
  const DestinationHistoryForm({
    Key? key,
    this.mode = Permission.view,
    this.destinationData,
    this.code,
  }) : super(key: key);
  final Permission mode;
  final DestinationHistory? destinationData;
  final String? code;

  @override
  _DestinationHistoryFormState createState() => _DestinationHistoryFormState();
}

class _DestinationHistoryFormState extends State<DestinationHistoryForm> {
  final _formKey = GlobalKey<FormState>();

  final cityKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final districtKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final wardKey = GlobalKey<DropdownSearchState<KeyValue>>();

  final codeController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final wardController = TextEditingController();
  final detailAddressController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final noteController = TextEditingController();
  DateTime startDateTime = DateTime.now();

  List<KeyValue> countryList = [];
  List<KeyValue> cityList = [];
  List<KeyValue> districtList = [];
  List<KeyValue> wardList = [];

  KeyValue? initCountry;
  KeyValue? initCity;
  KeyValue? initDistrict;
  KeyValue? initWard;

  @override
  void initState() {
    super.initState();
    if (widget.destinationData != null) {
      codeController.text = widget.destinationData?.user != null
          ? widget.destinationData!.user.id
          : "";
      countryController.text = widget.destinationData?.country != null
          ? widget.destinationData!.country.id
          : "VNM";
      cityController.text = widget.destinationData?.city != null
          ? widget.destinationData!.city.id.toString()
          : "";
      districtController.text = widget.destinationData?.district != null
          ? widget.destinationData!.district.id.toString()
          : "";
      wardController.text = widget.destinationData?.ward != null
          ? widget.destinationData!.ward.id.toString()
          : "";
      detailAddressController.text =
          widget.destinationData?.detailAddress ?? "";
      noteController.text = widget.destinationData?.note ?? "";

      initCountry = (widget.destinationData?.country != null)
          ? widget.destinationData!.country
          : null;
      initCity = (widget.destinationData?.city != null)
          ? widget.destinationData!.city
          : null;
      initDistrict = (widget.destinationData?.district != null)
          ? widget.destinationData!.district
          : null;
      initWard = (widget.destinationData?.ward != null)
          ? widget.destinationData!.ward
          : null;
    } else {
      codeController.text = widget.code ?? "";
      countryController.text = "VNM";
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
  }

  //submit
  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      final response = await createDestiantionHistory(
        createDestiantionHistoryDataForm(
          code: codeController.text,
          country: countryController.text,
          city: cityController.text,
          district: districtController.text,
          ward: wardController.text,
          address: detailAddressController.text,
          startTime: parseDateToDateTimeWithTimeZone(startDateController.text,
              time: startTimeController.text),
          endTime: parseDateToDateTimeWithTimeZone(endDateController.text,
              time: endTimeController.text),
          note: noteController.text,
        ),
      );

      cancel();
      showNotification(response);
      if (response.status == Status.success) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownInput<KeyValue>(
                  label: 'Quốc gia',
                  hint: 'Quốc gia',
                  required: widget.mode != Permission.view,
                  itemValue: countryList,
                  selectedItem: countryList.isEmpty
                      ? initCountry
                      : countryList.safeFirstWhere((type) =>
                          type.id.toString() == countryController.text),
                  enabled: widget.mode != Permission.view,
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
                  enabled: widget.mode != Permission.view,
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
                  enabled: widget.mode != Permission.view,
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
                  selectedItem: wardList.isEmpty
                      ? initWard
                      : wardList.safeFirstWhere(
                          (type) => type.id.toString() == wardController.text),
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
                  controller: detailAddressController,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: NewDateInput(
                        label: 'Từ ngày',
                        controller: startDateController,
                        required: widget.mode != Permission.view,
                        onChangedFunction: () {
                          if (startTimeController.text == "") {
                            startTimeController.text =
                                "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
                          }
                          setState(() {});
                        },
                        maxDate:
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      ),
                    ),
                    Expanded(
                      child: TimeInput(
                        label: "Thời gian",
                        controller: startTimeController,
                        enabled: startDateController.text != "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: NewDateInput(
                        label: 'Đến thời gian',
                        controller: endDateController,
                        onChangedFunction: () {
                          if (endTimeController.text == "") {
                            endTimeController.text =
                                "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
                          }
                          setState(() {});
                        },
                        enabled: startDateController.text != "",
                        minDate: startDateController.text,
                        maxDate:
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      ),
                    ),
                    Expanded(
                      child: TimeInput(
                        label: "Thời gian",
                        controller: endTimeController,
                        enabled: startDateController.text != "" &&
                            endTimeController.text != "",
                      ),
                    ),
                  ],
                ),
                Input(
                  label: "Ghi chú",
                  controller: noteController,
                  maxLines: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      "Lưu",
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
