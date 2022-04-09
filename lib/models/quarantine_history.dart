// To parse this JSON data, do
//
//     final quarantineHistory = quarantineHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

QuarantineHistory quarantineHistoryFromJson(String str) =>
    QuarantineHistory.fromJson(json.decode(str));

String quarantineHistoryToJson(QuarantineHistory data) =>
    json.encode(data.toJson());

class QuarantineHistory {
  QuarantineHistory({
    required this.id,
    required this.user,
    required this.pandemic,
    required this.quarantineWard,
    required this.quarantineFloor,
    required this.quarantineBuilding,
    required this.quarantineRoom,
    required this.createdBy,
    required this.updatedBy,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.endType,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final KeyValue user;
  final KeyValue pandemic;
  final KeyValue quarantineWard;
  final KeyValue? quarantineFloor;
  final KeyValue? quarantineBuilding;
  final KeyValue? quarantineRoom;
  final dynamic createdBy;
  final dynamic updatedBy;
  final String status;
  final String startDate;
  final dynamic endDate;
  final dynamic endType;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory QuarantineHistory.fromJson(Map<String, dynamic> json) =>
      QuarantineHistory(
        id: json["id"],
        user: KeyValue.fromJson(json["user"]),
        pandemic: KeyValue.fromJson(json["pandemic"]),
        quarantineWard: KeyValue.fromJson(json["quarantine_ward"]),
        quarantineFloor: json["quarantine_floor"] != null
            ? KeyValue.fromJson(json["quarantine_floor"])
            : null,
        quarantineBuilding: json["quarantine_building"] != null
            ? KeyValue.fromJson(json["quarantine_building"])
            : null,
        quarantineRoom: json["quarantine_room"] != null
            ? KeyValue.fromJson(json["quarantine_room"])
            : null,
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        status: json["status"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        endType: json["end_type"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "pandemic": pandemic.toJson(),
        "quarantine_ward": quarantineWard.toJson(),
        "quarantine_floor": quarantineFloor?.toJson(),
        "quarantine_building": quarantineBuilding?.toJson(),
        "quarantine_room": quarantineRoom?.toJson(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "status": status,
        "start_date": startDate,
        "end_date": endDate,
        "end_type": endType,
        "note": note,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

Future<List<QuarantineHistory>> fetchQuarantineHistoryList({data}) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.filterQuarantineHistory, data);

  if (response != null) {
    if (response['error_code'] == 0 && response['data'] != null) {
      List<QuarantineHistory> itemList = response['data']
          .map<QuarantineHistory>((json) => QuarantineHistory.fromJson(json))
          .toList();
      return itemList;
    } else {
      showNotification('Có lỗi xảy ra!', status: Status.error);
      return [];
    }
  }

  return [];
}
