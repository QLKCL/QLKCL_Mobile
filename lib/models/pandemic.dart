// To parse this JSON data, do
//
//     final pandemic = pandemicFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/api.dart';

Pandemic pandemicFromJson(String str) => Pandemic.fromJson(json.decode(str));

String pandemicToJson(Pandemic data) => json.encode(data.toJson());

class Pandemic {
  Pandemic({
    required this.id,
    required this.name,
    required this.quarantineTimeNotVac,
    required this.quarantineTimeVac,
    required this.remainQtCcPosVac,
    required this.remainQtCcPosNotVac,
    required this.remainQtCcNotPosVac,
    required this.remainQtCcNotPosNotVac,
    required this.remainQtPosVac,
    required this.remainQtPosNotVac,
    required this.testTypePosToNegVac,
    required this.numTestPosToNegVac,
    required this.testTypePosToNegNotVac,
    required this.numTestPosToNegNotVac,
    required this.testTypeNoneToNegVac,
    required this.numTestNoneToNegVac,
    required this.testTypeNoneToNegNotVac,
    required this.numTestNoneToNegNotVac,
    required this.numDayToCloseRoom,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  final int id;
  final String name;
  final int quarantineTimeNotVac;
  final int quarantineTimeVac;
  final int remainQtCcPosVac;
  final int remainQtCcPosNotVac;
  final int remainQtCcNotPosVac;
  final int remainQtCcNotPosNotVac;
  final int remainQtPosVac;
  final int remainQtPosNotVac;
  final String testTypePosToNegVac;
  final int numTestPosToNegVac;
  final String testTypePosToNegNotVac;
  final int numTestPosToNegNotVac;
  final String testTypeNoneToNegVac;
  final int numTestNoneToNegVac;
  final String testTypeNoneToNegNotVac;
  final int numTestNoneToNegNotVac;
  final int numDayToCloseRoom;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int updatedBy;

  factory Pandemic.fromJson(Map<String, dynamic> json) => Pandemic(
        id: json["id"],
        name: json["name"],
        quarantineTimeNotVac: json["quarantine_time_not_vac"],
        quarantineTimeVac: json["quarantine_time_vac"],
        remainQtCcPosVac: json["remain_qt_cc_pos_vac"],
        remainQtCcPosNotVac: json["remain_qt_cc_pos_not_vac"],
        remainQtCcNotPosVac: json["remain_qt_cc_not_pos_vac"],
        remainQtCcNotPosNotVac: json["remain_qt_cc_not_pos_not_vac"],
        remainQtPosVac: json["remain_qt_pos_vac"],
        remainQtPosNotVac: json["remain_qt_pos_not_vac"],
        testTypePosToNegVac: json["test_type_pos_to_neg_vac"],
        numTestPosToNegVac: json["num_test_pos_to_neg_vac"],
        testTypePosToNegNotVac: json["test_type_pos_to_neg_not_vac"],
        numTestPosToNegNotVac: json["num_test_pos_to_neg_not_vac"],
        testTypeNoneToNegVac: json["test_type_none_to_neg_vac"],
        numTestNoneToNegVac: json["num_test_none_to_neg_vac"],
        testTypeNoneToNegNotVac: json["test_type_none_to_neg_not_vac"],
        numTestNoneToNegNotVac: json["num_test_none_to_neg_not_vac"],
        numDayToCloseRoom: json["num_day_to_close_room"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quarantine_time_not_vac": quarantineTimeNotVac,
        "quarantine_time_vac": quarantineTimeVac,
        "remain_qt_cc_pos_vac": remainQtCcPosVac,
        "remain_qt_cc_pos_not_vac": remainQtCcPosNotVac,
        "remain_qt_cc_not_pos_vac": remainQtCcNotPosVac,
        "remain_qt_cc_not_pos_not_vac": remainQtCcNotPosNotVac,
        "remain_qt_pos_vac": remainQtPosVac,
        "remain_qt_pos_not_vac": remainQtPosNotVac,
        "test_type_pos_to_neg_vac": testTypePosToNegVac,
        "num_test_pos_to_neg_vac": numTestPosToNegVac,
        "test_type_pos_to_neg_not_vac": testTypePosToNegNotVac,
        "num_test_pos_to_neg_not_vac": numTestPosToNegNotVac,
        "test_type_none_to_neg_vac": testTypeNoneToNegVac,
        "num_test_none_to_neg_vac": numTestNoneToNegVac,
        "test_type_none_to_neg_not_vac": testTypeNoneToNegNotVac,
        "num_test_none_to_neg_not_vac": numTestNoneToNegNotVac,
        "num_day_to_close_room": numDayToCloseRoom,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

Future<List<KeyValue>> fetchPandemic({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.filterPandemic, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}
