import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class AddMember extends StatefulWidget {
  static const String routeName = "/add_member";
  AddMember({
    Key? key,
    this.quarantineWard,
    this.quarantineBuilding,
    this.quarantineRoom,
    this.quarantineFloor,
  }) : super(key: key);

  final KeyValue? quarantineWard;
  final KeyValue? quarantineBuilding;
  final KeyValue? quarantineFloor;
  final KeyValue? quarantineRoom;

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String>? infoFromIdentityCard;

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
          title: Text("Thêm người cách ly"),
          centerTitle: true,
          actions: [
            if (_tabController.index == 0)
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                            builder: (context) => QrCodeScan(
                                  type: 'cmnd_cccd',
                                )),
                      )
                      .then((value) => setState(() {
                            infoFromIdentityCard = value.split('|').toList();
                          }));
                },
                icon: Icon(Icons.photo_camera_front_outlined),
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
            MemberPersonalInfo(
              tabController: _tabController,
              mode: Permission.add,
              infoFromIdentityCard: infoFromIdentityCard,
            ),
            MemberQuarantineInfo(
              quarantineWard: widget.quarantineWard,
              quarantineBuilding: widget.quarantineBuilding,
              quarantineFloor: widget.quarantineFloor,
              quarantineRoom: widget.quarantineRoom,
              mode: Permission.add,
            ),
          ],
        ),
      ),
    );
  }
}
