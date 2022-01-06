// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

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
  final CreatedBy user;
  final CreatedBy createdBy;
  final dynamic updatedBy;
  final String code;
  final String status;
  final String result;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["id"],
        user: CreatedBy.fromJson(json["user"]),
        createdBy: CreatedBy.fromJson(json["created_by"]),
        updatedBy: CreatedBy.fromJson(json["updated_by"]),
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
        "updated_by": updatedBy.toJson(),
        "code": code,
        "status": status,
        "result": result,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}


class CreatedBy {
    CreatedBy({
        required this.code,
        required this.fullName,
        this.birthday,
        this.gender,
        this.healthStatus,
    });

    final String code;
    final String fullName;
    final String? birthday;
    final String? gender;
    final dynamic healthStatus;

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        code: json["code"],
        fullName: json["full_name"],
        birthday: json["birthday"],
        gender: json["gender"],
        healthStatus: json["health_status"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "full_name": fullName,
        "birthday": birthday,
        "gender": gender,
        "health_status": healthStatus,
    };
}


Future<dynamic> fetchTest({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getTest, data);
  return response["data"];
}

Future<dynamic> fetchTestList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListTests, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<dynamic> createTest(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createTest, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true, message: "Tạo phiếu xét nghiệm thành công!");
    } else {
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> updateTest(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.updateTest, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true, message: "Cập nhật phiếu xét nghiệm thành công!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
