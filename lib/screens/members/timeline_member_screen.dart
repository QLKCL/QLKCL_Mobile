import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/timeline.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/infomation.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/timeline.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TimelineMember extends StatefulWidget {
  static const String routeName = "/detail_member";
  final String? code;
  const TimelineMember({Key? key, this.code}) : super(key: key);

  @override
  State<TimelineMember> createState() => _TimelineMemberState();
}

class _TimelineMemberState extends State<TimelineMember> {
  late Future<Response> futureData;
  late Future<Response> futureTimeline;

  List<TimelineByDay>? data;
  CustomUser? personalData;
  Member? quarantineData;

  late CancelFunc cancel;
  @override
  void initState() {
    super.initState();

    cancel = showLoading();
    futureData =
        fetchUser(data: widget.code != null ? {'code': widget.code} : null);
    futureTimeline =
        getMemberTimeline(widget.code != null ? {'code': widget.code} : null);
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
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            setState(() {
              futureData = fetchUser(
                  data: widget.code != null ? {'code': widget.code} : null);
              futureTimeline = getMemberTimeline(
                  widget.code != null ? {'code': widget.code} : null);
            });
          }),
          child: SingleChildScrollView(
            child: ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 5,
                  rowFit: FlexFit.tight,
                  child: FutureBuilder<Response>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        cancel();
                        personalData = CustomUser.fromJson(
                            snapshot.data!.data["custom_user"]);
                        quarantineData = snapshot.data!.data["member"] != null
                            ? Member.fromJson(snapshot.data!.data["member"])
                            : null;
                        if (quarantineData != null) {
                          quarantineData!.customUserCode = personalData!.code;
                          quarantineData!.quarantineWard =
                              personalData!.quarantineWard;
                        }
                        return infomation(personalData!, quarantineData!);
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
                        cancel();
                        data = TimelineByDay.fromJsonList(snapshot.data!.data);
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
        ));
  }
}
