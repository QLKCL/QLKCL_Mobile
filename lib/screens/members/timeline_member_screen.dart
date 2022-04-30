import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/timeline.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/medical_declaration/detail_md_screen.dart';
import 'package:qlkcl/screens/members/component/card.dart';
import 'package:qlkcl/screens/test/detail_test_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
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

  @override
  void initState() {
    super.initState();

    final CancelFunc cancel = showLoading();
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
      ),
      body: data == null
          ? const SizedBox()
          : data!.isNotEmpty
              ? ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    final currentDay = data![index];
                    final date = DateFormat("dd/MM/yyyy")
                        .format(DateTime.parse(currentDay.date));
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: Responsive.isDesktopLayout(context)
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            date,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        FixedTimeline.tileBuilder(
                          theme: TimelineThemeData(
                            color: primary,
                            nodePosition:
                                Responsive.isDesktopLayout(context) ? 0.5 : 0.2,
                          ),
                          builder: TimelineTileBuilder.connectedFromStyle(
                            contentsAlign: Responsive.isDesktopLayout(context)
                                ? ContentsAlign.alternating
                                : ContentsAlign.basic,
                            oppositeContentsBuilder: (context, index) =>
                                Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(timelineType[
                                  currentDay.listData[index].type ==
                                          "quarantine_history"
                                      ? currentDay.listData[index].data["type"]
                                      : currentDay.listData[index].type]!),
                            ),
                            contentsBuilder: (context, index) {
                              if (currentDay.listData[index].type == "test") {
                                final data = currentDay.listData[index].data;
                                return TestCard(
                                  code: data['code'],
                                  time: DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(data['created_at'])
                                          .toLocal()),
                                  status: testValueList
                                      .safeFirstWhere((result) =>
                                          result.id == data['result'])!
                                      .name,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailTest(
                                                  code: data['code'],
                                                )));
                                  },
                                );
                              } else if (currentDay.listData[index].type ==
                                  "medical_declaration") {
                                final data = currentDay.listData[index].data;
                                return MedicalDeclarationCard(
                                  code: data['code'].toString(),
                                  time: DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(data['created_at'])
                                          .toLocal()),
                                  status: medDeclValueList
                                      .safeFirstWhere((result) =>
                                          result.id == data['conclude'])!
                                      .name,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewMD(
                                                  id: data['id'].toString(),
                                                )));
                                  },
                                );
                              } else if (currentDay.listData[index].type ==
                                  "destination_history") {
                                final data = currentDay.listData[index].data;
                                return DestinationHistoryCard(
                                  name: data['user']['full_name'],
                                  time: (data['start_time'] != null
                                          ? DateFormat("dd/MM/yyyy HH:mm:ss")
                                              .format(DateTime.parse(
                                                      data['start_time'])
                                                  .toLocal())
                                          : "") +
                                      (data['end_time'] != null
                                          ? " - ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(data['end_time']).toLocal())}"
                                          : ""),
                                  address: getAddress(data),
                                  note: data['note'] ?? "",
                                );
                              } else if (currentDay.listData[index].type ==
                                  "quarantine_history") {
                                final data = currentDay.listData[index].data;
                                return SimpleQuarantineHistoryCard(
                                  name: data['quarantine_ward'] != null
                                      ? "${data['quarantine_ward']['full_name']}"
                                      : "",
                                  time: DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(data["start_date"])
                                          .toLocal()),
                                  room: (data['quarantine_room'] != null
                                          ? "${data['quarantine_room']['name']}, "
                                          : "") +
                                      (data['quarantine_floor'] != null
                                          ? "${data['quarantine_floor']['name']}, "
                                          : "") +
                                      (data['quarantine_building'] != null
                                          ? "${data['quarantine_building']['name']}, "
                                          : ""),
                                  note: data["note"] ?? "",
                                );
                              } else {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(currentDay.listData[index].data
                                        .toString()),
                                  ),
                                );
                              }
                            },
                            connectorStyleBuilder: (context, index) =>
                                ConnectorStyle.solidLine,
                            indicatorStyleBuilder: (context, index) =>
                                IndicatorStyle.dot,
                            itemCount: currentDay.listData.length,
                          ),
                        )
                      ],
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset("assets/images/no_data.png"),
                      ),
                      const Text('Không có dữ liệu'),
                    ],
                  ),
                ),
    );
  }
}
