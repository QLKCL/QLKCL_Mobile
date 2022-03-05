import 'package:bot_toast/bot_toast.dart';
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
      fetchCustomUser(data: {'code': widget.code}).then((value) => {
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
                      ? quarantineData!.quarantineWard['id'].toString()
                      : "";
              initQuarantineWard = (quarantineData?.quarantineWard != null)
                  ? KeyValue.fromJson(quarantineData?.quarantineWard)
                  : null;
            })
          });
    }
    super.initState();
    fetchQuarantineWard({
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineWardList = value;
        }));
    fetchQuarantineBuilding({
      'quarantine_ward': newQuarantineWardController.text,
      'page_size': PAGE_SIZE_MAX,
      'is_full': false,
    }).then((value) => setState(() {
          quarantineBuildingList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chuyển phòng"),
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
                  onFind: quarantineWardList.length == 0
                      ? (String? filter) => fetchQuarantineWard({
                            'page_size': PAGE_SIZE_MAX,
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
                    fetchQuarantineBuilding({
                      'quarantine_ward': newQuarantineWardController.text,
                      'page_size': PAGE_SIZE_MAX,
                      'is_full': false,
                    }).then((data) => setState(() {
                          quarantineBuildingList = data;
                        }));
                  },
                ),
                DropdownInput<KeyValue>(
                  label: 'Tòa mới',
                  hint: 'Chọn tòa mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineBuildingList.length == 0
                      ? (String? filter) => fetchQuarantineBuilding({
                            'quarantine_ward': newQuarantineWardController.text,
                            'page_size': PAGE_SIZE_MAX,
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
                    fetchQuarantineFloor({
                      'quarantine_building':
                          newQuarantineBuildingController.text,
                      'page_size': PAGE_SIZE_MAX,
                      'is_full': false,
                    }).then((data) => setState(() {
                          quarantineFloorList = data;
                        }));
                  },
                ),
                DropdownInput<KeyValue>(
                  label: 'Tầng mới',
                  hint: 'Chọn tầng mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineFloorList.length == 0
                      ? (String? filter) => fetchQuarantineFloor({
                            'quarantine_building':
                                newQuarantineBuildingController.text,
                            'page_size': PAGE_SIZE_MAX,
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
                    fetchQuarantineRoom({
                      'quarantine_floor': newQuarantineFloorController.text,
                      'page_size': PAGE_SIZE_MAX,
                      'is_full': false,
                    }).then((data) => setState(() {
                          quarantineRoomList = data;
                        }));
                  },
                ),
                DropdownInput<KeyValue>(
                  label: 'Phòng mới',
                  hint: 'Chọn phòng mới',
                  required: true,
                  itemAsString: (KeyValue? u) => u!.name,
                  onFind: quarantineRoomList.length == 0
                      ? (String? filter) => fetchQuarantineRoom({
                            'quarantine_floor':
                                newQuarantineFloorController.text,
                            'page_size': PAGE_SIZE_MAX,
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
                ),
                Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Text(
                          'Xác nhận',
                        ),
                      ),
                      Spacer(),
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
      CancelFunc cancel = showLoading();
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
