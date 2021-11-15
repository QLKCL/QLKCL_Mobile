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
    required this.code,
    required this.status,
    required this.result,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
  });

  final int id;
  final CreatedBy user;
  final CreatedBy createdBy;
  final String code;
  final String status;
  final String result;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic updatedBy;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["id"],
        user: CreatedBy.fromJson(json["user"]),
        createdBy: CreatedBy.fromJson(json["created_by"]),
        code: json["code"],
        status: json["status"],
        result: json["result"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "created_by": createdBy.toJson(),
        "code": code,
        "status": status,
        "result": result,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "updated_by": updatedBy,
      };
}

class CreatedBy {
  CreatedBy({
    required this.code,
    required this.fullName,
    this.birthday,
  });

  final String code;
  final String fullName;
  final dynamic birthday;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        code: json["code"],
        fullName: json["full_name"],
        birthday: json["birthday"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "full_name": fullName,
        "birthday": birthday,
      };
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
      return Response(success: true, message: "Tạo phiếu xét nghiệm thành công!");
    } else {
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
