import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
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

  const AddRoomScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
    this.currentFloor,
  }) : super(key: key);

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  late Future<dynamic> futureRoomList;

  @override
  void initState() {
    super.initState();
    futureRoomList =
        fetchNumOfRoom({'quarantine_floor': widget.currentFloor!.id});

    myController.addListener(_updateLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final capacityController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (addMultiple == true) {
        nameController.text = nameList.join(",");
        capacityController.text = capacityList.join(",");
      }
      final CancelFunc cancel = showLoading();
      final response = await createRoom(createRoomDataForm(
        name: nameController.text,
        quarantineFloor: widget.currentFloor!.id,
        capacity: capacityController.text,
      ));
      cancel();
      showNotification(response);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool addMultiple = false;
  int numOfAddedRoom = 1;
  List<String> nameList = [];
  List<String> capacityList = [];

  final myController = TextEditingController();

  void _updateLatestValue() {
    setState(() {
      numOfAddedRoom = int.tryParse(myController.text) ?? 1;
      nameList = []..length = numOfAddedRoom;
      capacityList = []..length = numOfAddedRoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Thêm phòng'),
      centerTitle: true,
    );

    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: futureRoomList,
              builder: (context, snapshot) {
                showLoading();
                if (snapshot.connectionState == ConnectionState.done) {
                  BotToast.closeAllLoading();
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
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
                        SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Add multiple floors
                                Container(
                                  margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 55,
                                        child: ListTileTheme(
                                          contentPadding: EdgeInsets.zero,
                                          child: CheckboxListTile(
                                            title:
                                                const Text("Thêm nhiều phòng"),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: addMultiple,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                addMultiple = value!;
                                                nameController.text = "";
                                                capacityController.text = "";
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      // insert number of floor
                                      if (addMultiple)
                                        Expanded(
                                          flex: 45,
                                          child: Input(
                                            label: 'Số phòng',
                                            hint: 'Số phòng',
                                            type: TextInputType.number,
                                            required: true,
                                            controller: myController,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: const Text(
                                    'Chỉnh sửa thông tin phòng',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                if (addMultiple)
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, index) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            flex: 55,
                                            child: Input(
                                              label: 'Tên phòng',
                                              hint: 'Tên phòng',
                                              required: true,
                                              onChangedFunction: (text) {
                                                nameList[index] = text;
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 45,
                                            child: Input(
                                              label: 'Số người tối đa',
                                              hint: 'Số người tối đa',
                                              required: true,
                                              type: TextInputType.number,
                                              onChangedFunction: (text) {
                                                capacityList[index] = text;
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: numOfAddedRoom,
                                  )
                                else
                                  Row(
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
                                          label: 'Số người tối đa',
                                          hint: 'Số người tối đa',
                                          required: true,
                                          type: TextInputType.number,
                                          controller: capacityController,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Spacer(),
                              ElevatedButton(
                                onPressed: _submit,
                                child: const Text("Xác nhận"),
                              ),
                              const Spacer(),
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
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
