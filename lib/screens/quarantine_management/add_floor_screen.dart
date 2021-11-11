import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';

import 'component/general_info_building.dart';

class AddFloorScreen extends StatefulWidget {
  static const String routeName = "/add-floor";

  const AddFloorScreen({Key? key}) : super(key: key);

  @override
  _AddFloorScreenState createState() => _AddFloorScreenState();
}

class _AddFloorScreenState extends State<AddFloorScreen> {
  bool addMultiple = false;
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
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child:
                  GeneralInfoBuilding('Ký túc xá khu A', 'Tòa AH', 8, 15, 300),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.55,
              margin: const EdgeInsets.symmetric(vertical: 8),
              //Input fields
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Add multiple floors
                  Container(
                    margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListTileTheme(
                            contentPadding: EdgeInsets.all(0),
                            child: CheckboxListTile(
                              title: Text("Thêm nhiều tầng"),
                              controlAffinity: ListTileControlAffinity.leading,
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
                              flex: 2,
                                child: Input(
                                  label: 'Số tầng',
                                  hint: 'Số tầng',
                                  type: TextInputType.number,
                                  required: true,
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
                      ? Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Input(
                                label: 'Tên tầng',
                                hint: 'Tên tầng',
                                required: true,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Input(
                                label: 'Số phòng',
                                hint: 'Số phòng',
                                required: true,
                                type: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Input(
                                label: 'Tên tầng',
                                hint: 'Tên tầng',
                                required: true,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Input(
                                label: 'Số phòng',
                                hint: 'Số phòng',
                                required: true,
                                type: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
