import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_room.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';

class EditRoomScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;
  final Room? currentRoom;
  const EditRoomScreen(
      {Key? key,
      this.currentBuilding,
      this.currentFloor,
      this.currentQuarantine,
      this.currentRoom})
      : super(key: key);
  static const routeName = '/editing-room';

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentRoom!.name;
    capacityController.text = widget.currentRoom!.capacity.toString();
  }

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
      var response = await updateRoom(updateRoomDataForm(
        name: nameController.text,
        id: widget.currentRoom!.id,
        quarantineFloor: widget.currentFloor!.id,
        capacity: int.parse(capacityController.text),
      ));

      cancel();
      showNotification(response);
      if (response.status == Status.success) {
        if (mounted) {
          Navigator.of(context).pop(response.data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text('Sửa thông tin phòng'),
      centerTitle: true,
    );
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.25,
                child: GeneralInfoRoom(
                  currentBuilding: widget.currentBuilding!,
                  currentFloor: widget.currentFloor!,
                  currentQuarantine: widget.currentQuarantine!,
                  currentRoom: widget.currentRoom!,
                ),
              ),
              Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Input(
                        label: 'Tên',
                        hint: 'Tên phòng mới',
                        required: true,
                        controller: nameController,
                      ),
                      Input(
                        label: 'Số người tối đa',
                        hint: 'Số người tối đa',
                        required: true,
                        type: TextInputType.number,
                        controller: capacityController,
                        validatorFunction: numberOfMemberValidator,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Xác nhận"),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
