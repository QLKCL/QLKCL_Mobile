import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/timeline.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/medical_declaration/detail_md_screen.dart';
import 'package:qlkcl/screens/members/component/card.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/test/detail_test_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

Map<String, String> timelineType = {
  "quarantine_history": "Lịch sử cách ly",
  "destination_history": "Lịch sử di chuyển",
  "medical_declaration": "Khai báo y tế",
  "test": "Xét nghiệm",
  "expect_finish": "Dự kiến hoàn thành cách ly",
  "start_quarantine": "Bắt đầu cách ly",
  "COMPLETED": "Hoàn thành cách ly",
};

class TimelineMember extends StatefulWidget {
  static const String routeName = "/detail_member";
  final String? code;
  const TimelineMember({Key? key, this.code}) : super(key: key);

  @override
  State<TimelineMember> createState() => _TimelineMemberState();
}

class _TimelineMemberState extends State<TimelineMember> {
  List<TimelineByDay>? data;
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
    getMemberTimeline(widget.code != null ? {'code': widget.code} : null)
        .then((value) {
      cancel();
      if (value.status == Status.success) {
        setState(() {
          data = TimelineByDay.fromJsonList(value.data);
        });
      } else {
        showNotification(value);
      }
    });
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
      body: (data == null || personalData == null)
          ? const SizedBox()
          : SingleChildScrollView(
              child: ResponsiveRowColumn(
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                rowCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 4,
                    rowFit: FlexFit.tight,
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              minWidth: 100, maxWidth: 800),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: Text(
                              "Thông tin cá nhân",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textField(
                                  title: "Mã định danh",
                                  content: personalData!.code,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Họ và tên",
                                  content: personalData!.fullName,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Số điện thoại",
                                  content: personalData!.phoneNumber,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Email",
                                  content: personalData!.email ?? "Chưa có",
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Số CMND/CCCD",
                                  content: personalData!.identityNumber,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Giới tính",
                                  content: genderList
                                      .safeFirstWhere((gender) =>
                                          gender.id == personalData!.gender)
                                      ?.name,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Ngày sinh",
                                  content: personalData!.birthday,
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Địa chỉ",
                                  content:
                                      '${personalData!.detailAddress != null ? "${personalData!.detailAddress}, " : ""}${personalData!.ward != null ? "${personalData!.ward['name']}, " : ""}${personalData!.district != null ? "${personalData!.district['name']}, " : ""}${personalData!.city != null ? "${personalData!.city['name']}" : ""}',
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Số BHYT/BHXH",
                                  content:
                                      personalData!.healthInsuranceNumber ??
                                          "Không rõ",
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Số hộ chiếu",
                                  content: personalData!.passportNumber ??
                                      "Không rõ",
                                  textColor: primaryText,
                                ),
                                textField(
                                  title: "Nghề nghiệp",
                                  content: personalData!.professional != null
                                      ? personalData!.professional['name']
                                      : "Không rõ",
                                  textColor: primaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 6,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: data!.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: data!.length,
                              padding: const EdgeInsets.only(bottom: 8),
                              physics: ResponsiveWrapper.of(context)
                                      .isSmallerThan(TABLET)
                                  ? const NeverScrollableScrollPhysics()
                                  : const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final currentDay = data![index];
                                final date = DateFormat("dd/MM/yyyy")
                                    .format(DateTime.parse(currentDay.date));
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(
                                          minWidth: 100, maxWidth: 800),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 4),
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                          minWidth: 100, maxWidth: 800),
                                      child: FixedTimeline.tileBuilder(
                                        theme: TimelineThemeData(
                                          color: primary,
                                          nodePosition: 0.2,
                                        ),
                                        builder: TimelineTileBuilder
                                            .connectedFromStyle(
                                          oppositeContentsBuilder:
                                              (context, index) => Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(timelineType[currentDay
                                                        .listData[index].type ==
                                                    "quarantine_history"
                                                ? currentDay.listData[index]
                                                    .data["type"]
                                                : currentDay
                                                    .listData[index].type]!),
                                          ),
                                          contentsBuilder: (context, index) {
                                            if (currentDay
                                                    .listData[index].type ==
                                                "test") {
                                              final data = currentDay
                                                  .listData[index].data;
                                              return TestCard(
                                                code: data['code'],
                                                time: DateFormat(
                                                        "dd/MM/yyyy HH:mm:ss")
                                                    .format(DateTime.parse(
                                                            data['created_at'])
                                                        .toLocal()),
                                                status: testValueList
                                                    .safeFirstWhere((result) =>
                                                        result.id ==
                                                        data['result'])!
                                                    .name,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailTest(
                                                                code: data[
                                                                    'code'],
                                                              )));
                                                },
                                              );
                                            } else if (currentDay
                                                    .listData[index].type ==
                                                "medical_declaration") {
                                              final data = currentDay
                                                  .listData[index].data;
                                              return MedicalDeclarationCard(
                                                code: data['code'].toString(),
                                                time: DateFormat(
                                                        "dd/MM/yyyy HH:mm:ss")
                                                    .format(DateTime.parse(
                                                            data['created_at'])
                                                        .toLocal()),
                                                status: medDeclValueList
                                                    .safeFirstWhere((result) =>
                                                        result.id ==
                                                        data['conclude'])!
                                                    .name,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewMD(
                                                                id: data['id']
                                                                    .toString(),
                                                              )));
                                                },
                                              );
                                            } else if (currentDay
                                                    .listData[index].type ==
                                                "destination_history") {
                                              final data = currentDay
                                                  .listData[index].data;
                                              return DestinationHistoryCard(
                                                name: data['user']['full_name'],
                                                time: (data['start_time'] !=
                                                            null
                                                        ? DateFormat(
                                                                "dd/MM/yyyy HH:mm:ss")
                                                            .format(DateTime
                                                                    .parse(data[
                                                                        'start_time'])
                                                                .toLocal())
                                                        : "") +
                                                    (data['end_time'] != null
                                                        ? " - ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(data['end_time']).toLocal())}"
                                                        : ""),
                                                address: getAddress(data),
                                                note: data['note'] ?? "",
                                              );
                                            } else if (currentDay
                                                    .listData[index].type ==
                                                "quarantine_history") {
                                              final data = currentDay
                                                  .listData[index].data;
                                              return SimpleQuarantineHistoryCard(
                                                name: data['quarantine_ward'] !=
                                                        null
                                                    ? "${data['quarantine_ward']['full_name']}"
                                                    : "",
                                                time: DateFormat(
                                                        "dd/MM/yyyy HH:mm:ss")
                                                    .format(DateTime.parse(
                                                            data["start_date"])
                                                        .toLocal()),
                                                room: (data[
                                                                'quarantine_room'] !=
                                                            null
                                                        ? "${data['quarantine_room']['name']}, "
                                                        : "") +
                                                    (data['quarantine_floor'] !=
                                                            null
                                                        ? "${data['quarantine_floor']['name']}, "
                                                        : "") +
                                                    (data['quarantine_building'] !=
                                                            null
                                                        ? "${data['quarantine_building']['name']}"
                                                        : ""),
                                                note: data["note"] ?? "",
                                              );
                                            } else {
                                              return Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(currentDay
                                                      .listData[index].data
                                                      .toString()),
                                                ),
                                              );
                                            }
                                          },
                                          connectorStyleBuilder:
                                              (context, index) =>
                                                  ConnectorStyle.solidLine,
                                          indicatorStyleBuilder:
                                              (context, index) =>
                                                  IndicatorStyle.dot,
                                          itemCount: currentDay.listData.length,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Image.asset(
                                        "assets/images/no_data.png"),
                                  ),
                                  const Text('Không có dữ liệu'),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
