import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class MemberQuarantineInfo extends StatelessWidget {
  const MemberQuarantineInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          DropdownInput(
            label: 'Khu cách ly',
            hint: 'Chọn khu cách ly',
            itemValue: ['KTX Khu A'],
            required: true,
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
          DropdownInput(
            label: 'Diện cách ly',
            hint: 'Chọn diện cách ly',
            itemValue: ["F1", "F2", "F3", "Về từ vùng dịch", "Nhập cảnh"],
          ),
          DateInput(
            label: 'Thời gian bắt đầu cách ly',
          ),
          Input(
            label: 'Lịch sử di chuyển',
            maxLines: 4,
          ),
          Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              Text("Đã từng nhiễm COVID-19"),
            ],
          ),
          MultiDropdownInput(
            label: 'Bệnh nền',
            hint: 'Chọn bệnh nền',
            itemValue: [
              "Tiểu đường",
              "Ung thư",
              "Tăng huyết áp",
              "Bệnh hen suyễn",
              "Bệnh gan",
              "Bệnh thận mãn tính",
              "Tim mạch",
              "Bệnh lý mạch máu não"
            ],
            mode: Mode.BOTTOM_SHEET,
            dropdownBuilder: _customDropDown,
          ),
          Input(
            label: 'Bệnh nền khác',
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text("* Thông tin bắt buộc"),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Xác nhận',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _customDropDown(BuildContext context, List<String?> selectedItems) {
  // if (selectedItems.isEmpty) {
  //   return Container();
  // }

  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorLight),
          child: Text(
            e!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }).toList(),
  );
}
