import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/detail_member_screen.dart';

class CompleteMember extends StatelessWidget {
  final data;
  const CompleteMember({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return MemberCard(
                name: data[index]['full_name'] ?? "",
                gender: data[index]['gender'] ?? "",
                birthday: data[index]['birthday'] ?? "",
                room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                lastTestResult: "Âm tính",
                lastTestTime: "22/09/2021",
                healthStatus: data[index]['health_status'],
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(DetailMember.routeName);
                },
              );
            });
  }
}
