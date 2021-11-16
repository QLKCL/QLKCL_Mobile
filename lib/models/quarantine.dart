import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/networking/response.dart';

Quarantine quarantineFromJson(String str) =>
    Quarantine.fromJson(json.decode(str));

String quarantineToJson(Quarantine data) => json.encode(data.toJson());

class Quarantine {
  Quarantine({
    required this.id,
    required this.country,
    required this.city,
    required this.district,
    required this.ward,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    required this.status,
    this.type,
    required this.quarantineTime,
    this.trash,
    required this.createdAt,
    required this.updatedAt,
    required this.mainManager,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final Country country;
  final City city;
  final City district;
  final City ward;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String status;
  final String? type;
  final int quarantineTime;
  final bool? trash;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic mainManager;
  final dynamic createdBy;
  final dynamic updatedBy;

  factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
        id: json["id"],
        country: Country.fromJson(json["country"]),
        city: City.fromJson(json["city"]),
        district: City.fromJson(json["district"]),
        ward: City.fromJson(json["ward"]),
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
        mainManager: json["main_manager"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country.toJson(),
        "city": city.toJson(),
        "district": district.toJson(),
        "ward": ward.toJson(),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "main_manager": mainManager,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

class City {
  City({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Country {
  Country({
    required this.id,
    required this.code,
    required this.name,
  });

  final int id;
  final String code;
  final String name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}

Future<dynamic> fetchQuarantine({id}) async {
  ApiHelper api = ApiHelper();
  final response = await api.getHTTP(Constant.getQuarantine + '?id=' + id);
  return response["data"];
}

Future<dynamic> fetchQuarantineList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListQuarantine, data);
  print('Data content');
  print(response['data']['content']);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<dynamic> createQuarantine(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createQuarantine, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Tạo khu cách ly thành công!");
    } else if (response['message']['full_name'] != null &&
        response['message']['full_name'] == "Exist") {
      return Response(
          success: false, message: "Tên khu cách ly đã được sử dụng!");
    } else {
      print(response['message']);
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
