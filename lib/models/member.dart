// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  Member({
    required this.id,
    this.quarantineRoom,
    this.quarantineFloor,
    this.quarantineBuilding,
    this.quarantineWard,
    required this.label,
    this.positiveTestedBefore,
    this.abroad,
    this.quarantinedAt,
    this.quarantinedStatus,
    this.lastTested,
    this.healthStatus,
    this.healthNote,
    this.positiveTest,
    this.backgroundDisease,
    this.otherBackgroundDisease,
    this.backgroundDiseaseNote,
    required this.customUser,
    this.careStaff,
  });

  final int id;
  final dynamic quarantineRoom;
  final dynamic quarantineFloor;
  final dynamic quarantineBuilding;
  final dynamic quarantineWard;
  final String label;
  final bool? positiveTestedBefore;
  final bool? abroad;
  final dynamic quarantinedAt;
  final String? quarantinedStatus;
  final dynamic lastTested;
  final String? healthStatus;
  final dynamic healthNote;
  final bool? positiveTest;
  final dynamic backgroundDisease;
  final dynamic otherBackgroundDisease;
  final dynamic backgroundDiseaseNote;
  final int customUser;
  final dynamic careStaff;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        quarantineRoom: json["quarantine_room"],
        quarantineFloor: json["quarantine_floor"],
        quarantineBuilding: json["quarantine_building"],
        quarantineWard: json["quarantine_ward"],
        label: json["label"],
        positiveTestedBefore: json["positive_tested_before"],
        abroad: json["abroad"],
        quarantinedAt: json["quarantined_at"],
        quarantinedStatus: json["quarantined_status"],
        lastTested: json["last_tested"],
        healthStatus: json["health_status"],
        healthNote: json["health_note"],
        positiveTest: json["positive_test"],
        backgroundDisease: json["background_disease"],
        otherBackgroundDisease: json["other_background_disease"],
        backgroundDiseaseNote: json["background_disease_note"],
        customUser: json["custom_user"],
        careStaff: json["care_staff"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quarantine_room": quarantineRoom,
        "quarantine_floor": quarantineFloor,
        "quarantine_building": quarantineBuilding,
        "quarantine_ward": quarantineWard,
        "label": label,
        "positive_tested_before": positiveTestedBefore,
        "abroad": abroad,
        "quarantined_at": quarantinedAt,
        "quarantined_status": quarantinedStatus,
        "last_tested": lastTested,
        "health_status": healthStatus,
        "health_note": healthNote,
        "positive_test": positiveTest,
        "background_disease": backgroundDisease,
        "other_background_disease": otherBackgroundDisease,
        "background_disease_note": backgroundDiseaseNote,
        "custom_user": customUser,
        "care_staff": careStaff,
      };
}

Future<dynamic> fetchMemberList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListMembers, data);
  print(response);
  return response["data"];
}