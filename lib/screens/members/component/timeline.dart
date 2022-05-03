import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/timeline.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/screens/medical_declaration/detail_md_screen.dart';
import 'package:qlkcl/screens/members/component/card.dart';
import 'package:qlkcl/screens/test/detail_test_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:timelines/timelines.dart';

Map<String, String> timelineType = {
  "quarantine_history": "Lịch sử cách ly",
  "destination_history": "Lịch sử di chuyển",
  "medical_declaration": "Khai báo y tế",
  "test": "Xét nghiệm",
  "expect_finish": "Dự kiến hoàn thành cách ly",
  "start_quarantine": "Bắt đầu cách ly",
  "COMPLETED": "Hoàn thành cách ly",
  "vaccine_dose": "Tiêm chủng",
  "change_room": "Chuyển phòng"
};

Widget timeline(List<TimelineByDay> data) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data.length,
    padding: const EdgeInsets.only(bottom: 16),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      final currentDay = data[index];
      final date = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(currentDay.date).toLocal());
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
            child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                color: primary,
                nodePosition: 0.2,
              ),
              builder: TimelineTileBuilder.connectedFromStyle(
                oppositeContentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    timelineType[
                        currentDay.listData[index].type == "quarantine_history"
                            ? currentDay.listData[index].data["type"]
                            : currentDay.listData[index].type]!,
                    textAlign: TextAlign.end,
                  ),
                ),
                contentsBuilder: (context, index) {
                  if (currentDay.listData[index].type == "test") {
                    final data = currentDay.listData[index].data;
                    return TestCard(
                      code: data['code'],
                      time: DateFormat("dd/MM/yyyy HH:mm:ss")
                          .format(DateTime.parse(data['created_at']).toLocal()),
                      status: testValueList
                          .safeFirstWhere(
                              (result) => result.id == data['result'])!
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
                          .format(DateTime.parse(data['created_at']).toLocal()),
                      status: medDeclValueList
                          .safeFirstWhere(
                              (result) => result.id == data['conclude'])!
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
                              ? DateFormat("dd/MM/yyyy HH:mm:ss").format(
                                  DateTime.parse(data['start_time']).toLocal())
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
                          .format(DateTime.parse(data["start_date"]).toLocal()),
                      room:
                          (data['quarantine_room'] != null
                                  ? "${data['quarantine_room']['name']}, "
                                  : "") +
                              (data['quarantine_floor'] != null
                                  ? "${data['quarantine_floor']['name']}, "
                                  : "") +
                              (data['quarantine_building'] != null
                                  ? "${data['quarantine_building']['name']}"
                                  : ""),
                      note: data["note"] ?? "",
                    );
                  } else if (currentDay.listData[index].type ==
                      "vaccine_dose") {
                    final data = currentDay.listData[index].data;
                    return VaccineDoseCard(
                      vaccine: data["vaccine"]["name"],
                      time: DateFormat("dd/MM/yyyy HH:mm:ss").format(
                          DateTime.parse(data['injection_date']).toLocal()),
                    );
                  } else {
                    return Container();
                  }
                },
                connectorStyleBuilder: (context, index) =>
                    ConnectorStyle.solidLine,
                indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                itemCount: currentDay.listData.length,
              ),
            ),
          ),
        ],
      );
    },
  );
}
