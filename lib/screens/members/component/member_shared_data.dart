import 'package:flutter/material.dart';

class MemberSharedData extends StatefulWidget {
  final Widget child;
  const MemberSharedData({Key? key, required this.child}) : super(key: key);

  static MemberSharedDataState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedMemberData>())!
        .data;
  }

  @override
  MemberSharedDataState createState() => MemberSharedDataState();
}

class MemberSharedDataState extends State<MemberSharedData> {
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
  final positiveTestNowController = TextEditingController(text: "Null");

  void updateField() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InheritedMemberData(
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

class InheritedMemberData extends InheritedWidget {
  const InheritedMemberData(
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
  final MemberSharedDataState data;

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
  bool updateShouldNotify(InheritedMemberData oldWidget) {
    return false;
  }
}
