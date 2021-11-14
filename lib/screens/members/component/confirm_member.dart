import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';

class ConfirmMember extends StatefulWidget {
  ConfirmMember(
      {Key? key,
      required this.longPressFlag,
      required this.indexList,
      required this.longPress})
      : super(key: key);
  final bool longPressFlag;
  final List<int> indexList;
  final VoidCallback longPress;

  @override
  _ConfirmMemberState createState() => _ConfirmMemberState();
}

class _ConfirmMemberState extends State<ConfirmMember> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          MemberCard(
            longPressEnabled: widget.longPressFlag,
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                lastTestResult: false,
            lastTestTime: "22/09/2021",
            healthStatus: 'UNWELL',
            onTap: () {},
            onLongPress: () {
              if (widget.indexList.contains(1)) {
                widget.indexList.remove(1);
              } else {
                widget.indexList.add(1);
              }
              widget.longPress();
            },
          ),
          MemberCard(
            longPressEnabled: widget.longPressFlag,
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                lastTestResult: false,
            lastTestTime: "22/09/2021",
            healthStatus: 'SERIOUS',
            onTap: () {},
            onLongPress: () {
              if (widget.indexList.contains(2)) {
                widget.indexList.remove(2);
              } else {
                widget.indexList.add(2);
              }
              widget.longPress();
            },
          ),
        ],
      ),
    );
  }
}
