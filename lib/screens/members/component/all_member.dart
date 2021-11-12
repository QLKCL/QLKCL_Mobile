import 'package:flutter/material.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/detail_member_screen.dart';

class AllMember extends StatefulWidget {
  AllMember({Key? key}) : super(key: key);

  @override
  _AllMemberState createState() => _AllMemberState();
}

class _AllMemberState extends State<AllMember> {
  late Future<dynamic> futureMemberList;

  @override
  void initState() {
    super.initState();
    futureMemberList = fetchMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: futureMemberList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          } else if (snapshot.hasData) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  return MemberCard(
                    name: snapshot.data[index]['full_name'] ?? "",
                    gender: snapshot.data[index]['gender'] ?? "",
                    birthday: snapshot.data[index]['birthday'] ?? "",
                    room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                    lastTestResult: "Âm tính",
                    lastTestTime: "22/09/2021",
                    healthStatus: snapshot.data[index]['health_status'],
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => DetailMember(
                                    code: snapshot.data[index]['code'],
                                  )));
                    },
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }

        return Container();
      },
    );
  }
}
