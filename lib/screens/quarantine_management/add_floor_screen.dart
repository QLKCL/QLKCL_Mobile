import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'component/general_info_building.dart';

class AddFloorScreen extends StatefulWidget {
  static const String routeName = "/add-floor";
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;

  const AddFloorScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
  }) : super(key: key);

  @override
  _AddFloorScreenState createState() => _AddFloorScreenState();
}

class _AddFloorScreenState extends State<AddFloorScreen> {
  late Future<dynamic> futureFloorList;

  @override
  void initState() {
    super.initState();
    futureFloorList = fetchFloorList(
        {'quarantine_building_id_list': widget.currentBuilding!.id});

    myController.addListener(_updateLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final capacityController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (addMultiple == true) {
        nameController.text = nameList.join(",");
        capacityController.text = capacityList.join(",");
      } else {
        capacityController.text = "0";
      }
      final CancelFunc cancel = showLoading();
      final response = await createFloor(
        createFloorDataForm(
          name: nameController.text,
          quarantineBuilding: widget.currentBuilding!.id,
          roomQuantity: capacityController.text,
        ),
      );
      cancel();
      showNotification(response);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool addMultiple = false;
  int numOfAddedFloor = 1;
  List<String> nameList = [];
  List<String> capacityList = [];

  int maxNum = 10;

  final myController = TextEditingController();

  void _updateLatestValue() {
    setState(() {
      numOfAddedFloor = min(int.tryParse(myController.text) ?? 1, maxNum);
      nameList = []..length = numOfAddedFloor;
      capacityList = List<String>.filled(numOfAddedFloor, "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Thêm tầng'),
      centerTitle: true,
    );

    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: futureFloorList,
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
                        child: GeneralInfoBuilding(
                          currentQuarantine: widget.currentQuarantine!,
                          currentBuilding: widget.currentBuilding!,
                          numberOfFloor: snapshot.data.length,
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxWidth: 800),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Add multiple floors
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 55,
                                          child: ListTileTheme(
                                            contentPadding: EdgeInsets.zero,
                                            child: CheckboxListTile(
                                              title:
                                                  const Text("Thêm nhiều tầng"),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
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
                                              label: 'Số tầng',
                                              hint: 'Số tầng',
                                              type: TextInputType.number,
                                              required: true,
                                              controller: myController,
                                              validatorFunction:
                                                  (String? value) {
                                                return maxNumberValidator(
                                                    value, maxNum);
                                              },
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: const Text(
                                      'Chỉnh sửa thông tin tầng',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  if (addMultiple)
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Input(
                                                label: 'Tên tầng',
                                                hint: 'Tên tầng',
                                                required: true,
                                                onChangedFunction: (text) {
                                                  nameList[index] = text;
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: numOfAddedFloor,
                                    )
                                  else
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Input(
                                            label: 'Tên tầng',
                                            hint: 'Tên tầng',
                                            required: true,
                                            controller: nameController,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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
            },
          ),
        ),
      ),
    );
  }
}
