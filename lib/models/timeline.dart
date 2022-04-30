import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

class TimelineByDay {
  TimelineByDay({
    required this.date,
    required this.listData,
  });

  final String date;
  final List<MemberTimeline> listData;

  static List<TimelineByDay> fromJsonList(Map<String, dynamic> json) {
    return json.keys.map((date) {
      return TimelineByDay(
          date: date,
          listData: json[date]
              .map((item) => MemberTimeline.fromJson(item))
              .toList()
              .cast<MemberTimeline>());
    }).toList();
  }
}

// To parse this JSON data, do
//
//     final memberTimeline = memberTimelineFromJson(jsonString);

MemberTimeline memberTimelineFromJson(String str) =>
    MemberTimeline.fromJson(json.decode(str));

String memberTimelineToJson(MemberTimeline data) => json.encode(data.toJson());

class MemberTimeline {
  MemberTimeline({
    required this.type,
    required this.data,
  });

  final String type;
  final dynamic data;

  factory MemberTimeline.fromJson(Map<String, dynamic> json) => MemberTimeline(
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data.toJson(),
      };
}

Future<Response> getMemberTimeline(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getMemberTimeline, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
        status: Status.success,
        data: response['data'],
      );
    } else {
      return Response(status: Status.error, message: "Lỗi kết nối!");
    }
  }
}
