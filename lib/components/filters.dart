import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';

Future memberFilter(BuildContext context) {
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
      return ListView(
        children: <Widget>[
          ListTile(
            title: Center(
              child: Text(
                'Lọc dữ liệu',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          DropdownInput(
            label: 'Khu cách ly',
            hint: 'KTX Khu A',
            itemValue: ['KTX Khu A'],
          ),
          DropdownInput(
            label: 'Tòa',
            hint: 'Chọn tòa',
            itemValue: ["1"],
          ),
          DropdownInput(
            label: 'Tầng',
            hint: 'Chọn tầng',
            itemValue: ["1"],
          ),
          DropdownInput(
            label: 'Phòng',
            hint: 'Chọn phòng',
            itemValue: ["1"],
          ),
          Container(
            child: Input(
              label: 'Ngày bắt đầu cách ly (Từ ngày)',
            ),
          ),
          Container(
            child: Input(
              label: 'Ngày bắt đầu cách ly (Đến ngày)',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
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
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  child: Text("Đặt lại"),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
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
