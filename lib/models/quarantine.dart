import 'dart:convert';

import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/pandemic.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/api.dart';
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
    required this.currentMem,
    required this.capacity,
    this.image,
    this.pandemic,
  });

  final int id;
  final dynamic country;
  final dynamic city;
  final dynamic district;
  final dynamic ward;
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
  final int currentMem;
  final int capacity;
  final String? image;
  final Pandemic? pandemic;

  factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
      id: json["id"],
      country: json["country"],
      city: json["city"],
      district: json["district"],
      ward: json["ward"],
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
      currentMem: json["num_current_member"],
      capacity: json["total_capacity"] ?? 0,
      image: json["image"],
      pandemic: json["pandemic"] != null
          ? Pandemic.fromJson(json["pandemic"])
          : null);

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
        "num_current_member": currentMem,
        "total_capacity": capacity,
        "image": image,
        "pandemic": pandemic?.toJson(),
      };
}

Future<dynamic> fetchQuarantine(id) async {
  final ApiHelper api = ApiHelper();
  final response = await api.getHTTP('${Api.getQuarantine}?id=$id');
  return response["data"];
}

Future<FilterResponse<FilterQuanrantineWard>> fetchQuarantineList(
    {data}) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListQuarantine, data);
  if (response['error_code'] == 0 && response['data'] != null) {
    final List<FilterQuanrantineWard> itemList = response['data']['content']
        .map<FilterQuanrantineWard>(
            (json) => FilterQuanrantineWard.fromJson(json))
        .toList();
    return FilterResponse<FilterQuanrantineWard>(
        data: itemList,
        totalPages: response['data']['totalPages'],
        totalRows: response['data']['totalRows'],
        currentPage: response['data']['currentPage']);
  } else {
    showNotification('Có lỗi xảy ra!', status: Status.error);
    return FilterResponse<FilterQuanrantineWard>();
  }
}

Future<Response> createQuarantine(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.createQuarantine, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Tạo khu cách ly thành công!",
          data: response['data']);
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateQuarantine(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.updateQuarantine, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Cập nhật thông tin thành công!",
          data: response['data']);
    } else if (response['error_code'] == 400) {
      if (response['message'] != null &&
          response['message'] == "User is not exist") {
        return Response(status: Status.error, message: "Quản lý không hợp lệ!");
      } else if (response['message']['full_name'] != null &&
          response['message']['full_name'] == "Exist") {
        return Response(
            status: Status.error, message: "Tên khu cách ly đã được sử dụng!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else if (response['error_code'] == 401) {
      if (response['message'] != null &&
          response['message'] == "Permission denied") {
        return Response(
            status: Status.error,
            message: 'Không có quyền thực hiện chức năng này!');
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> fetchBuildingList(Map<String, dynamic> data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListBuilding, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

// To parse this JSON data, do
//
//     final filterQuanrantineWard = filterQuanrantineWardFromJson(jsonString);

FilterQuanrantineWard filterQuanrantineWardFromJson(String str) =>
    FilterQuanrantineWard.fromJson(json.decode(str));

String filterQuanrantineWardToJson(FilterQuanrantineWard data) =>
    json.encode(data.toJson());

class FilterQuanrantineWard {
  FilterQuanrantineWard({
    required this.id,
    required this.mainManager,
    required this.fullName,
    required this.image,
    required this.pandemic,
    required this.city,
    required this.country,
    required this.district,
    required this.ward,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.numCurrentMember,
    required this.totalCapacity,
  });

  final int id;
  final KeyValue? mainManager;
  final String fullName;
  final String image;
  final Pandemic? pandemic;
  final KeyValue? city;
  final KeyValue? country;
  final KeyValue? district;
  final KeyValue? ward;
  final dynamic address;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int numCurrentMember;
  final int totalCapacity;

  factory FilterQuanrantineWard.fromJson(Map<String, dynamic> json) =>
      FilterQuanrantineWard(
        id: json["id"],
        mainManager: json["main_manager"] != null
            ? KeyValue.fromJson(json["main_manager"])
            : null,
        fullName: json["full_name"],
        image: (json["image"] != null && json["image"] != "")
            ? json["image"]
            : "Default/no_image_available",
        pandemic: json["pandemic"] != null
            ? Pandemic.fromJson(json["pandemic"])
            : null,
        city: json["city"] != null ? KeyValue.fromJson(json["city"]) : null,
        country:
            json["country"] != null ? KeyValue.fromJson(json["country"]) : null,
        district: json["district"] != null
            ? KeyValue.fromJson(json["district"])
            : null,
        ward: json["ward"] != null ? KeyValue.fromJson(json["ward"]) : null,
        address: json["address"],
        latitude: json["latitude"] != null ? double.parse(json["latitude"]) : 0,
        longitude:
            json["longitude"] != null ? double.parse(json["longitude"]) : 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        numCurrentMember: json["num_current_member"],
        totalCapacity: json["total_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main_manager": mainManager?.toJson(),
        "full_name": fullName,
        "image": image,
        "pandemic": pandemic?.toJson(),
        "city": city?.toJson(),
        "country": country?.toJson(),
        "district": district?.toJson(),
        "ward": ward?.toJson(),
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "num_current_member": numCurrentMember,
        "total_capacity": totalCapacity,
      };
}
