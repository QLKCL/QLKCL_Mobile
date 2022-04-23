// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

Test testFromJson(String str) => Test.fromJson(json.decode(str));

String testToJson(Test data) => json.encode(data.toJson());

class Test {
  Test({
    required this.id,
    required this.user,
    required this.createdBy,
    this.updatedBy,
    required this.code,
    required this.status,
    required this.result,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final KeyValue user;
  final KeyValue createdBy;
  final KeyValue? updatedBy;
  final String code;
  final String status;
  final String result;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["id"],
        user: KeyValue.fromJson(json["user"]),
        createdBy: KeyValue.fromJson(json["created_by"]),
        updatedBy: json["updated_by"] != null
            ? KeyValue.fromJson(json["updated_by"])
            : null,
        code: json["code"],
        status: json["status"],
        result: json["result"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "created_by": createdBy.toJson(),
        "updated_by": updatedBy?.toJson(),
        "code": code,
        "status": status,
        "result": result,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

Future<dynamic> fetchTest({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getTest, data);
  return response["data"];
}

Future<dynamic> fetchTestList({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListTests, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<Response> createTest(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.createTest, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success, message: "Tạo phiếu xét nghiệm thành công!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateTest(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.updateTest, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Cập nhật phiếu xét nghiệm thành công!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> importTest(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.importTest, data);
  if (response == null) {
    showNotification("Lỗi kết nối!", status: Status.error);
  } else {
    if (response['error_code'] == 0) {
      return response['data'];
    } else {
      showNotification("Có lỗi xảy ra!", status: Status.error);
    }
  }
}
