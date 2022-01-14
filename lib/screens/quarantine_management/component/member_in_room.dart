import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';

class MemberRoom extends StatelessWidget {
  final data;
  const MemberRoom({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              //last item
              if (index == data.length - 1) {
                return Column(
                  children: [
                    MemberInRoomCard(
                      name: data[index]['full_name'] ?? "",
                      gender: data[index]['gender'] ?? "",
                      birthday: data[index]['birthday'] ?? "",
                      lastTestResult: data[index]['positive_test_now'],
                      lastTestTime: data[index]['last_tested'],
                      healthStatus: data[index]['health_status'],
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => UpdateMember(
                                      code: data[index]['code'],
                                    )));
                      },
                    ),
                    SizedBox(height: 70),
                  ],
                );
              } else
                return MemberInRoomCard(
                  name: data[index]['full_name'] ?? "",
                  gender: data[index]['gender'] ?? "",
                  birthday: data[index]['birthday'] ?? "",
                  lastTestResult: data[index]['positive_test_now'],
                  lastTestTime: data[index]['last_tested'],
                  healthStatus: data[index]['health_status'],
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => UpdateMember(
                                  code: data[index]['code'],
                                )));
                  },
                );
            },
            itemCount: data.length,
          );
  }
}
