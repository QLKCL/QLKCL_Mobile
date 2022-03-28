import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/components/time_input.dart';
import 'package:qlkcl/models/destination_history.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:intl/intl.dart';

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
    fetchCountry().then((value) => setState(() {
          countryList = value;
        }));
    fetchCity({'country_code': countryController.text})
        .then((value) => setState(() {
              cityList = value;
            }));
    fetchDistrict({'city_id': cityController.text})
        .then((value) => setState(() {
              districtList = value;
            }));
    fetchWard({'district_id': districtController.text})
        .then((value) => setState(() {
              wardList = value;
            }));
  }

  //submit
  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
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
      if (response.success) {
        Navigator.pop(context);
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
                  required: widget.mode == Permission.view ? false : true,
                  itemValue: countryList,
                  selectedItem: countryList.length == 0
                      ? initCountry
                      : countryList.safeFirstWhere((type) =>
                          type.id.toString() == countryController.text),
                  enabled: widget.mode != Permission.view ? true : false,
                  onFind: countryList.length == 0
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
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  showSearchBox: true,
                  mode: Mode.BOTTOM_SHEET,
                  maxHeight: MediaQuery.of(context).size.height - 100,
                  popupTitle: 'Quốc gia',
                ),
                DropdownInput<KeyValue>(
                  label: 'Tỉnh/thành',
                  hint: 'Tỉnh/thành',
                  itemValue: cityList,
                  required: widget.mode == Permission.view ? false : true,
                  selectedItem: cityList.length == 0
                      ? initCity
                      : cityList.safeFirstWhere(
                          (type) => type.id.toString() == cityController.text),
                  enabled: widget.mode != Permission.view ? true : false,
                  onFind: cityList.length == 0
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
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  showSearchBox: true,
                  mode: Mode.BOTTOM_SHEET,
                  maxHeight: MediaQuery.of(context).size.height - 100,
                  popupTitle: 'Tỉnh/thành',
                ),
                DropdownInput<KeyValue>(
                  label: 'Quận/huyện',
                  hint: 'Quận/huyện',
                  itemValue: districtList,
                  required: widget.mode == Permission.view ? false : true,
                  selectedItem: districtList.length == 0
                      ? initDistrict
                      : districtList.safeFirstWhere((type) =>
                          type.id.toString() == districtController.text),
                  enabled: widget.mode != Permission.view ? true : false,
                  onFind: districtList.length == 0
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
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  showSearchBox: true,
                  mode: Mode.BOTTOM_SHEET,
                  maxHeight: MediaQuery.of(context).size.height - 100,
                  popupTitle: 'Quận/huyện',
                ),
                DropdownInput<KeyValue>(
                  label: 'Phường/xã',
                  hint: 'Phường/xã',
                  itemValue: wardList,
                  selectedItem: wardList.length == 0
                      ? initWard
                      : wardList.safeFirstWhere(
                          (type) => type.id.toString() == wardController.text),
                  onFind: wardList.length == 0
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
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemAsString: (KeyValue? u) => u!.name,
                  showSearchBox: true,
                  mode: Mode.BOTTOM_SHEET,
                  maxHeight: MediaQuery.of(context).size.height - 100,
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
                        required: widget.mode == Permission.view ? false : true,
                        onChangedFunction: () {
                          setState(() {});
                        },
                        maxDate:
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TimeInput(
                        label: "Thời gian",
                        controller: startTimeController,
                        enabled: startDateController.text != "" ? true : false,
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
                        enabled: startDateController.text != "" ? true : false,
                        minDate: startDateController.text,
                        maxDate:
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TimeInput(
                        label: "Thời gian",
                        controller: endTimeController,
                        enabled: startDateController.text != "" ? true : false,
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
                      style: TextStyle(color: CustomColors.white),
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
