import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';

class ConfirmDetailMember extends StatefulWidget {
  static const String routeName = "/confirm_member";
  final String? code;
  const ConfirmDetailMember({Key? key, this.code}) : super(key: key);

  @override
  _ConfirmDetailMemberState createState() => _ConfirmDetailMemberState();
}

class _ConfirmDetailMemberState extends State<ConfirmDetailMember>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<dynamic> futureMember;
  late CustomUser personalData;
  late Member? quarantineData;

  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      futureMember = fetchCustomUser(data: {'code': widget.code});
    } else {
      futureMember = fetchCustomUser();
    }
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
          title: const Text("Duyệt người cách ly"),
          centerTitle: true,
          // actions: [
          //   if (_tabController.index == 0)
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.qr_code_scanner),
          //       tooltip: "Nhập dữ liệu từ CCCD",
          //     ),
          // ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: white,
            tabs: const [
              Tab(text: "Thông tin cá nhân"),
              Tab(text: "Thông tin cách ly"),
            ],
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: futureMember,
          builder: (context, snapshot) {
            showLoading();
            if (snapshot.connectionState == ConnectionState.done) {
              BotToast.closeAllLoading();
              if (snapshot.hasData) {
                personalData =
                    CustomUser.fromJson(snapshot.data["custom_user"]);
                quarantineData = snapshot.data["member"] != null
                    ? (Member.fromJson(snapshot.data["member"]))
                    : null;
                if (quarantineData != null) {
                  quarantineData!.customUserCode = personalData.code;
                  quarantineData!.quarantineWard = personalData.quarantineWard;
                }
                return TabBarView(
                  controller: _tabController,
                  children: [
                    MemberPersonalInfo(
                      personalData: personalData,
                      tabController: _tabController,
                      mode: Permission.view,
                    ),
                    MemberQuarantineInfo(
                      quarantineData: quarantineData,
                      mode: Permission.changeStatus,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
