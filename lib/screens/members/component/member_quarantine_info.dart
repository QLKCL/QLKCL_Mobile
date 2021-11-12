import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/constant.dart';

class MemberQuarantineInfo extends StatefulWidget {
  final Member? qurantineData;
  final Permission mode;
  const MemberQuarantineInfo(
      {Key? key, this.qurantineData, this.mode = Permission.view})
      : super(key: key);

  @override
  _MemberQuarantineInfoState createState() => _MemberQuarantineInfoState();
}

class _MemberQuarantineInfoState extends State<MemberQuarantineInfo> {
  final _formKey = GlobalKey<FormState>();
  bool _isPositiveTestedBefore = false;
  final quarantineRoomController = TextEditingController();
  final quarantineFloorController = TextEditingController();
  final quarantineBuildingController = TextEditingController();
  final quarantineWardController = TextEditingController();
  final labelController = TextEditingController();
  final quarantinedAtController = TextEditingController();
  final backgroundDiseaseController = TextEditingController();
  final otherBackgroundDiseaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    quarantineRoomController.text = widget.qurantineData?.quarantineRoom != null
        ? widget.qurantineData?.quarantineRoom['name']
        : "";
    quarantineFloorController.text =
        widget.qurantineData?.quarantineFloor != null
            ? widget.qurantineData?.quarantineFloor['name']
            : "";
    quarantineBuildingController.text =
        widget.qurantineData?.quarantineBuilding != null
            ? widget.qurantineData?.quarantineBuilding['name']
            : "";
    quarantineWardController.text = widget.qurantineData?.quarantineWard != null
        ? widget.qurantineData?.quarantineWard['full_name']
        : "";
    labelController.text = widget.qurantineData?.label ?? "";
    quarantinedAtController.text = widget.qurantineData?.quarantinedAt ?? "";
    backgroundDiseaseController.text =
        widget.qurantineData?.backgroundDisease ?? "";
    otherBackgroundDiseaseController.text =
        widget.qurantineData?.otherBackgroundDisease ?? "";
    _isPositiveTestedBefore =
        widget.qurantineData?.positiveTestedBefore ?? _isPositiveTestedBefore;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownInput(
              label: 'Khu cách ly',
              hint: 'Chọn khu cách ly',
              itemValue: ['KTX Khu A'],
              required: widget.mode == Permission.view ? false : true,
              selectedItem: quarantineWardController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Tòa',
              hint: 'Chọn tòa',
              itemValue: ["1"],
              selectedItem: quarantineBuildingController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Tầng',
              hint: 'Chọn tầng',
              itemValue: ["1"],
              selectedItem: quarantineFloorController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Phòng',
              hint: 'Chọn phòng',
              itemValue: ["1"],
              selectedItem: quarantineRoomController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DropdownInput(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: ["F1", "F2", "F3", "Về từ vùng dịch", "Nhập cảnh"],
              selectedItem: labelController.text,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            DateInput(
              label: 'Thời gian bắt đầu cách ly',
              controller: quarantinedAtController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Lịch sử di chuyển',
              maxLines: 4,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Row(
              children: [
                Checkbox(
                    value: _isPositiveTestedBefore,
                    onChanged: (value) => {
                          (widget.mode == Permission.edit ||
                                  widget.mode == Permission.add)
                              ? setState(() {
                                  _isPositiveTestedBefore = value!;
                                })
                              : null
                        }),
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
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            Input(
              label: 'Bệnh nền khác',
              controller: otherBackgroundDiseaseController,
              enabled: (widget.mode == Permission.edit ||
                      widget.mode == Permission.add)
                  ? true
                  : false,
            ),
            if (widget.mode != Permission.view)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text("* Thông tin bắt buộc"),
              ),
            if (widget.mode == Permission.edit || widget.mode == Permission.add)
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Lưu"),
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
