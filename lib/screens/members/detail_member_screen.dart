import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/timeline.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/health_infomation.dart';
import 'package:qlkcl/screens/members/component/personal_infomation.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/timeline.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DetailMemberScreen extends StatefulWidget {
  static const String routeName = "/detail_member";
  final String? code;
  const DetailMemberScreen({Key? key, this.code}) : super(key: key);

  @override
  State<DetailMemberScreen> createState() => _DetailMemberScreenState();
}

class _DetailMemberScreenState extends State<DetailMemberScreen> {
  late Future<Response> futureData;
  late Future<Response> futureTimeline;
  late Future<HealthInfo> futureHealth;

  List<TimelineByDay>? data;
  CustomUser? personalData;
  Member? quarantineData;
  HealthInfo? healthData;

  @override
  void initState() {
    super.initState();

    final CancelFunc cancel = showLoading();

    fetchUser(data: widget.code != null ? {'code': widget.code} : null)
        .then((value) {
      cancel();
      personalData = CustomUser.fromJson(value.data["custom_user"]);
      quarantineData = value.data["member"] != null
          ? Member.fromJson(value.data["member"])
          : null;
      if (quarantineData != null) {
        quarantineData!.customUserCode = personalData!.code;
        quarantineData!.quarantineWard = personalData!.quarantineWard;
      }
      setState(() {});
    });
    futureTimeline =
        getMemberTimeline(widget.code != null ? {'code': widget.code} : null);
    futureHealth = getHeathInfo(
        data: widget.code != null ? {'user_code': widget.code} : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chi tiết'),
        centerTitle: true,
        actions: [
          if (personalData != null)
            menus(
              context,
              personalData,
              customMenusColor: white,
              showMenusItems: [
                menusOptions.updateInfo,
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
      ),
      body: personalData != null
          ? RefreshIndicator(
              onRefresh: () => Future.sync(() {
                setState(() {
                  fetchUser(
                          data: widget.code != null
                              ? {'code': widget.code}
                              : null)
                      .then((value) {
                    personalData =
                        CustomUser.fromJson(value.data["custom_user"]);
                    quarantineData = value.data["member"] != null
                        ? Member.fromJson(value.data["member"])
                        : null;
                    if (quarantineData != null) {
                      quarantineData!.customUserCode = personalData!.code;
                      quarantineData!.quarantineWard =
                          personalData!.quarantineWard;
                    }
                    setState(() {});
                  });
                  futureTimeline = getMemberTimeline(
                      widget.code != null ? {'code': widget.code} : null);
                  futureHealth = getHeathInfo(
                      data: widget.code != null
                          ? {'user_code': widget.code}
                          : null);
                });
              }),
              child: SingleChildScrollView(
                child: ResponsiveRowColumn(
                  layout: MediaQuery.of(context).size.width < minDesktopSize
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 5,
                      rowFit: FlexFit.tight,
                      child: personalInfomation(personalData!, quarantineData!),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 5,
                      rowFit: FlexFit.tight,
                      child: FutureBuilder<HealthInfo>(
                        future: futureHealth,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            healthData = snapshot.data;
                            return HealthInformation(
                                personalData: personalData!,
                                quarantineData: quarantineData!,
                                healthData: healthData!);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 5,
                      child: FutureBuilder<Response>(
                        future: futureTimeline,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            data =
                                TimelineByDay.fromJsonList(snapshot.data!.data);
                            return timeline(data!);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
