import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/screens/members/component/member_quarantine_info.dart';
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
    return MemberShareData(
        child: DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin chi tiết"),
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
                    ? Member.fromJson(snapshot.data["member"])
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
                    ),
                    MemberQuarantineInfo(
                      quarantineData: quarantineData,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                  child: Text('Có lỗi xảy ra!'),
                );
              }
            }

            return const SizedBox();
          },
        ),
      ),
    ));
  }
}

class MemberShareData extends StatefulWidget {
  final Widget child;
  const MemberShareData({Key? key, required this.child}) : super(key: key);

  static MemberShareDataState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedCounter>())!
        .data;
  }

  @override
  MemberShareDataState createState() => MemberShareDataState();
}

class MemberShareDataState extends State<MemberShareData> {
  final codeController = TextEditingController();
  final nationalityController = TextEditingController(text: "VNM");
  final countryController = TextEditingController(text: "VNM");
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final wardController = TextEditingController();
  final detailAddressController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController(text: "MALE");
  final identityNumberController = TextEditingController();
  final healthInsuranceNumberController = TextEditingController();
  final passportNumberController = TextEditingController();
  final quarantineRoomController = TextEditingController();
  final quarantineFloorController = TextEditingController();
  final quarantineBuildingController = TextEditingController();
  final quarantineWardController = TextEditingController();
  final labelController = TextEditingController();
  final quarantinedAtController = TextEditingController();
  final quarantinedFinishExpectedAtController = TextEditingController();
  final backgroundDiseaseController = TextEditingController();
  final otherBackgroundDiseaseController = TextEditingController();
  final positiveTestNowController = TextEditingController();

  void updateField() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InheritedCounter(
      codeController,
      nationalityController,
      countryController,
      cityController,
      districtController,
      wardController,
      detailAddressController,
      fullNameController,
      emailController,
      phoneNumberController,
      birthdayController,
      genderController,
      identityNumberController,
      healthInsuranceNumberController,
      passportNumberController,
      quarantineRoomController,
      quarantineFloorController,
      quarantineBuildingController,
      quarantineWardController,
      labelController,
      quarantinedAtController,
      quarantinedFinishExpectedAtController,
      backgroundDiseaseController,
      otherBackgroundDiseaseController,
      positiveTestNowController,
      childWidget: widget.child,
      data: this,
    );
  }
}

class InheritedCounter extends InheritedWidget {
  const InheritedCounter(
      this.codeController,
      this.nationalityController,
      this.countryController,
      this.cityController,
      this.districtController,
      this.wardController,
      this.detailAddressController,
      this.fullNameController,
      this.emailController,
      this.phoneNumberController,
      this.birthdayController,
      this.genderController,
      this.identityNumberController,
      this.healthInsuranceNumberController,
      this.passportNumberController,
      this.quarantineRoomController,
      this.quarantineFloorController,
      this.quarantineBuildingController,
      this.quarantineWardController,
      this.labelController,
      this.quarantinedAtController,
      this.quarantinedFinishExpectedAtController,
      this.backgroundDiseaseController,
      this.otherBackgroundDiseaseController,
      this.positiveTestNowController,
      {Key? key,
      required this.childWidget,
      required this.data})
      : super(key: key, child: childWidget);

  final Widget childWidget;
  final MemberShareDataState data;

  final TextEditingController codeController;
  final TextEditingController nationalityController;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController wardController;
  final TextEditingController detailAddressController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final TextEditingController birthdayController;
  final TextEditingController genderController;
  final TextEditingController identityNumberController;
  final TextEditingController healthInsuranceNumberController;
  final TextEditingController passportNumberController;
  final TextEditingController quarantineRoomController;
  final TextEditingController quarantineFloorController;
  final TextEditingController quarantineBuildingController;
  final TextEditingController quarantineWardController;
  final TextEditingController labelController;
  final TextEditingController quarantinedAtController;
  final TextEditingController quarantinedFinishExpectedAtController;
  final TextEditingController backgroundDiseaseController;
  final TextEditingController otherBackgroundDiseaseController;
  final TextEditingController positiveTestNowController;

  @override
  bool updateShouldNotify(InheritedCounter oldWidget) {
    return false;
  }
}
