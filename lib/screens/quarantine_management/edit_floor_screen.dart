import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_floor.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';

class EditFloorScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;
  const EditFloorScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
    this.currentFloor,
  }) : super(key: key);
  static const routeName = '/editing-floor';

  @override
  _EditFloorScreenState createState() => _EditFloorScreenState();
}

class _EditFloorScreenState extends State<EditFloorScreen> {
  late Future<int> numOfRoom;
  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    numOfRoom = fetchNumOfRoom({'quarantine_floor': widget.currentFloor!.id});
    nameController.text = widget.currentFloor!.name;
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
      final response = await updateFloor(updateFloorDataForm(
        name: nameController.text,
        id: widget.currentFloor!.id,
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
    final appBar = AppBar(
      title: const Text('Sửa thông tin tầng'),
      centerTitle: true,
    );
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: numOfRoom,
              builder: (context, snapshot) {
                showLoading();
                if (snapshot.connectionState == ConnectionState.done) {
                  BotToast.closeAllLoading();
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.25,
                          child: GeneralInfoFloor(
                            currentBuilding: widget.currentBuilding!,
                            currentQuarantine: widget.currentQuarantine!,
                            currentFloor: widget.currentFloor!,
                            numOfRoom: snapshot.data,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Input(
                              label: 'Tên tầng mới',
                              hint: 'Tên tầng mới',
                              controller: nameController,
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
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Snapshot has error');
                  } else {
                    return const Text(
                      'Không có dữ liệu',
                      textAlign: TextAlign.center,
                    );
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
