import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
import 'package:qlkcl/screens/members/component/member_shared_data.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/utils/app_theme.dart';

class UpdateMember extends StatefulWidget {
  static const String routeName = "/update_member";
  final String? code;
  const UpdateMember({Key? key, this.code}) : super(key: key);

  @override
  _UpdateMemberState createState() => _UpdateMemberState();
}

class _UpdateMemberState extends State<UpdateMember>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CustomUser? personalData;
  Member? quarantineData;

  @override
  void initState() {
    super.initState();

    final CancelFunc cancel = showLoading();
    fetchUser(data: widget.code != null ? {'code': widget.code} : null)
        .then((value) {
      cancel();
      if (value.status == Status.success) {
        setState(() {
          personalData = CustomUser.fromJson(value.data["custom_user"]);
          quarantineData = value.data["member"] != null
              ? Member.fromJson(value.data["member"])
              : null;
          if (quarantineData != null) {
            quarantineData!.customUserCode = personalData!.code;
            quarantineData!.quarantineWard = personalData!.quarantineWard;
          }
        });
      } else {
        showNotification(value);
      }
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MemberSharedData(
      child: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Cập nhật thông tin"),
            centerTitle: true,
            actions: [
              if (personalData != null)
                menus(
                  context,
                  personalData,
                  customMenusColor: white,
                  showMenusItems: [
                    menusOptions.createMedicalDeclaration,
                    menusOptions.medicalDeclareHistory,
                    menusOptions.createTest,
                    menusOptions.testHistory,
                    menusOptions.vaccineDoseHistory,
                    menusOptions.destinationHistory,
                    menusOptions.quarantineHistory,
                  ],
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
          body: personalData != null
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    MemberPersonalInfo(
                      personalData: personalData,
                      tabController: _tabController,
                    ),
                    MemberQuarantineInfo(
                      quarantineData: quarantineData,
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
