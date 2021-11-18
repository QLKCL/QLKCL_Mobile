import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/utils/data_form.dart';

import 'component/general_info_floor.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = "/add-room";
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;
  final VoidCallback onGoBackRoomList;

  const AddRoomScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
    this.currentFloor,
    required this.onGoBackRoomList,
  }) : super(key: key);

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  late Future<dynamic> futureRoomList;

  @override
  void initState() {
    super.initState();

    // myController.addListener(_updateLatestValue);
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final capacityController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final registerResponse = await createRoom(createRoomDataForm(
        name: nameController.text,
        quarantineFloor: widget.currentFloor!.id,
        capacity: int.parse(capacityController.text),
      ));
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerResponse.message)),
      );
    }
    widget.onGoBackRoomList();
    Navigator.pop(context);
  }

  // bool addMultiple = false;
  // int numOfAddedRoom = 1;

  //final myController = TextEditingController();

  // void _updateLatestValue() {
  //   setState(() {
  //     numOfAddedRoom = int.parse(myController.text);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    futureRoomList =
        fetchNumOfRoom({'quarantine_floor': widget.currentFloor!.id});
    final appBar = AppBar(
      title: Text('Thêm phòng'),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureRoomList,
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
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      //Input fields
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Add multiple floors
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                              // child: Row(
                              //   children: [
                              //     Expanded(
                              //       flex: 55,
                              //       child: ListTileTheme(
                              //         contentPadding: EdgeInsets.all(0),
                              //         child: CheckboxListTile(
                              //           title: Text("Thêm nhiều phòng"),
                              //           controlAffinity:
                              //               ListTileControlAffinity.leading,
                              //           value: addMultiple,
                              //           onChanged: (bool? value) {
                              //             setState(() {
                              //               addMultiple = value!;
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //     ),
                              //     // insert number of floor
                              //     addMultiple
                              //         ? Expanded(
                              //             flex: 45,
                              //             child: Input(
                              //               label: 'Số phòng',
                              //               hint: 'Số phòng',
                              //               type: TextInputType.number,
                              //               required: true,
                              //               controller: myController,
                              //             ),
                              //           )
                              //         : Container(),
                              //   ],
                              // ),
                              // ),
                              // Container(
                              //   margin: EdgeInsets.symmetric(horizontal: 16),
                              //   child: const Text(
                              //     'Chỉnh sửa thông tin phòng',
                              //     style: TextStyle(fontSize: 16),
                              //   ),
                              // ),
                              //addMultiple
                              //    ?
                              // ListView.builder(
                              //     physics: NeverScrollableScrollPhysics(),
                              //     shrinkWrap: true,
                              //     itemBuilder: (ctx, index) {
                              //       return Row(
                              //         children: [
                              //           Expanded(
                              //             flex: 55,
                              //             child: Input(
                              //               label: 'Tên phòng',
                              //               hint: 'Tên phòng',
                              //               required: true,
                              //             ),
                              //           ),
                              //           Expanded(
                              //             flex: 45,
                              //             child: Input(
                              //               label: 'Người tối đa',
                              //               hint: 'Người tối đa',
                              //               required: true,
                              //               type: TextInputType.number,
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //     itemCount: numOfAddedRoom,
                              //   )
                              //:
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 55,
                                      child: Input(
                                        label: 'Tên phòng',
                                        hint: 'Tên phòng',
                                        required: true,
                                        controller: nameController,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 45,
                                      child: Input(
                                        label: 'Người tối đa',
                                        hint: 'Người tối đa',
                                        required: true,
                                        type: TextInputType.number,
                                        controller: capacityController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
