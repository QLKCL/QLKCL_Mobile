import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_floor.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

class EditFloorScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;
  const EditFloorScreen(
      {Key? key,
      this.currentBuilding,
      this.currentQuarantine,
      this.currentFloor})
      : super(key: key);
  static const routeName = '/editing-floor';

  @override
  _EditFloorScreenState createState() => _EditFloorScreenState();
}

class _EditFloorScreenState extends State<EditFloorScreen> {
  late Future<int> numOfRoom;

  @override
  void initState() {
    super.initState();
    numOfRoom = fetchNumOfRoom({'quarantine_floor': widget.currentFloor!.id});
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final registerResponse = await updateFloor(updateFloorDataForm(
        name: nameController.text,
        id: widget.currentFloor!.id,
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
      title: Text('Sửa thông tin tầng'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: numOfRoom,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                EasyLoading.dismiss();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.6,
                        child: Input(
                          label: 'Tên tầng mới',
                          hint: 'Tên tầng mới',
                          controller: nameController,
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
                );
              } else if (snapshot.hasError) {
                return Text('Snapshot has error');
              }
              EasyLoading.show();
              return Container();
            }),
      ),
    );
  }
}
