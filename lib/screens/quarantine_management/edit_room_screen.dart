import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_room.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

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

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final registerResponse = await updateRoom(updateRoomDataForm(
        name: nameController.text,
        id: widget.currentRoom!.id,
        quarantineFloor: widget.currentFloor!.id,
        capacity: int.parse(capacityController.text),
      ));

      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerResponse.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin phòng'),
      centerTitle: true,
    );
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.65,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(color: CustomColors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
