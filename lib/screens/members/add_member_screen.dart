import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/screens/qr_code/qr_scan_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class AddMember extends StatefulWidget {
  static const String routeName = "/add_member";
  const AddMember({
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
    _tabController = TabController(length: 2, vsync: this);
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
          title: const Text("Thêm người cách ly"),
          centerTitle: true,
          actions: [
            if (_tabController.index == 0)
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                            builder: (context) => const QrCodeScan()),
                      )
                      .then((value) => setState(() {
                            if (value != null) {
                              infoFromIdentityCard = value.split('|').toList();
                            }
                          }));
                },
                icon: const Icon(Icons.photo_camera_front_outlined),
                tooltip: "Nhập dữ liệu từ CCCD",
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: white,
            tabs: const [
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
