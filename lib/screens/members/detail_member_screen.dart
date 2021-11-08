import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/theme/app_theme.dart';

class DetailMember extends StatefulWidget {
  static const String routeName = "/detail_member";
  DetailMember({Key? key}) : super(key: key);

  @override
  _DetailMemberState createState() => _DetailMemberState();
}

class _DetailMemberState extends State<DetailMember>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<dynamic> futureMember;
  late CustomUser personalData;
  late Member quarantineData;

  @override
  void initState() {
    super.initState();
    futureMember = fetchCustomUser();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thông tin chi tiết"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, UpdateMember.routeName);
              },
              icon: Icon(Icons.edit),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: CustomColors.white,
            tabs: [
              Tab(text: "Thông tin cá nhân"),
              Tab(text: "Thông tin cách ly"),
            ],
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: futureMember,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              EasyLoading.dismiss();
              personalData = CustomUser.fromJson(snapshot.data["custom_user"]);
              quarantineData = Member.fromJson(snapshot.data["member"]);
              return TabBarView(
                controller: _tabController,
                children: [
                  MemberPersonalInfo(
                    personalData: personalData,
                    tabController: _tabController,
                  ),
                  MemberQuarantineInfo(),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            EasyLoading.show();
            return Container();

            // By default, show a loading spinner.
            // return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
