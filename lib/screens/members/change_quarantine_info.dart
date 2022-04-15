import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ChangeQuanrantineInfo extends StatefulWidget {
  static const String routeName = "/change_room_member";
  final String code;
  final KeyValue? quarantineWard;

  const ChangeQuanrantineInfo({
    Key? key,
    required this.code,
    this.quarantineWard,
  }) : super(key: key);

  @override
  State<ChangeQuanrantineInfo> createState() => _ChangeQuanrantineInfoState();
}

class _ChangeQuanrantineInfoState extends State<ChangeQuanrantineInfo> {
  final _formKey = GlobalKey<FormState>();
  late Member? quarantineData;

  final newQuarantineRoomController = TextEditingController();
  final newQuarantineFloorController = TextEditingController();
  final newQuarantineBuildingController = TextEditingController();
  final newQuarantineWardController = TextEditingController();

  List<KeyValue> quarantineWardList = [];
  List<KeyValue> quarantineBuildingList = [];
  List<KeyValue> quarantineFloorList = [];
  List<KeyValue> quarantineRoomList = [];

  KeyValue? initQuarantineWard;

  @override
  void initState() {
    if (widget.quarantineWard != null) {
      newQuarantineWardController.text = widget.quarantineWard!.id.toString();
      initQuarantineWard = widget.quarantineWard;
    } else {
      showLoading();
      fetchUser(data: {'code': widget.code}).then((value) => {
            setState(() {
              BotToast.closeAllLoading();
              quarantineData = value["member"] != null
                  ? Member.fromJson(value["member"])
                  : null;
              if (quarantineData != null) {
                quarantineData!.quarantineWard =
                    value["custom_user"]['quarantine_ward'];
              }

              newQuarantineWardController.text =
                  quarantineData?.quarantineWard != null
                      ? quarantineData!.quarantineWard!.id.toString()
                      : "";
              initQuarantineWard = quarantineData?.quarantineWard;
            })
          });
    }
    super.initState();
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
      'quarantine_ward': newQuarantineWardController.text,
      'page_size': pageSizeMax,
      'is_full': false,
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineBuildingList = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chuyển phòng"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownInput<KeyValue>(
                  label: 'Khu cách ly mới',
                  hint: 'Chọn khu cách ly mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineWardList.isEmpty
                      ? (String? filter) => fetchQuarantineWard({
                            'page_size': pageSizeMax,
                            'is_full': false,
                          })
                      : null,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemValue: quarantineWardList,
                  selectedItem: widget.quarantineWard ??
                      (initQuarantineWard ??
                          quarantineWardList.safeFirstWhere((type) =>
                              type.id.toString() ==
                              newQuarantineWardController.text)),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        newQuarantineWardController.text = "";
                      } else {
                        newQuarantineWardController.text = value.id.toString();
                      }
                      newQuarantineBuildingController.clear();
                      newQuarantineFloorController.clear();
                      newQuarantineRoomController.clear();
                      quarantineBuildingList = [];
                      quarantineFloorList = [];
                      quarantineRoomList = [];
                      initQuarantineWard = null;
                    });
                    if (newQuarantineWardController.text != "") {
                      fetchQuarantineBuilding({
                        'quarantine_ward': newQuarantineWardController.text,
                        'page_size': pageSizeMax,
                        'is_full': false,
                      }).then((data) => setState(() {
                            quarantineBuildingList = data;
                          }));
                    }
                  },
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
                  label: 'Tòa mới',
                  hint: 'Chọn tòa mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineBuildingList.isEmpty &&
                          newQuarantineWardController.text != ""
                      ? (String? filter) => fetchQuarantineBuilding({
                            'quarantine_ward': newQuarantineWardController.text,
                            'page_size': pageSizeMax,
                            'search': filter,
                            'is_full': false,
                          })
                      : null,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemValue: quarantineBuildingList,
                  selectedItem: quarantineBuildingList.safeFirstWhere((type) =>
                      type.id.toString() ==
                      newQuarantineBuildingController.text),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        newQuarantineBuildingController.text = "";
                      } else {
                        newQuarantineBuildingController.text =
                            value.id.toString();
                      }
                      newQuarantineFloorController.clear();
                      newQuarantineRoomController.clear();
                      quarantineFloorList = [];
                      quarantineRoomList = [];
                    });
                    if (newQuarantineBuildingController.text != "") {
                      fetchQuarantineFloor({
                        'quarantine_building_id_list':
                            newQuarantineBuildingController.text,
                        'page_size': pageSizeMax,
                        'is_full': false,
                      }).then((data) => setState(() {
                            quarantineFloorList = data;
                          }));
                    }
                  },
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
                  label: 'Tầng mới',
                  hint: 'Chọn tầng mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineFloorList.isEmpty &&
                          newQuarantineBuildingController.text != ""
                      ? (String? filter) => fetchQuarantineFloor({
                            'quarantine_building_id_list':
                                newQuarantineBuildingController.text,
                            'page_size': pageSizeMax,
                            'search': filter,
                            'is_full': false,
                          })
                      : null,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemValue: quarantineFloorList,
                  selectedItem: quarantineFloorList.safeFirstWhere((type) =>
                      type.id.toString() == newQuarantineFloorController.text),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        newQuarantineFloorController.text = "";
                      } else {
                        newQuarantineFloorController.text = value.id.toString();
                      }
                      newQuarantineRoomController.clear();
                      quarantineRoomList = [];
                    });
                    if (newQuarantineFloorController.text != "") {
                      fetchQuarantineRoom({
                        'quarantine_floor': newQuarantineFloorController.text,
                        'page_size': pageSizeMax,
                        'is_full': false,
                      }).then((data) => setState(() {
                            quarantineRoomList = data;
                          }));
                    }
                  },
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
                  label: 'Phòng mới',
                  hint: 'Chọn phòng mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineRoomList.isEmpty &&
                          newQuarantineFloorController.text != ""
                      ? (String? filter) => fetchQuarantineRoom({
                            'quarantine_floor':
                                newQuarantineFloorController.text,
                            'page_size': pageSizeMax,
                            'search': filter,
                            'is_full': false,
                          })
                      : null,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  itemValue: quarantineRoomList,
                  selectedItem: quarantineRoomList.safeFirstWhere((type) =>
                      type.id.toString() == newQuarantineRoomController.text),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        newQuarantineRoomController.text = "";
                      } else {
                        newQuarantineRoomController.text = value.id.toString();
                      }
                    });
                  },
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
                Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text(
                          'Xác nhận',
                        ),
                      ),
                      const Spacer(),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      final updateResponse = await changeRoomMember(changeRoomMemberDataForm(
        code: widget.code,
        quarantineWard: newQuarantineWardController.text,
        quarantineRoom: newQuarantineRoomController.text,
      ));
      cancel();
      showNotification(updateResponse);
    }
  }
}
