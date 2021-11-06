import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
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

class _DetailMemberState extends State<DetailMember> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabChange);
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
        body: TabBarView(
          controller: _tabController,
          children: [
            MemberPersonalInfo(),
            MemberQuarantineInfo(),
          ],
        ),
      ),
    );
  }
}
