import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

import 'component/general_info_floor.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = "/add-room";

  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  bool addMultiple = false;
  int numOfAddedRoom = 1;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_updateLatestValue);
  }

  void _updateLatestValue() {
    setState(() {
      numOfAddedRoom = int.parse(myController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Thêm phòng'),
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
              child:
                  GeneralInfoFloor('Ký túc xá khu A', 'Tòa AH','Tầng 3', 8, 15, 300),
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
                                title: Text("Thêm nhiều phòng"),
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
                                    label: 'Số phòng',
                                    hint: 'Số phòng',
                                    type: TextInputType.number,
                                    required: true,
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
                        'Chỉnh sửa thông tin phòng',
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
                                      label: 'Tên phòng',
                                      hint: 'Tên phòng',
                                      required: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 45,
                                    child: Input(
                                      label: 'Người tối đa',
                                      hint: 'Người tối đa',
                                      required: true,
                                      type: TextInputType.number,
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: numOfAddedRoom,
                          )
                        : Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Input(
                                    label: 'Tên phòng',
                                    hint: 'Tên phòng',
                                    required: true,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Input(
                                    label: 'Số người tối đa',
                                    hint: 'Số người tối đa',
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
