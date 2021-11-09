// To parse this JSON data, do
//
//     final customUser = customUserFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

CustomUser customUserFromJson(str) => CustomUser.fromJson(json.decode(str));

String customUserToJson(CustomUser data) => json.encode(data.toJson());

class CustomUser {
  CustomUser({
    required this.id,
    this.nationality,
    this.country,
    this.city,
    this.district,
    this.ward,
    this.lastLogin,
    required this.code,
    this.email,
    required this.fullName,
    required this.phoneNumber,
    this.birthday,
    this.gender,
    this.detailAddress,
    this.healthInsuranceNumber,
    this.identityNumber,
    this.passportNumber,
    this.emailVerified,
    this.status,
    this.trash,
    this.createdAt,
    this.updatedAt,
    this.quarantineWard,
    this.role,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final dynamic nationality;
  final dynamic country;
  final dynamic city;
  final dynamic district;
  final dynamic ward;
  final DateTime? lastLogin;
  final String code;
  final dynamic email;
  final String fullName;
  final String phoneNumber;
  final dynamic birthday;
  final String? gender;
  final dynamic detailAddress;
  final dynamic healthInsuranceNumber;
  final dynamic identityNumber;
  final dynamic passportNumber;
  final bool? emailVerified;
  final String? status;
  final bool? trash;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic quarantineWard;
  final int? role;
  final dynamic createdBy;
  final dynamic updatedBy;

  factory CustomUser.fromJson(Map<String, dynamic> json) => CustomUser(
        id: json["id"],
        nationality: json["nationality"],
        country: json["country"],
        city: json["city"],
        district: json["district"],
        ward: json["ward"],
        lastLogin: DateTime.parse(json["last_login"]),
        code: json["code"],
        email: json["email"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        birthday: json["birthday"],
        gender: json["gender"],
        detailAddress: json["detail_address"],
        healthInsuranceNumber: json["health_insurance_number"],
        identityNumber: json["identity_number"],
        passportNumber: json["passport_number"],
        emailVerified: json["email_verified"],
        status: json["status"],
        trash: json["trash"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quarantineWard: json["quarantine_ward"],
        role: json["role"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nationality": nationality,
        "country": country,
        "city": city,
        "district": district,
        "ward": ward,
        "last_login": lastLogin?.toIso8601String(),
        "code": code,
        "email": email,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "birthday": birthday,
        "gender": gender,
        "detail_address": detailAddress,
        "health_insurance_number": healthInsuranceNumber,
        "identity_number": identityNumber,
        "passport_number": passportNumber,
        "email_verified": emailVerified,
        "status": status,
        "trash": trash,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "quarantine_ward": quarantineWard,
        "role": role,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

Future<dynamic> fetchCustomUser({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getMember, data);
  return response["data"];
}
