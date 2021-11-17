import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/quarantine.dart';
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
  bool addMultiple = false;
  int numOfAddedFloor = 1;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_updateLatestValue);
  }

  void _updateLatestValue() {
    setState(() {
      numOfAddedFloor = int.parse(myController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Thêm tầng'),
      centerTitle: true,
    );

    return Scaffold(
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
              child: GeneralInfoBuilding(
                currentQuarantine: widget.currentQuarantine!,
                currentBuilding: widget.currentBuilding!,
                numberOfFloor: 0,
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.65,

              //Input fields
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Add multiple floors
                    Container(
                      margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 55,
                            child: ListTileTheme(
                              contentPadding: EdgeInsets.all(0),
                              child: CheckboxListTile(
                                title: Text("Thêm nhiều tầng"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: addMultiple,
                                onChanged: (bool? value) {
                                  setState(() {
                                    addMultiple = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          // insert number of floor
                          addMultiple
                              ? Expanded(
                                  flex: 45,
                                  child: Input(
                                    label: 'Số tầng',
                                    hint: 'Số tầng',
                                    type: TextInputType.number,
                                    required: true,
                                    //initValue: '1',
                                    controller: myController,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Chỉnh sửa thông tin tầng',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    addMultiple
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 55,
                                    child: Input(
                                      label: 'Tên tầng',
                                      hint: 'Tên tầng',
                                      required: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 45,
                                    child: Input(
                                      label: 'Số phòng',
                                      hint: 'Số phòng',
                                      required: true,
                                      type: TextInputType.number,
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: numOfAddedFloor,
                          )
                        : Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 55,
                                  child: Input(
                                    label: 'Tên tầng',
                                    hint: 'Tên tầng',
                                    required: true,
                                  ),
                                ),
                                Expanded(
                                  flex: 45,
                                  child: Input(
                                    label: 'Số phòng',
                                    hint: 'Số phòng',
                                    required: true,
                                    type: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Xác nhận",
                  style: TextStyle(color: CustomColors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
