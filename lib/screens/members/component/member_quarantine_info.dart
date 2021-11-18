import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class MemberQuarantineInfo extends StatefulWidget {
  final Member? quarantineData;
  final Permission mode;
  const MemberQuarantineInfo(
      {Key? key, this.quarantineData, this.mode = Permission.view})
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
    if (widget.mode == Permission.add) {
      getQuarantineWard().then((val) {
        quarantineWardController.text = "$val";
      });
    } else {
      quarantineRoomController.text =
          widget.quarantineData?.quarantineRoom != null
              ? widget.quarantineData!.quarantineRoom['id'].toString()
              : "";
      quarantineFloorController.text =
          widget.quarantineData?.quarantineFloor != null
              ? widget.quarantineData!.quarantineFloor['id'].toString()
              : "";
      quarantineBuildingController.text =
          widget.quarantineData?.quarantineBuilding != null
              ? widget.quarantineData!.quarantineBuilding['id'].toString()
              : "";
      quarantineWardController.text =
          widget.quarantineData?.quarantineWard != null
              ? widget.quarantineData!.quarantineWard['id'].toString()
              : "";
      labelController.text = widget.quarantineData?.label ?? "";
      quarantinedAtController.text = widget.quarantineData?.quarantinedAt ?? "";
      backgroundDiseaseController.text =
          widget.quarantineData?.backgroundDisease ?? "";
      otherBackgroundDiseaseController.text =
          widget.quarantineData?.otherBackgroundDisease ?? "";
      _isPositiveTestedBefore = widget.quarantineData?.positiveTestedBefore ??
          _isPositiveTestedBefore;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownInput<KeyValue>(
              label: 'Khu cách ly',
              hint: 'Chọn khu cách ly',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: (String? filter) => fetchQuarantineWard({
                'page_size': PAGE_SIZE_MAX,
                'is_full': false,
              }),
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: (widget.quarantineData?.quarantineWard != null)
                  ? KeyValue.fromJson(widget.quarantineData!.quarantineWard)
                  : null,
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
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tòa',
              hint: 'Chọn tòa',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: (String? filter) => fetchQuarantineBuilding({
                'quarantine_ward': quarantineWardController.text,
                'page_size': PAGE_SIZE_MAX,
                'search': filter,
                'is_full': false,
              }),
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: (widget.quarantineData?.quarantineBuilding != null)
                  ? KeyValue.fromJson(widget.quarantineData!.quarantineBuilding)
                  : null,
              onChanged: (value) {
                if (value == null) {
                  quarantineBuildingController.text = "";
                } else {
                  quarantineBuildingController.text = value.id.toString();
                }
                quarantineFloorController.clear();
                quarantineRoomController.clear();
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tầng',
              hint: 'Chọn tầng',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: (String? filter) => fetchQuarantineFloor({
                'quarantine_building': quarantineBuildingController.text,
                'page_size': PAGE_SIZE_MAX,
                'search': filter,
                'is_full': false,
              }),
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: (widget.quarantineData?.quarantineFloor != null)
                  ? KeyValue.fromJson(widget.quarantineData!.quarantineFloor)
                  : null,
              onChanged: (value) {
                if (value == null) {
                  quarantineFloorController.text = "";
                } else {
                  quarantineFloorController.text = value.id.toString();
                }
                quarantineRoomController.clear();
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Phòng',
              hint: 'Chọn phòng',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: (String? filter) => fetchQuarantineRoom({
                'quarantine_floor': quarantineFloorController.text,
                'page_size': PAGE_SIZE_MAX,
                'search': filter,
                'is_full': false,
              }),
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              selectedItem: (widget.quarantineData?.quarantineFloor != null)
                  ? KeyValue.fromJson(widget.quarantineData!.quarantineFloor)
                  : null,
              onChanged: (value) {
                if (value == null) {
                  quarantineRoomController.text = "";
                } else {
                  quarantineRoomController.text = value.id.toString();
                }
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: ["F0", "F1", "F2", "F3"],
              onChanged: (value) {
                if (value == null) {
                  labelController.text = "";
                } else {
                  labelController.text = value.toString();
                }
              },
              selectedItem: labelController.text,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            DateInput(
              label: 'Thời gian bắt đầu cách ly',
              controller: quarantinedAtController,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            Input(
              label: 'Lịch sử di chuyển',
              maxLines: 4,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            Row(
              children: [
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Checkbox(
                      value: _isPositiveTestedBefore,
                      onChanged: (value) => {
                            widget.mode != Permission.view
                                ? setState(() {
                                    _isPositiveTestedBefore = value!;
                                  })
                                : null
                          });
                }),
                Text("Đã từng nhiễm COVID-19"),
              ],
            ),
            MultiDropdownInput<KeyValue>(
              label: 'Bệnh nền',
              hint: 'Chọn bệnh nền',
              itemValue: backgroundDiseaseList,
              mode: Mode.BOTTOM_SHEET,
              dropdownBuilder: _customDropDown,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              selectedItems: (widget.quarantineData?.backgroundDisease != null)
                  ? (widget.quarantineData!.backgroundDisease
                      .toString()
                      .split(',')
                      .map((e) => backgroundDiseaseList[int.parse(e)])
                      .toList())
                  : null,
              onChanged: (value) {
                if (value == null) {
                  backgroundDiseaseController.text = "";
                } else {
                  backgroundDiseaseController.text =
                      value.map((e) => e.id).join(",");
                }
              },
              enabled: widget.mode != Permission.view ? true : false,
              maxHeight: 700,
              popupTitle: 'Bệnh nền',
            ),
            Input(
              label: 'Bệnh nền khác',
              controller: otherBackgroundDiseaseController,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            if (widget.mode != Permission.view)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text("* Thông tin bắt buộc"),
              ),
            if (widget.mode != Permission.view)
              Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(children: [
                    if (widget.mode == Permission.change_status &&
                        widget.quarantineData?.customUser != null)
                      Spacer(),
                    if (widget.mode == Permission.change_status &&
                        widget.quarantineData?.customUser != null)
                      OutlinedButton(
                        onPressed: () async {
                          EasyLoading.show();
                          final response = await denyMember({
                            'member_codes':
                                widget.quarantineData!.customUserCode.toString()
                          });
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message)),
                          );
                        },
                        child: Text("Từ chối"),
                      ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: widget.mode == Permission.change_status
                          ? Text("Xét duyệt")
                          : Text('Lưu'),
                    ),
                    Spacer(),
                  ])),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final registerResponse = await updateMember(updateMemberDataForm(
        code: (widget.quarantineData != null &&
                widget.quarantineData?.customUser != null)
            ? widget.quarantineData!.customUserCode.toString()
            : "",
        quarantineWard: quarantineWardController.text,
        quarantineRoom: quarantineRoomController.text,
        label: labelController.text,
        quarantinedAt: quarantinedAtController.text,
        positiveBefore: _isPositiveTestedBefore,
        backgroundDisease: backgroundDiseaseController.text,
        otherBackgroundDisease: otherBackgroundDiseaseController.text,
      ));
      if (registerResponse.success) {
        if (widget.mode == Permission.change_status) {
          final response = await acceptMember({
            'member_codes': widget.quarantineData!.customUserCode.toString()
          });
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.message)));
        } else {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registerResponse.message)),
          );
        }
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(registerResponse.message)),
        );
      }
    }
  }
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  // if (selectedItems.isEmpty) {
  //   return Container();
  // }

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
