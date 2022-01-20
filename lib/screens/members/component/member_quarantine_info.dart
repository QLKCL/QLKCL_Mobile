import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:intl/intl.dart';

class MemberQuarantineInfo extends StatefulWidget {
  final Member? quarantineData;
  final KeyValue? quarantineWard;
  final KeyValue? quarantineBuilding;
  final KeyValue? quarantineFloor;
  final KeyValue? quarantineRoom;

  final Permission mode;
  const MemberQuarantineInfo({
    Key? key,
    this.quarantineData,
    this.mode = Permission.edit,
    this.quarantineWard,
    this.quarantineBuilding,
    this.quarantineFloor,
    this.quarantineRoom,
  }) : super(key: key);

  @override
  _MemberQuarantineInfoState createState() => _MemberQuarantineInfoState();
}

class _MemberQuarantineInfoState extends State<MemberQuarantineInfo>
    with AutomaticKeepAliveClientMixin<MemberQuarantineInfo> {
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

  List<KeyValue> quarantineWardList = [];
  List<KeyValue> quarantineBuildingList = [];
  List<KeyValue> quarantineFloorList = [];
  List<KeyValue> quarantineRoomList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (widget.mode == Permission.add) {
      quarantineRoomController.text = widget.quarantineRoom != null
          ? widget.quarantineRoom!.id.toString()
          : "";
      quarantineFloorController.text = widget.quarantineFloor != null
          ? widget.quarantineRoom!.id.toString()
          : "";
      quarantineBuildingController.text = widget.quarantineBuilding != null
          ? widget.quarantineRoom!.id.toString()
          : "";
      quarantineWardController.text = widget.quarantineWard != null
          ? widget.quarantineRoom!.id.toString()
          : "";
      backgroundDiseaseController.text = "";
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
      quarantinedAtController.text =
          widget.quarantineData?.quarantinedAt != null
              ? DateFormat("dd/MM/yyyy")
                  .format(DateTime.parse(widget.quarantineData?.quarantinedAt))
              : "";
      backgroundDiseaseController.text =
          widget.quarantineData?.backgroundDisease ?? "";
      otherBackgroundDiseaseController.text =
          widget.quarantineData?.otherBackgroundDisease ?? "";
      _isPositiveTestedBefore = widget.quarantineData?.positiveTestedBefore ??
          _isPositiveTestedBefore;
    }
    super.initState();
    fetchQuarantineWard({
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineWardList = value;
        }));
    fetchQuarantineBuilding({
      'quarantine_ward': quarantineWardController.text,
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineBuildingList = value;
        }));
    fetchQuarantineFloor({
      'quarantine_building': quarantineBuildingController.text,
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineFloorList = value;
        }));
    fetchQuarantineRoom({
      'quarantine_floor': quarantineFloorController.text,
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineRoomList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              onFind: quarantineWardList.length == 0
                  ? (String? filter) => fetchQuarantineWard({
                        'page_size': PAGE_SIZE_MAX,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineWardList,
              selectedItem: widget.quarantineWard ??
                  (quarantineWardList.length == 0
                      ? ((widget.quarantineData?.quarantineWard != null)
                          ? KeyValue.fromJson(
                              widget.quarantineData!.quarantineWard)
                          : null)
                      : quarantineWardList.safeFirstWhere((type) =>
                          type.id.toString() == quarantineWardController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    quarantineWardController.text = "";
                  } else {
                    quarantineWardController.text = value.id.toString();
                  }
                  quarantineBuildingController.clear();
                  quarantineFloorController.clear();
                  quarantineRoomController.clear();
                  quarantineBuildingList = [];
                  quarantineFloorList = [];
                  quarantineRoomList = [];
                });
                fetchQuarantineBuilding({
                  'quarantine_ward': quarantineWardController.text,
                  'page_size': PAGE_SIZE_MAX,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineBuildingList = data;
                    }));
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tòa',
              hint: 'Chọn tòa',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineBuildingList.length == 0
                  ? (String? filter) => fetchQuarantineBuilding({
                        'quarantine_ward': quarantineWardController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineBuildingList,
              selectedItem: widget.quarantineBuilding ??
                  (quarantineBuildingList.length == 0
                      ? ((widget.quarantineData?.quarantineBuilding != null)
                          ? KeyValue.fromJson(
                              widget.quarantineData!.quarantineBuilding)
                          : null)
                      : quarantineBuildingList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          quarantineBuildingController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    quarantineBuildingController.text = "";
                  } else {
                    quarantineBuildingController.text = value.id.toString();
                  }
                  quarantineFloorController.clear();
                  quarantineRoomController.clear();
                  quarantineFloorList = [];
                  quarantineRoomList = [];
                });
                fetchQuarantineFloor({
                  'quarantine_building': quarantineBuildingController.text,
                  'page_size': PAGE_SIZE_MAX,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineFloorList = data;
                    }));
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Tầng',
              hint: 'Chọn tầng',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineFloorList.length == 0
                  ? (String? filter) => fetchQuarantineFloor({
                        'quarantine_building':
                            quarantineBuildingController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineFloorList,
              selectedItem: widget.quarantineFloor ??
                  (quarantineFloorList.length == 0
                      ? ((widget.quarantineData?.quarantineFloor != null)
                          ? KeyValue.fromJson(
                              widget.quarantineData!.quarantineFloor)
                          : null)
                      : quarantineFloorList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          quarantineFloorController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    quarantineFloorController.text = "";
                  } else {
                    quarantineFloorController.text = value.id.toString();
                  }
                  quarantineRoomController.clear();
                  quarantineRoomList = [];
                });
                fetchQuarantineRoom({
                  'quarantine_floor': quarantineFloorController.text,
                  'page_size': PAGE_SIZE_MAX,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineRoomList = data;
                    }));
              },
              enabled: widget.mode != Permission.view ? true : false,
              // showSearchBox: true,
            ),
            DropdownInput<KeyValue>(
              label: 'Phòng',
              hint: 'Chọn phòng',
              required: widget.mode == Permission.view ? false : true,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineRoomList.length == 0
                  ? (String? filter) => fetchQuarantineRoom({
                        'quarantine_floor': quarantineFloorController.text,
                        'page_size': PAGE_SIZE_MAX,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineRoomList,
              selectedItem: widget.quarantineRoom ??
                  ((widget.quarantineData?.quarantineRoom != null)
                      ? KeyValue.fromJson(widget.quarantineData!.quarantineRoom)
                      : quarantineRoomList.safeFirstWhere((type) =>
                          type.id.toString() == quarantineRoomController.text)),
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
            DropdownInput<KeyValue>(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: labelList,
              mode: Mode.MENU,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              selectedItem: labelList
                  .safeFirstWhere((label) => label.id == labelController.text),
              onChanged: (value) {
                if (value == null) {
                  labelController.text = "";
                } else {
                  labelController.text = value.toString();
                }
              },
              enabled: widget.mode != Permission.view ? true : false,
            ),
            NewDateInput(
              label: 'Thời gian bắt đầu cách ly',
              controller: quarantinedAtController,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            Input(
              label: 'Lịch sử di chuyển',
              maxLines: 4,
              enabled: widget.mode != Permission.view ? true : false,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTileTheme(
                  contentPadding: EdgeInsets.only(left: 8),
                  child: CheckboxListTile(
                    title: Text("Đã từng nhiễm COVID-19"),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isPositiveTestedBefore,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPositiveTestedBefore = value!;
                      });
                    },
                  ),
                ),
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
                      .map((e) => backgroundDiseaseList.safeFirstWhere(
                          (result) => result.id == int.parse(e))!)
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
              maxHeight: MediaQuery.of(context).size.height - 100,
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
                child: Row(
                  children: [
                    Text(
                      '(*)',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.error,
                      ),
                    ),
                    Text(
                      ' Thông tin bắt buộc',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.mode != Permission.view)
              Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(children: [
                    if (widget.mode == Permission.change_status &&
                        widget.quarantineData?.customUserCode != null)
                      Spacer(),
                    if (widget.mode == Permission.change_status &&
                        widget.quarantineData?.customUserCode != null)
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
      final updateResponse = await updateMember(updateMemberDataForm(
        code: (widget.mode == Permission.add &&
                MemberPersonalInfo.userCode != null)
            ? MemberPersonalInfo.userCode
            : ((widget.quarantineData != null &&
                    widget.quarantineData?.customUserCode != null)
                ? widget.quarantineData!.customUserCode.toString()
                : ""),
        quarantineWard: quarantineWardController.text,
        quarantineRoom: quarantineRoomController.text,
        label: labelController.text,
        quarantinedAt:
            parseDateToDateTimeWithTimeZone(quarantinedAtController.text),
        positiveBefore: _isPositiveTestedBefore,
        backgroundDisease: backgroundDiseaseController.text,
        otherBackgroundDisease: otherBackgroundDiseaseController.text,
      ));
      if (updateResponse.success) {
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
            SnackBar(content: Text(updateResponse.message)),
          );
        }
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(updateResponse.message)),
        );
      }
    }
  }
}

Widget _customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  if (selectedItems.isEmpty) {
    return Text(
      "Chọn bệnh nền",
      style: TextStyle(fontSize: 16),
    );
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
