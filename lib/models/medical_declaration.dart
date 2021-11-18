// To parse this JSON data, do
//
//     final medicalDecl = medicalDeclFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

MedicalDecl medicalDeclFromJson(String str) =>
    MedicalDecl.fromJson(json.decode(str));

String medicalDeclToJson(MedicalDecl data) => json.encode(data.toJson());

class MedicalDecl {
  MedicalDecl({
    required this.id,
    this.user,
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
  final dynamic user;
  final int? heartbeat;
  final int? temperature;
  final int? breathing;
  final int? spo2;
  final int? bloodPressure;
  final String? mainSymptoms;
  final String? extraSymptoms;
  final String? otherSymptoms;

  final String conclude;
  final DateTime createdAt;
  final int createdBy;

  factory MedicalDecl.fromJson(Map<String, dynamic> json) => MedicalDecl(
        id: json["id"],
        user: json["user"],
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

Future<dynamic> fetchMedDecl({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getMedDecl, data);
  return response["data"];
}

Future<dynamic> fetchMedList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.filterMedDecl, data);
  print(response['data']['content']);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<dynamic> createMedDecl(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createMedDecl, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Khai báo thành công!");
    } else {
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> updateMedDecl(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.updateTest, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true, message: "Cập nhật phiếu khai báo nghiệm thành công!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
