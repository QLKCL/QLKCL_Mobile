import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/theme/app_theme.dart';

class MemberQuarantineInfo extends StatefulWidget {
  final Member? personalData;
  final String mode;
  const MemberQuarantineInfo(
      {Key? key, this.personalData, this.mode = "detail"})
      : super(key: key);

  @override
  _MemberQuarantineInfoState createState() => _MemberQuarantineInfoState();
}

class _MemberQuarantineInfoState extends State<MemberQuarantineInfo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final quarantineRoomController =
        TextEditingController(text: widget.personalData?.quarantineRoom);
    final quarantineFloorController =
        TextEditingController(text: widget.personalData?.quarantineFloor);
    final quarantineBuildingController =
        TextEditingController(text: widget.personalData?.quarantineBuilding);
    final quarantineWardController =
        TextEditingController(text: widget.personalData?.quarantineWard);
    final labelController =
        TextEditingController(text: widget.personalData?.label);
    final quarantinedAtController =
        TextEditingController(text: widget.personalData?.quarantinedAt);
    final backgroundDiseaseController =
        TextEditingController(text: widget.personalData?.backgroundDisease);
    final otherBackgroundDiseaseController = TextEditingController(
        text: widget.personalData?.otherBackgroundDisease);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownInput(
              label: 'Khu cách ly',
              hint: 'Chọn khu cách ly',
              itemValue: ['KTX Khu A'],
              required: widget.mode == "detail" ? false : true,
              selectedItem: quarantineWardController.text,
            ),
            DropdownInput(
              label: 'Tòa',
              hint: 'Chọn tòa',
              itemValue: ["1"],
              selectedItem: quarantineBuildingController.text,
            ),
            DropdownInput(
              label: 'Tầng',
              hint: 'Chọn tầng',
              itemValue: ["1"],
              selectedItem: quarantineFloorController.text,
            ),
            DropdownInput(
              label: 'Phòng',
              hint: 'Chọn phòng',
              itemValue: ["1"],
              selectedItem: quarantineRoomController.text,
            ),
            DropdownInput(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: ["F1", "F2", "F3", "Về từ vùng dịch", "Nhập cảnh"],
              selectedItem: labelController.text,
            ),
            DateInput(
              label: 'Thời gian bắt đầu cách ly',
              controller: quarantinedAtController,
            ),
            Input(
              label: 'Lịch sử di chuyển',
              maxLines: 4,
            ),
            Row(
              children: [
                Checkbox(
                  value: widget.personalData?.positiveTestedBefore ?? false,
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
              controller: backgroundDiseaseController,
            ),
            Input(
              label: 'Bệnh nền khác',
              controller: otherBackgroundDiseaseController,
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
