import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  late MemberShareDataState state;

  bool _isPositiveTestedBefore = false;

  List<KeyValue> quarantineWardList = [];
  List<KeyValue> quarantineBuildingList = [];
  List<KeyValue> quarantineFloorList = [];
  List<KeyValue> quarantineRoomList = [];

  KeyValue? initQuarantineWard;
  KeyValue? initQuarantineBuilding;
  KeyValue? initQuarantineFloor;
  KeyValue? initQuarantineRoom;

  int _role = 5;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = MemberShareData.of(context);
    getRole().then((value) => setState(() {
          _role = value;
        }));
    if (widget.mode == Permission.add) {
      state.quarantineRoomController.text = widget.quarantineRoom != null
          ? widget.quarantineRoom!.id.toString()
          : "";
      state.quarantineFloorController.text = widget.quarantineFloor != null
          ? widget.quarantineFloor!.id.toString()
          : "";
      state.quarantineBuildingController.text =
          widget.quarantineBuilding != null
              ? widget.quarantineBuilding!.id.toString()
              : "";
      state.quarantineWardController.text = widget.quarantineWard != null
          ? widget.quarantineWard!.id.toString()
          : "";
      state.backgroundDiseaseController.text = "";
      getQuarantineWard().then((val) {
        state.quarantineWardController.text = "$val";
      });
    } else {
      state.quarantineRoomController.text =
          widget.quarantineData?.quarantineRoom != null
              ? widget.quarantineData!.quarantineRoom['id'].toString()
              : "";
      state.quarantineFloorController.text =
          widget.quarantineData?.quarantineFloor != null
              ? widget.quarantineData!.quarantineFloor['id'].toString()
              : "";
      state.quarantineBuildingController.text =
          widget.quarantineData?.quarantineBuilding != null
              ? widget.quarantineData!.quarantineBuilding['id'].toString()
              : "";
      state.quarantineWardController.text =
          widget.quarantineData?.quarantineWard != null
              ? widget.quarantineData!.quarantineWard!.id.toString()
              : "";
      state.labelController.text = widget.quarantineData?.label ?? "";
      state.quarantinedAtController.text =
          widget.quarantineData?.quarantinedAt != null
              ? DateFormat("dd/MM/yyyy")
                  .format(DateTime.parse(widget.quarantineData?.quarantinedAt))
              : "";
      state.quarantinedFinishExpectedAtController.text =
          widget.quarantineData?.quarantinedFinishExpectedAt != null
              ? DateFormat("dd/MM/yyyy").format(DateTime.parse(
                  widget.quarantineData?.quarantinedFinishExpectedAt))
              : "";
      state.backgroundDiseaseController.text =
          widget.quarantineData?.backgroundDisease ?? "";
      state.otherBackgroundDiseaseController.text =
          widget.quarantineData?.otherBackgroundDisease ?? "";
      state.positiveTestNowController.text =
          widget.quarantineData?.positiveTest.toString() ?? "";
      _isPositiveTestedBefore = widget.quarantineData?.positiveTestedBefore ??
          _isPositiveTestedBefore;

      initQuarantineWard = widget.quarantineData?.quarantineWard;
      initQuarantineBuilding =
          (widget.quarantineData?.quarantineBuilding != null)
              ? KeyValue.fromJson(widget.quarantineData?.quarantineBuilding)
              : null;
      initQuarantineFloor = (widget.quarantineData?.quarantineFloor != null)
          ? KeyValue.fromJson(widget.quarantineData?.quarantineFloor)
          : null;
      initQuarantineRoom = (widget.quarantineData?.quarantineRoom != null)
          ? KeyValue.fromJson(widget.quarantineData?.quarantineRoom)
          : null;
    }
    fetchQuarantineWard({
      'page_size': pageSizeMax,
      'is_full': false,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineWardList = value;
        });
      }
    });
    fetchQuarantineBuilding({
      'quarantine_ward': state.quarantineWardController.text,
      'page_size': pageSizeMax,
      'is_full': false,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineBuildingList = value;
        });
      }
    });
    fetchQuarantineFloor({
      'quarantine_building': state.quarantineBuildingController.text,
      'page_size': pageSizeMax,
      'is_full': false,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineFloorList = value;
        });
      }
    });
    fetchQuarantineRoom({
      'quarantine_floor': state.quarantineFloorController.text,
      'page_size': pageSizeMax,
      'is_full': false,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineRoomList = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      controller: ScrollController(),
      primary: false,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownInput<KeyValue>(
              label: 'Khu cách ly',
              hint: 'Chọn khu cách ly',
              required: widget.mode != Permission.view && _role != 5,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineWardList.isEmpty
                  ? (String? filter) => fetchQuarantineWard({
                        'page_size': pageSizeMax,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineWardList,
              selectedItem: widget.quarantineWard ??
                  (initQuarantineWard ??
                      quarantineWardList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          state.quarantineWardController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    state.quarantineWardController.text = "";
                  } else {
                    state.quarantineWardController.text = value.id.toString();
                  }
                  state.quarantineBuildingController.clear();
                  state.quarantineFloorController.clear();
                  state.quarantineRoomController.clear();
                  quarantineBuildingList = [];
                  quarantineFloorList = [];
                  quarantineRoomList = [];
                  initQuarantineWard = null;
                  initQuarantineBuilding = null;
                  initQuarantineFloor = null;
                  initQuarantineRoom = null;
                });
                fetchQuarantineBuilding({
                  'quarantine_ward': state.quarantineWardController.text,
                  'page_size': pageSizeMax,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineBuildingList = data;
                    }));
              },
              enabled: widget.mode == Permission.add && _role != 5,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Khu cách ly',
            ),
            DropdownInput<KeyValue>(
              label: 'Tòa',
              hint: 'Chọn tòa',
              required: widget.mode != Permission.view &&
                  widget.mode != Permission.changeStatus &&
                  _role != 5,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineBuildingList.isEmpty
                  ? (String? filter) => fetchQuarantineBuilding({
                        'quarantine_ward': state.quarantineWardController.text,
                        'page_size': pageSizeMax,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineBuildingList,
              selectedItem: widget.quarantineBuilding ??
                  (initQuarantineBuilding ??
                      quarantineBuildingList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          state.quarantineBuildingController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    state.quarantineBuildingController.text = "";
                  } else {
                    state.quarantineBuildingController.text =
                        value.id.toString();
                  }
                  state.quarantineFloorController.clear();
                  state.quarantineRoomController.clear();
                  quarantineFloorList = [];
                  quarantineRoomList = [];
                  initQuarantineBuilding = null;
                  initQuarantineFloor = null;
                  initQuarantineRoom = null;
                });
                fetchQuarantineFloor({
                  'quarantine_building':
                      state.quarantineBuildingController.text,
                  'page_size': pageSizeMax,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineFloorList = data;
                    }));
              },
              enabled: widget.mode != Permission.view && _role != 5,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Tòa',
            ),
            DropdownInput<KeyValue>(
              label: 'Tầng',
              hint: 'Chọn tầng',
              required: widget.mode != Permission.view &&
                  widget.mode != Permission.changeStatus &&
                  _role != 5,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineFloorList.isEmpty
                  ? (String? filter) => fetchQuarantineFloor({
                        'quarantine_building':
                            state.quarantineBuildingController.text,
                        'page_size': pageSizeMax,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineFloorList,
              selectedItem: widget.quarantineFloor ??
                  (initQuarantineFloor ??
                      quarantineFloorList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          state.quarantineFloorController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    state.quarantineFloorController.text = "";
                  } else {
                    state.quarantineFloorController.text = value.id.toString();
                  }
                  state.quarantineRoomController.clear();
                  quarantineRoomList = [];
                  initQuarantineFloor = null;
                  initQuarantineRoom = null;
                });
                fetchQuarantineRoom({
                  'quarantine_floor': state.quarantineFloorController.text,
                  'page_size': pageSizeMax,
                  'is_full': false,
                }).then((data) => setState(() {
                      quarantineRoomList = data;
                    }));
              },
              enabled: widget.mode != Permission.view && _role != 5,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Tầng',
            ),
            DropdownInput<KeyValue>(
              label: 'Phòng',
              hint: 'Chọn phòng',
              required: widget.mode != Permission.view &&
                  widget.mode != Permission.changeStatus &&
                  _role != 5,
              itemAsString: (KeyValue? u) => u!.name,
              onFind: quarantineRoomList.isEmpty
                  ? (String? filter) => fetchQuarantineRoom({
                        'quarantine_floor':
                            state.quarantineFloorController.text,
                        'page_size': pageSizeMax,
                        'search': filter,
                        'is_full': false,
                      })
                  : null,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemValue: quarantineRoomList,
              selectedItem: widget.quarantineRoom ??
                  (initQuarantineRoom ??
                      quarantineRoomList.safeFirstWhere((type) =>
                          type.id.toString() ==
                          state.quarantineRoomController.text)),
              onChanged: (value) {
                setState(() {
                  if (value == null) {
                    state.quarantineRoomController.text = "";
                  } else {
                    state.quarantineRoomController.text = value.id.toString();
                  }
                  initQuarantineRoom = null;
                });
              },
              enabled: widget.mode != Permission.view && _role != 5,
              showSearchBox: true,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Phòng',
            ),
            DropdownInput<KeyValue>(
              label: 'Diện cách ly',
              hint: 'Chọn diện cách ly',
              itemValue: labelList,
              compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
              itemAsString: (KeyValue? u) => u!.name,
              selectedItem: labelList.safeFirstWhere(
                  (label) => label.id == state.labelController.text),
              onChanged: (value) {
                if (value == null) {
                  state.labelController.text = "";
                } else {
                  state.labelController.text = value.id.toString();
                }
              },
              enabled: widget.mode == Permission.add ||
                  (widget.mode == Permission.edit &&
                      (_role != 5 || state.labelController.text == "")),
            ),
            NewDateInput(
              label: 'Thời gian bắt đầu cách ly',
              controller: state.quarantinedAtController,
              enabled: widget.mode != Permission.view && _role != 5,
            ),
            NewDateInput(
              label: 'Thời gian dự kiến hoàn thành cách ly',
              controller: state.quarantinedFinishExpectedAtController,
              enabled: widget.mode != Permission.view && _role != 5,
            ),
            Input(
              label: "Tình trạng bệnh",
              initValue: testValueWithBoolList
                  .safeFirstWhere((result) =>
                      result.id ==
                      state.positiveTestNowController.text.capitalize())
                  ?.name,
              enabled: false,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTileTheme(
                  contentPadding: const EdgeInsets.only(left: 8),
                  child: CheckboxListTile(
                    title: const Text("Đã từng nhiễm COVID-19"),
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
              dropdownBuilder: customDropDown,
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
                  state.backgroundDiseaseController.text = "";
                } else {
                  state.backgroundDiseaseController.text =
                      value.map((e) => e.id).join(",");
                }
              },
              enabled: widget.mode != Permission.view,
              mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                  ? Mode.DIALOG
                  : Mode.BOTTOM_SHEET,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
              popupTitle: 'Bệnh nền',
            ),
            Input(
              label: 'Bệnh nền khác',
              controller: state.otherBackgroundDiseaseController,
              enabled: widget.mode != Permission.view,
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
                        color: error,
                      ),
                    ),
                    const Text(
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
                    if (widget.mode == Permission.changeStatus &&
                        widget.quarantineData?.customUserCode != null)
                      const Spacer(),
                    if (widget.mode == Permission.changeStatus &&
                        widget.quarantineData?.customUserCode != null)
                      OutlinedButton(
                        onPressed: () async {
                          final CancelFunc cancel = showLoading();
                          final response = await denyMember({
                            'member_codes':
                                widget.quarantineData!.customUserCode.toString()
                          });
                          cancel();
                          showNotification(response);
                        },
                        child: const Text("Từ chối"),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _submit,
                      child: widget.mode == Permission.changeStatus
                          ? const Text("Xét duyệt")
                          : const Text('Lưu'),
                    ),
                    const Spacer(),
                  ])),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      if (widget.mode == Permission.changeStatus) {
        final CancelFunc cancel = showLoading();
        final response = await acceptOneMember(acceptOneMemberDataForm(
          code: widget.quarantineData!.customUserCode.toString(),
          quarantineRoom: state.quarantineRoomController.text,
          quarantinedAt: parseDateToDateTimeWithTimeZone(
              state.quarantinedAtController.text),
        ));
        cancel();
        showNotification(response);
      } else {
        final CancelFunc cancel = showLoading();
        final updateResponse = await updateMember(updateMemberDataForm(
          code: (widget.mode == Permission.add &&
                  MemberPersonalInfo.userCode != null &&
                  MemberPersonalInfo.userCode != "")
              ? MemberPersonalInfo.userCode!
              : ((widget.quarantineData != null &&
                      widget.quarantineData?.customUserCode != null)
                  ? widget.quarantineData!.customUserCode.toString()
                  : ""),
          quarantineWard: state.quarantineWardController.text,
          quarantineRoom: state.quarantineRoomController.text,
          label: state.labelController.text,
          quarantinedAt: parseDateToDateTimeWithTimeZone(
              state.quarantinedAtController.text),
          quarantinedFinishExpectedAt: parseDateToDateTimeWithTimeZone(
              state.quarantinedFinishExpectedAtController.text),
          positiveBefore: _isPositiveTestedBefore,
          backgroundDisease: state.backgroundDiseaseController.text,
          otherBackgroundDisease: state.otherBackgroundDiseaseController.text,
        ));
        cancel();
        showNotification(updateResponse);
      }
    }
  }
}
