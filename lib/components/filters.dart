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
  required void Function()? setState,
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
            onFind: (String? filter) => fetchQuarantineWard({
              'page_size': PAGE_SIZE_MAX,
              'is_full': false,
            }),
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            onChanged: (value) {
              if (value == null) {
                quarantineWardController.text = "";
              } else {
                quarantineWardController.text = value.id.toString();
              }
              quarantineBuildingController.clear();
              quarantineFloorController.clear();
              quarantineRoomController.clear();
            },
            showClearButton: true,
          ),
          DropdownInput<KeyValue>(
            label: 'Tòa',
            hint: 'Chọn tòa',
            itemAsString: (KeyValue? u) => u!.name,
            onFind: (String? filter) => fetchQuarantineBuilding({
              'quarantine_ward': quarantineWardController.text,
              'page_size': PAGE_SIZE_MAX,
              'search': filter
            }),
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            onChanged: (value) {
              if (value == null) {
                quarantineBuildingController.text = "";
              } else {
                quarantineBuildingController.text = value.id.toString();
              }
              quarantineFloorController.clear();
              quarantineRoomController.clear();
            },
            showClearButton: true,
          ),
          DropdownInput<KeyValue>(
            label: 'Tầng',
            hint: 'Chọn tầng',
            itemAsString: (KeyValue? u) => u!.name,
            onFind: (String? filter) => fetchQuarantineFloor({
              'quarantine_building': quarantineBuildingController.text,
              'page_size': PAGE_SIZE_MAX,
              'search': filter
            }),
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            onChanged: (value) {
              if (value == null) {
                quarantineFloorController.text = "";
              } else {
                quarantineFloorController.text = value.id.toString();
              }
              quarantineRoomController.clear();
            },
            showClearButton: true,
          ),
          DropdownInput<KeyValue>(
            label: 'Phòng',
            hint: 'Chọn phòng',
            itemAsString: (KeyValue? u) => u!.name,
            onFind: (String? filter) => fetchQuarantineRoom({
              'quarantine_floor': quarantineFloorController.text,
              'page_size': PAGE_SIZE_MAX,
              'search': filter
            }),
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
          DateInput(
            label: 'Ngày bắt đầu cách ly (Từ ngày)',
            controller: quarantineAtMinController,
            maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            showClearButton: true,
          ),
          DateInput(
            label: 'Ngày bắt đầu cách ly (Đến ngày)',
            controller: quarantineAtMaxController,
            maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            showClearButton: true,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text("Diện cách ly"),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("F0"),
                Spacer(),
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("F1"),
                Spacer(),
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("F2"),
                Spacer(),
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("F3"),
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(right: 16),
          //   child: Row(
          //     children: [
          //       Checkbox(
          //         value: false,
          //         onChanged: (value) {},
          //       ),
          //       Text("Về từ vùng dịch"),
          //       Spacer(),
          //       Checkbox(
          //         value: false,
          //         onChanged: (value) {},
          //       ),
          //       Text("Nhập cảnh"),
          //     ],
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Spacer(),
                // OutlinedButton(
                //   onPressed: () {
                //     // Respond to button press
                //     quarantineWardController.clear();
                //     quarantineBuildingController.clear();
                //     quarantineFloorController.clear();
                //     quarantineRoomController.clear();
                //     quarantineAtMinController.clear();
                //     quarantineAtMaxController.clear();
                //     setState!();
                //   },
                //   child: Text("Đặt lại"),
                // ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                    setState!();
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
    },
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
  required void Function()? setState,
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
          ),
          DropdownInput<KeyValue>(
            label: 'Kết quả',
            hint: 'Chọn kết quả',
            itemValue: testValueList,
            itemAsString: (KeyValue? u) => u!.name,
            maxHeight: 168,
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            selectedItem: testValueList
                .safeFirstWhere((result) => result.id == resultController.text),
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
          ),
          DateInput(
            label: 'Ngày xét nghiệm (Từ ngày)',
            controller: createAtMinController,
            maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            showClearButton: true,
          ),
          DateInput(
            label: 'Ngày xét nghiệm (Đến ngày)',
            controller: createAtMaxController,
            maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            showClearButton: true,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                    setState!();
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
    },
  );
}

Future quarantineFilter(
  BuildContext context, {
  required TextEditingController cityController,
  required TextEditingController districtController,
  //required bool myQuarantine,
  required void Function()? setState,
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
            hint: 'Chọn tỉnh/thành',
            itemValue: [KeyValue(id: "1", name: "Thành phố Hà Nội")],
            itemAsString: (KeyValue? u) => u!.name,
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            selectedItem: [KeyValue(id: "1", name: "Thành phố Hà Nội")]
                .safeFirstWhere((city) => city.id == cityController.text),
            onChanged: (value) {
              if (value == null) {
                cityController.text = "";
              } else {
                cityController.text = value.id;
              }
            },
            showClearButton: true,
          ),
          DropdownInput<KeyValue>(
            label: 'Quận/huyện',
            hint: 'Chọn quận/huyện',
            itemValue: [KeyValue(id: "1", name: "Quận Ba Đình")],
            itemAsString: (KeyValue? u) => u!.name,
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            selectedItem: [KeyValue(id: "1", name: "Quận Ba Đình")]
                .safeFirstWhere(
                    (district) => district.id == districtController.text),
            onChanged: (value) {
              if (value == null) {
                districtController.text = "";
              } else {
                districtController.text = value.id;
              }
            },
            showClearButton: true,
          ),
          // ListTileTheme(
          //     contentPadding: EdgeInsets.all(0),
          //     child: CheckboxListTile(
          //       title: Text("Khai hộ"),
          //       controlAffinity: ListTileControlAffinity.leading,
          //       value: myQuarantine,
          //       onChanged: (bool? value) {
          //         setState!(() {
          //           myQuarantine = value!;
          //         });
          //       },
          //     ),
          //   ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                    setState!();
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
    },
  );
}
