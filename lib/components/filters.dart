import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:intl/intl.dart';

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
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
            itemValue: [KeyValue(id: "1", name: "Ký túc xá khu A ĐHQG")],
            itemAsString: (KeyValue? u) => u!.name,
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            selectedItem: [KeyValue(id: "1", name: "Ký túc xá khu A ĐHQG")]
                .safeFirstWhere(
                    (gender) => gender.id == quarantineWardController.text),
            onChanged: (value) {
              if (value == null) {
                quarantineWardController.text = "";
              } else {
                quarantineWardController.text = value.id;
              }
            },
            showClearButton: true,
          ),
          DropdownInput(
            label: 'Tòa',
            hint: 'Chọn tòa',
            itemValue: ["1"],
            selectedItem: quarantineBuildingController.text,
            showClearButton: true,
          ),
          DropdownInput(
            label: 'Tầng',
            hint: 'Chọn tầng',
            itemValue: ["1"],
            selectedItem: quarantineFloorController.text,
            showClearButton: true,
          ),
          DropdownInput(
            label: 'Phòng',
            hint: 'Chọn phòng',
            itemValue: ["1"],
            selectedItem: quarantineRoomController.text,
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
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("Về từ vùng dịch"),
                Spacer(),
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text("Nhập cảnh"),
              ],
            ),
          ),
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
                    print(quarantineWardController.text);
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
