// To parse this JSON data, do
//
//     final customUser = customUserFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

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
    this.fullName,
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
  final dynamic fullName;
  final String phoneNumber;
  final dynamic birthday;
  final dynamic gender;
  final dynamic detailAddress;
  final dynamic healthInsuranceNumber;
  final dynamic identityNumber;
  final dynamic passportNumber;
  final bool? emailVerified;
  final String? status;
  final bool? trash;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final KeyValue? quarantineWard;
  final dynamic role;
  final dynamic createdBy;
  final dynamic updatedBy;

  factory CustomUser.fromJson(Map<String, dynamic> json) => CustomUser(
        id: json["id"],
        nationality: json["nationality"],
        country: json["country"],
        city: json["city"],
        district: json["district"],
        ward: json["ward"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
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
        quarantineWard: json["quarantine_ward"] != null
            ? KeyValue.fromJson(json["quarantine_ward"])
            : null,
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
        "quarantine_ward": quarantineWard?.toJson(),
        "role": role,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

Future<Response> createManager(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.createManager, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Tạo quản lý thành công!",
          data: response['data']);
    } else if (response['error_code'] == 400) {
      if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(
            status: Status.error, message: "Email đã được sử dụng!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số CMND/CCCD đã tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateManager(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.updateManager, data);
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
          response['message'] == "Invalid argument") {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      } else if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['health_insurance_number'] != null &&
          response['message']['health_insurance_number'] == "Invalid") {
        return Response(
            status: Status.error, message: "Số bảo hiểm y tế không hợp lệ!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Invalid") {
        return Response(
            status: Status.error, message: "Số hộ chiếu không hợp lệ!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số CMND/CCCD đã tồn tại!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(
            status: Status.error, message: "Email đã được sử dụng!");
      } else if (response['message']['quarantine_ward_id'] != null &&
          response['message']['quarantine_ward_id'] == "Cannot change") {
        return Response(
            status: Status.error, message: "Không thể thay đổi khu cách ly!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số hộ chiếu đã tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> createStaff(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.createStaff, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Tạo cán bộ thành công!",
          data: response['data']);
    } else if (response['error_code'] == 400) {
      if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(
            status: Status.error, message: "Email đã được sử dụng!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số CMND/CCCD đã tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateStaff(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.updateStaff, data);
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
          response['message'] == "Invalid argument") {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      } else if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['health_insurance_number'] != null &&
          response['message']['health_insurance_number'] == "Invalid") {
        return Response(
            status: Status.error, message: "Số bảo hiểm y tế không hợp lệ!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Invalid") {
        return Response(
            status: Status.error, message: "Số hộ chiếu không hợp lệ!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số CMND/CCCD đã tồn tại!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(
            status: Status.error, message: "Email đã được sử dụng!");
      } else if (response['message']['quarantine_ward_id'] != null &&
          response['message']['quarantine_ward_id'] == "Cannot change") {
        return Response(
            status: Status.error, message: "Không thể thay đổi khu cách ly!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Exist") {
        return Response(
            status: Status.error, message: "Số hộ chiếu đã tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<FilterResponse<FilterStaff>> fetchStaffList({data}) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.filterStaff, data);
  if (response != null) {
    if (response['error_code'] == 0 && response['data'] != null) {
      List<FilterStaff> itemList = response['data']['content']
          .map<FilterStaff>((json) => FilterStaff.fromJson(json))
          .toList();
      return FilterResponse<FilterStaff>(
          data: itemList,
          totalPages: response['data']['totalPages'],
          totalRows: response['data']['totalRows'],
          currentPage: response['data']['currentPage']);
    } else if (response['error_code'] == 401) {
      if (response['message']['quarantine_ward_id'] != null &&
          response['message']['quarantine_ward_id'] == "Permission denied") {
        showNotification('Không có quyền thực hiện chức năng này!',
            status: Status.error);
      }
      return FilterResponse<FilterStaff>();
    } else {
      showNotification('Có lỗi xảy ra!', status: Status.error);
      return FilterResponse<FilterStaff>();
    }
  }

  return FilterResponse<FilterStaff>();
}

// To parse this JSON data, do
//
//     final filterStaff = filterStaffFromJson(jsonString);

FilterStaff filterStaffFromJson(String str) =>
    FilterStaff.fromJson(json.decode(str));

String filterStaffToJson(FilterStaff data) => json.encode(data.toJson());

class FilterStaff {
  FilterStaff({
    required this.code,
    required this.status,
    required this.fullName,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
    required this.createdAt,
    required this.quarantineWard,
    required this.careArea,
  });

  final String code;
  final String status;
  final String fullName;
  final String gender;
  final String birthday;
  final String phoneNumber;
  final DateTime createdAt;
  final KeyValue quarantineWard;
  final dynamic careArea;

  factory FilterStaff.fromJson(Map<String, dynamic> json) => FilterStaff(
        code: json["code"],
        status: json["status"],
        fullName: json["full_name"],
        gender: json["gender"],
        birthday: json["birthday"],
        phoneNumber: json["phone_number"],
        createdAt: DateTime.parse(json["created_at"]),
        quarantineWard: KeyValue.fromJson(json["quarantine_ward"]),
        careArea: json["care_area"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "full_name": fullName,
        "gender": gender,
        "birthday": birthday,
        "phone_number": phoneNumber,
        "created_at": createdAt.toIso8601String(),
        "quarantine_ward": quarantineWard.toJson(),
        "care_area": careArea,
      };
}
