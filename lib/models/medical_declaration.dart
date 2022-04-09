// To parse this JSON data, do
//
//     final medicalDecl = medicalDeclFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

MedicalDecl medicalDeclFromJson(String str) =>
    MedicalDecl.fromJson(json.decode(str));

String medicalDeclToJson(MedicalDecl data) => json.encode(data.toJson());

class MedicalDecl {
  MedicalDecl({
    required this.id,
    required this.user,
    this.heartbeat,
    this.temperature,
    this.breathing,
    this.spo2,
    this.bloodPressure,
    this.mainSymptoms,
    this.extraSymptoms,
    this.otherSymptoms,
    required this.conclude,
    required this.createdAt,
    required this.createdBy,
  });

  final int id;
  final User user;
  final int? heartbeat;
  final double? temperature;
  final int? breathing;
  final double? spo2;
  final double? bloodPressure;
  final String? mainSymptoms;
  final String? extraSymptoms;
  final String? otherSymptoms;

  final String conclude;
  final DateTime createdAt;
  final int createdBy;

  factory MedicalDecl.fromJson(Map<String, dynamic> json) => MedicalDecl(
        id: json["id"],
        user: User.fromJson(json["user"]),
        heartbeat: json["heartbeat"],
        temperature: json["temperature"],
        breathing: json["breathing"],
        spo2: json["spo2"],
        bloodPressure: json["blood_pressure"],
        mainSymptoms: json["main_symptoms"],
        extraSymptoms: json["extra_symptoms"],
        otherSymptoms: json["other_symptoms"],
        conclude: json["conclude"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "heartbeat": heartbeat,
        "temperature": temperature,
        "breathing": breathing,
        "spo2": spo2,
        "blood_pressure": bloodPressure,
        "main_symptoms": mainSymptoms,
        "extra_symptoms": extraSymptoms,
        "other_symptoms": otherSymptoms,
        "conclude": conclude,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
      };
}

class User {
  User({
    required this.code,
    required this.fullName,
    this.birthday,
  });

  final String code;
  final String fullName;
  final dynamic birthday;

  factory User.fromJson(Map<String, dynamic> json) => User(
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

Future<dynamic> fetchMedDecl({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getMedDecl, data);
  return response["data"];
}

Future<dynamic> fetchMedList({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.filterMedDecl, data);

  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<Response> createMedDecl(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.createMedDecl, data);

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(status: Status.success, message: "Khai báo thành công!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateMedDecl(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.updateTest, data);

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success, message: "Cập nhật khai báo thành công!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}
