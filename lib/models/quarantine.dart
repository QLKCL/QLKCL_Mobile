// To parse this JSON data, do
//
//     final quarantine = quarantineFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

Quarantine quarantineFromJson(String str) => Quarantine.fromJson(json.decode(str));

String quarantineToJson(Quarantine data) => json.encode(data.toJson());

class Quarantine {
    Quarantine({
        required this.id,
        required this.email,
        required this.fullName,
        this.phoneNumber,
        this.address,
        this.latitude,
        this.longitude,
        this.status,
        this.type,
        required this.quarantineTime,
        this.trash,
        this.createdAt,
        this.updatedAt,
        required this.country,
        required this.city,
        required this.district,
        required this.ward,
        required this.mainManager,
        this.createdBy,
        this.updatedBy,
    });

    final int id;
    final String email;
    final String fullName;
    final dynamic phoneNumber;
    final dynamic address;
    final dynamic latitude;
    final dynamic longitude;
    final dynamic status;
    final dynamic type;
    final int quarantineTime;
    final bool? trash;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int country;
    final int city;
    final int district;
    final int ward;
    final int mainManager;
    final dynamic createdBy;
    final dynamic updatedBy;

    factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
        id: json["id"],
        email: json["email"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        type: json["type"],
        quarantineTime: json["quarantine_time"],
        trash: json["trash"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        country: json["country"],
        city: json["city"],
        district: json["district"],
        ward: json["ward"],
        mainManager: json["main_manager"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "type": type,
        "quarantine_time": quarantineTime,
        "trash": trash,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "country": country,
        "city": city,
        "district": district,
        "ward": ward,
        "main_manager": mainManager,
        "created_by": createdBy,
        "updated_by": updatedBy,
    };
}

Future<dynamic> fetchQuarantine({id}) async {
  ApiHelper api = ApiHelper();
  final response = await api.getHTTP(Constant.getQuarantine + '?id=' + id);
  return response["data"];
}
Future<dynamic> fetchQuarantineList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListQuarantine,data);
  return response["data"]['content'];
}