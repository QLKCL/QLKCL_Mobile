import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/theme/app_theme.dart';

class ConfirmMember extends StatefulWidget {
  static const String routeName = "/confirm_member";
  ConfirmMember({Key? key}) : super(key: key);

  @override
  _ConfirmMemberState createState() => _ConfirmMemberState();
}

class _ConfirmMemberState extends State<ConfirmMember> with TickerProviderStateMixin {
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
          title: Text("Cập nhật thông tin"),
          centerTitle: true,
          actions: [
            if (_tabController.index == 0)
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.qr_code_scanner),
                tooltip: "Nhập dữ liệu từ CCCD",
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
            MemberPersonalInfo(tabController: _tabController),
            MemberQuarantineInfo(),
          ],
        ),
      ),
    );
  }
}
