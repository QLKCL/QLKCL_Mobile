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
    this.bloodPressureMin,
    this.bloodPressureMax,
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
  final int? bloodPressureMin;
  final int? bloodPressureMax;
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
        bloodPressureMin: json["blood_pressure_min"],
        bloodPressureMax: json["blood_pressure_max"],
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
        "blood_pressure_min": bloodPressureMin,
        "blood_pressure_max": bloodPressureMax,
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
    } else if (response['error_code'] == 400) {
      if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Not exist") {
        return Response(
            status: Status.error, message: "Số điện thoại không tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
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

// To parse this JSON data, do
//
//     final healthInfo = healthInfoFromJson(jsonString);

HealthInfo healthInfoFromJson(String str) =>
    HealthInfo.fromJson(json.decode(str));

String healthInfoToJson(HealthInfo data) => json.encode(data.toJson());

class HealthInfo {
  HealthInfo({
    required this.heartbeat,
    required this.temperature,
    required this.breathing,
    required this.spo2,
    required this.bloodPressureMin,
    required this.bloodPressureMax,
    required this.mainSymptoms,
    required this.extraSymptoms,
    required this.otherSymptoms,
  });

  final HealthData? heartbeat;
  final HealthData? temperature;
  final HealthData? breathing;
  final HealthData? spo2;
  final HealthData? bloodPressureMin;
  final HealthData? bloodPressureMax;
  final HealthData? mainSymptoms;
  final HealthData? extraSymptoms;
  final HealthData? otherSymptoms;

  factory HealthInfo.fromJson(Map<String, dynamic> json) => HealthInfo(
        heartbeat: json["heartbeat"] != null
            ? HealthData.fromJson(json["heartbeat"])
            : null,
        temperature: json["temperature"] != null
            ? HealthData.fromJson(json["temperature"])
            : null,
        breathing: json["breathing"] != null
            ? HealthData.fromJson(json["breathing"])
            : null,
        spo2: json["spo2"] != null ? HealthData.fromJson(json["spo2"]) : null,
        bloodPressureMin: json["blood_pressure_min"] != null
            ? HealthData.fromJson(json["blood_pressure_min"])
            : null,
        bloodPressureMax: json["blood_pressure_max"] != null
            ? HealthData.fromJson(json["blood_pressure_max"])
            : null,
        mainSymptoms: json["main_symptoms"] != null
            ? HealthData.fromJson(json["main_symptoms"])
            : null,
        extraSymptoms: json["extra_symptoms"] != null
            ? HealthData.fromJson(json["extra_symptoms"])
            : null,
        otherSymptoms: json["other_symptoms"] != null
            ? HealthData.fromJson(json["other_symptoms"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "heartbeat": heartbeat?.toJson(),
        "temperature": temperature?.toJson(),
        "breathing": breathing?.toJson(),
        "spo2": spo2?.toJson(),
        "blood_pressure_min": bloodPressureMin?.toJson(),
        "blood_pressure_max": bloodPressureMax?.toJson(),
        "main_symptoms": mainSymptoms?.toJson(),
        "extra_symptoms": extraSymptoms?.toJson(),
        "other_symptoms": otherSymptoms?.toJson(),
      };
}

class HealthData {
  HealthData({
    required this.data,
    required this.updatedAt,
  });

  final String data;
  final DateTime updatedAt;

  factory HealthData.fromJson(Map<String, dynamic> json) => HealthData(
        data: json["data"] != null ? json["data"].toString() : "",
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "updated_at": updatedAt.toIso8601String(),
      };
}

Future<HealthInfo> getHeathInfo({data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getHealthInfo, data);
  return HealthInfo.fromJson(response["data"]);
}
