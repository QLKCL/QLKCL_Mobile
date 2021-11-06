import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/detail_member_screen.dart';

class SuspectMember extends StatelessWidget {
  const SuspectMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Member(
            id: "1",
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
            lastTestResult: "Âm tính",
            lastTestTime: "22/09/2021",
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(DetailMember.routeName);
            },
          ),
          Member(
            id: "1",
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
            lastTestResult: "Âm tính",
            lastTestTime: "22/09/2021",
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(DetailMember.routeName);
            },
          ),
        ],
      ),
    );
  }
}
