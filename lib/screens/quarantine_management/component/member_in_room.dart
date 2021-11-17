import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/detail_member_screen.dart';

class MemberRoom extends StatefulWidget {
  final data;
  const MemberRoom({Key? key, this.data}) : super(key: key);

  @override
  State<MemberRoom> createState() => _MemberRoomState();
}

class _MemberRoomState extends State<MemberRoom> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return (widget.data == null || widget.data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              //last item
              if (index == widget.data.length - 1) {
                return Column(
                  children: [
                    MemberInRoomCard(
                      name: widget.data[index]['full_name'] ?? "",
                      gender: widget.data[index]['gender'] ?? "",
                      birthday: widget.data[index]['birthday'] ?? "",
                      lastTestResult: widget.data[index]['positive_test'],
                      lastTestTime: widget.data[index]['last_tested'],
                      healthStatus: widget.data[index]['health_status'],
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => DetailMember(
                                      code: widget.data[index]['code'],
                                    )));
                      },
                    ),
                    SizedBox(height: 70),
                  ],
                );
              } else
                return MemberInRoomCard(
                      name: widget.data[index]['full_name'] ?? "",
                      gender: widget.data[index]['gender'] ?? "",
                      birthday: widget.data[index]['birthday'] ?? "",
                      lastTestResult: widget.data[index]['positive_test'],
                      lastTestTime: widget.data[index]['last_tested'],
                      healthStatus: widget.data[index]['health_status'],
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => DetailMember(
                                      code: widget.data[index]['code'],
                                    )));
                      },
                );
            },
            itemCount: widget.data.length,
          );
  }
}
