import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';

class ConfirmMember extends StatefulWidget {
  ConfirmMember({Key? key}) : super(key: key);

  @override
  _ConfirmMemberState createState() => _ConfirmMemberState();
}

class _ConfirmMemberState extends State<ConfirmMember> {
  bool longPressFlag = false;
  List<int> indexList = [];

  void longPress() {
    setState(() {
      if (indexList.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Member(
            id: "1",
            longPressEnabled: longPressFlag,
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
            lastTestResult: "Âm tính",
            lastTestTime: "22/09/2021",
            onTap: () {},
            onLongPress: () {
              if (indexList.contains(1)) {
                indexList.remove(1);
              } else {
                indexList.add(1);
              }
              longPress();
            },
          ),
          Member(
            id: "2",
            longPressEnabled: longPressFlag,
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
            lastTestResult: "Âm tính",
            lastTestTime: "22/09/2021",
            onTap: () {},
            onLongPress: () {
              if (indexList.contains(2)) {
                indexList.remove(2);
              } else {
                indexList.add(2);
              }
              longPress();
            },
          ),
        ],
      ),
    );
  }
}
