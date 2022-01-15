import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/constant.dart';

Future memberFilter(
  BuildContext context, {
  required TextEditingController quarantineWardController,
  required TextEditingController quarantineBuildingController,
  required TextEditingController quarantineFloorController,
  required TextEditingController quarantineRoomController,
  required TextEditingController quarantineAtMinController,
  required TextEditingController quarantineAtMaxController,
  required TextEditingController labelController,
  required List<KeyValue> quarantineWardList,
  List<KeyValue> quarantineBuildingList = const [],
  List<KeyValue> quarantineFloorList = const [],
  List<KeyValue> quarantineRoomList = const [],
  required void Function()? onSubmit,
}) {
  return showBarModalBottomSheet(
    barrierColor: Colors.black54,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'Lọc dữ liệu',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            DropdownInput<KeyValue>(
              label: 'Khu cách ly',
              hint: 'Chọn khu cách ly',
              itemAsString: (KeyValue? u) => u!.name,
              itemValue: quarantineWardList,
              selectedItem: quarantineWardList.safeFirstWhere(
                  (type) => type.id == quarantineWardController.text),
              onFind: quarantineWardList.length == 0
                  ? (String? filter) => fetchQuarantineWard({
                        'page_size': PAGE_SIZE_MAX,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              onChanged: (value) {
                if (value == null) {
                  quarantineWardController.text = "";
                } else {
                  quarantineWardController.text = value.id.toString();
                }
                fetchQuarantineBuilding({
                  'quarantine_ward': quarantineWardController.text,
                  'page_size': PAGE_SIZE_MAX,
                }).then((value) => setState(() {
                      quarantineBuildingController.clear();
                      quarantineFloorController.clear();
                      quarantineRoomController.clear();
                      quarantineBuildingList = value;
                      quarantineFloorList = [];
                      quarantineRoomList = [];
                    }));
              },
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tòa',
              hint: 'Chọn tòa',
              itemAsString: (KeyValue? u) => u!.name,
              itemValue: quarantineBuildingList,
              selectedItem: quarantineBuildingList.safeFirstWhere(
                  (type) => type.id == quarantineBuildingController.text),
              onFind: quarantineBuildingList.length == 0
                  ? (String? filter) => fetchQuarantineBuilding({
                        'quarantine_ward': quarantineWardController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              onChanged: (value) {
                if (value == null) {
                  quarantineBuildingController.text = "";
                } else {
                  quarantineBuildingController.text = value.id.toString();
                }
                fetchQuarantineFloor({
                  'quarantine_building': quarantineBuildingController.text,
                  'page_size': PAGE_SIZE_MAX,
                }).then((value) => setState(() {
                      quarantineFloorController.clear();
                      quarantineRoomController.clear();
                      quarantineFloorList = value;
                      quarantineRoomList = [];
                    }));
              },
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tầng',
              hint: 'Chọn tầng',
              itemAsString: (KeyValue? u) => u!.name,
              itemValue: quarantineFloorList,
              selectedItem: quarantineFloorList.safeFirstWhere(
                  (type) => type.id == quarantineFloorController.text),
              onFind: quarantineFloorList.length == 0
                  ? (String? filter) => fetchQuarantineFloor({
                        'quarantine_building':
                            quarantineBuildingController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              onChanged: (value) {
                if (value == null) {
                  quarantineFloorController.text = "";
                } else {
                  quarantineFloorController.text = value.id.toString();
                }
                fetchQuarantineRoom({
                  'quarantine_floor': quarantineFloorController.text,
                  'page_size': PAGE_SIZE_MAX,
                }).then((value) => setState(() {
                      quarantineRoomController.clear();
                      quarantineRoomList = value;
                    }));
              },
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Phòng',
              hint: 'Chọn phòng',
              itemAsString: (KeyValue? u) => u!.name,
              itemValue: quarantineRoomList,
              selectedItem: quarantineRoomList.safeFirstWhere(
                  (type) => type.id == quarantineRoomController.text),
              onFind: quarantineRoomList.length == 0
                  ? (String? filter) => fetchQuarantineRoom({
                        'quarantine_floor': quarantineFloorController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              onChanged: (value) {
                if (value == null) {
                  quarantineRoomController.text = "";
                } else {
                  quarantineRoomController.text = value.id.toString();
                }
              },
              showClearButton: true,
            ),
            NewDateRangeInput(
              label: 'Ngày bắt đầu cách ly',
              controllerStart: quarantineAtMinController,
              controllerEnd: quarantineAtMaxController,
              maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              showClearButton: true,
            ),
            MultiDropdownInput<KeyValue>(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: labelList,
              mode: Mode.MENU,
              dropdownBuilder: _customDropDown,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              selectedItems: labelController.text != ""
                  ? (labelController.text
                      .split(',')
                      .map((e) =>
                          labelList.safeFirstWhere((result) => result.id == e)!)
                      .toList())
                  : null,
              onChanged: (value) {
                if (value == null) {
                  labelController.text = "";
                } else {
                  labelController.text = value.map((e) => e.id).join(",");
                }
              },
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Respond to button press
                      quarantineWardController.clear();
                      quarantineBuildingController.clear();
                      quarantineFloorController.clear();
                      quarantineRoomController.clear();
                      quarantineAtMinController.clear();
                      quarantineAtMaxController.clear();
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Đặt lại"),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Tìm kiếm"),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  if (selectedItems.isEmpty) {
    return Text("Chọn diện cách ly");
  }

  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          // margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorLight),
          child: Text(
            e!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }).toList(),
  );
}

Future testFilter(
  BuildContext context, {
  required TextEditingController userCodeController,
  required TextEditingController stateController,
  required TextEditingController typeController,
  required TextEditingController resultController,
  required TextEditingController createAtMinController,
  required TextEditingController createAtMaxController,
  required void Function()? onSubmit,
}) {
  return showBarModalBottomSheet(
    barrierColor: Colors.black54,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    useRootNavigator: true,
    context: context,
    builder: (context) {
      // Using Wrap makes the bottom sheet height the height of the content.
      // Otherwise, the height will be half the height of the screen.

      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'Lọc dữ liệu',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            DropdownInput<KeyValue>(
              label: 'Kỹ thuật xét nghiệm',
              hint: 'Chọn kỹ thuật xét nghiệm',
              itemValue: testTypeList,
              itemAsString: (KeyValue? u) => u!.name,
              maxHeight: 112,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: testTypeList
                  .safeFirstWhere((type) => type.id == typeController.text),
              onChanged: (value) {
                if (value == null) {
                  typeController.text = "";
                } else {
                  typeController.text = value.id;
                }
              },
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Trạng thái',
              hint: 'Chọn trạng thái',
              itemValue: testStateList,
              itemAsString: (KeyValue? u) => u!.name,
              maxHeight: 112,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: testStateList
                  .safeFirstWhere((state) => state.id == stateController.text),
              onChanged: (value) {
                if (value == null) {
                  stateController.text = "";
                } else {
                  stateController.text = value.id;
                }
              },
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Kết quả',
              hint: 'Chọn kết quả',
              itemValue: testValueList,
              itemAsString: (KeyValue? u) => u!.name,
              maxHeight: 168,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: testValueList.safeFirstWhere(
                  (result) => result.id == resultController.text),
              onChanged: (value) {
                if (value == null) {
                  resultController.text = "";
                } else {
                  if (value.id == "NEGATIVE" || value.id == "POSITIVE") {
                    stateController.text = "DONE";
                  } else {
                    stateController.text = "WAITING";
                  }
                  resultController.text = value.id;
                }
              },
              showClearButton: true,
            ),
            NewDateRangeInput(
              label: 'Ngày xét nghiệm',
              controllerStart: createAtMinController,
              controllerEnd: createAtMaxController,
              maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              showClearButton: true,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Respond to button press
                      userCodeController.clear();
                      stateController.clear();
                      typeController.clear();
                      resultController.clear();
                      createAtMinController.clear();
                      createAtMaxController.clear();
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Đặt lại"),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Tìm kiếm"),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}

Future quarantineFilter(
  BuildContext context, {
  required TextEditingController cityController,
  required TextEditingController districtController,
  required TextEditingController wardController,
  required TextEditingController mainManagerController,
  bool myQuarantine = false,
  required void Function()? onSubmit,
  required List<KeyValue> cityList,
  required List<KeyValue> managerList,
  List<KeyValue> districtList = const [],
  List<KeyValue> wardList = const [],
}) {
  return showBarModalBottomSheet(
    barrierColor: Colors.black54,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    useRootNavigator: true,
    context: context,
    builder: (context) {
      // Using Wrap makes the bottom sheet height the height of the content.
      // Otherwise, the height will be half the height of the screen.
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'Lọc dữ liệu',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            DropdownInput<KeyValue>(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              itemValue: cityList,
              selectedItem: cityList
                  .safeFirstWhere((type) => type.id == cityController.text),
              onFind: cityList.length == 0
                  ? (String? filter) => fetchCity({'country_code': 'VNM'})
                  : null,
              onChanged: (value) {
                if (value == null) {
                  cityController.text = "";
                } else {
                  cityController.text = value.id.toString();
                }
                fetchDistrict({'city_id': cityController.text})
                    .then((value) => setState(() {
                          districtController.clear();
                          wardController.clear();
                          districtList = value;
                          wardList = [];
                        }));
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Tỉnh/thành',
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              itemValue: districtList,
              selectedItem: districtList
                  .safeFirstWhere((type) => type.id == districtController.text),
              onFind: districtList.length == 0
                  ? (String? filter) =>
                      fetchDistrict({'city_id': cityController.text})
                  : null,
              onChanged: (value) {
                if (value == null) {
                  districtController.text = "";
                } else {
                  districtController.text = value.id.toString();
                }
                fetchWard({'district_id': districtController.text})
                    .then((value) => setState(() {
                          wardController.clear();
                          wardList = value;
                        }));
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Quận/huyện',
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              itemValue: wardList,
              selectedItem: wardList
                  .safeFirstWhere((type) => type.id == wardController.text),
              onFind: wardList.length == 0
                  ? (String? filter) =>
                      fetchWard({'district_id': districtController.text})
                  : null,
              onChanged: (value) {
                if (value == null) {
                  wardController.text = "";
                } else {
                  wardController.text = value.id.toString();
                }
              },
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height - 100,
              popupTitle: 'Phường/xã',
              showClearButton: true,
            ),
            DropdownInput<KeyValue>(
                label: 'Người quản lý',
                hint: 'Chọn người quản lý',
                itemValue: managerList,
                selectedItem: managerList.safeFirstWhere(
                    (type) => type.id == mainManagerController.text),
                onFind: managerList.length == 0
                    ? (String? filter) =>
                        fetchNotMemberList({'role_name_list': 'MANAGER'})
                    : null,
                onChanged: (value) {
                  if (value == null) {
                    mainManagerController.text = "";
                  } else {
                    mainManagerController.text = value.id.toString();
                  }
                },
                itemAsString: (KeyValue? u) => u!.name,
                showSearchBox: true,
                mode: Mode.BOTTOM_SHEET,
                maxHeight: MediaQuery.of(context).size.height - 100,
                popupTitle: 'Quản lý'),

            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     ListTileTheme(
            //       contentPadding: EdgeInsets.only(left: 8),
            //       child: CheckboxListTile(
            //         title: Text("Quản lý bởi tôi"),
            //         controlAffinity: ListTileControlAffinity.leading,
            //         value: myQuarantine,
            //         onChanged: (bool? value) {
            //           myQuarantine = value!;
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Respond to button press
                      cityController.clear();
                      districtController.clear();
                      wardController.clear();
                      mainManagerController.clear();
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Đặt lại"),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                      onSubmit!();
                      Navigator.pop(context);
                    },
                    child: Text("Tìm kiếm"),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}
