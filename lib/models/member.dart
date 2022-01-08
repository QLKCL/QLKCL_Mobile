// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/utils/constant.dart';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  Member({
    required this.id,
    this.quarantineRoom,
    this.quarantineFloor,
    this.quarantineBuilding,
    this.quarantineWard,
    required this.label,
    this.positiveTestedBefore,
    this.abroad,
    this.quarantinedAt,
    this.quarantinedStatus,
    this.lastTested,
    this.healthStatus,
    this.healthNote,
    this.positiveTest,
    this.backgroundDisease,
    this.otherBackgroundDisease,
    this.backgroundDiseaseNote,
    this.careStaff,
    this.customUserCode,
  });

  final int id;
  final dynamic quarantineRoom;
  final dynamic quarantineFloor;
  final dynamic quarantineBuilding;
  dynamic quarantineWard;
  final String label;
  final bool? positiveTestedBefore;
  final bool? abroad;
  final dynamic quarantinedAt;
  final String? quarantinedStatus;
  final dynamic lastTested;
  final String? healthStatus;
  final dynamic healthNote;
  final bool? positiveTest;
  final dynamic backgroundDisease;
  final dynamic otherBackgroundDisease;
  final dynamic backgroundDiseaseNote;
  final dynamic careStaff;
  String? customUserCode;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        quarantineRoom: json["quarantine_room"],
        quarantineFloor: json["quarantine_floor"],
        quarantineBuilding: json["quarantine_building"],
        quarantineWard: json["quarantine_ward"],
        label: json["label"],
        positiveTestedBefore: json["positive_tested_before"],
        abroad: json["abroad"],
        quarantinedAt: json["quarantined_at"],
        quarantinedStatus: json["quarantined_status"],
        lastTested: json["last_tested"],
        healthStatus: json["health_status"],
        healthNote: json["health_note"],
        positiveTest: json["positive_test_now"],
        backgroundDisease: json["background_disease"],
        otherBackgroundDisease: json["other_background_disease"],
        backgroundDiseaseNote: json["background_disease_note"],
        careStaff: json["care_staff"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quarantine_room": quarantineRoom,
        "quarantine_floor": quarantineFloor,
        "quarantine_building": quarantineBuilding,
        "quarantine_ward": quarantineWard,
        "label": label,
        "positive_tested_before": positiveTestedBefore,
        "abroad": abroad,
        "quarantined_at": quarantinedAt,
        "quarantined_status": quarantinedStatus,
        "last_tested": lastTested,
        "health_status": healthStatus,
        "health_note": healthNote,
        "positive_test_now": positiveTest,
        "background_disease": backgroundDisease,
        "other_background_disease": otherBackgroundDisease,
        "background_disease_note": backgroundDiseaseNote,
        "care_staff": careStaff,
      };
}

Future<dynamic> fetchMemberList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListMembers, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<dynamic> createMember(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      MemberPersonalInfo.userCode = response['data']['custom_user']["code"];
      return Response(
          success: true,
          message: "Tạo người cách ly thành công!",
          data: response['data']);
    } else if (response['error_code'] == 400) {
      if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            success: false, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(success: false, message: "Email đã được sử dụng!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(success: false, message: "Số CMND/CCCD đã tồn tại!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> updateMember(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.updateMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true,
          message: "Cập nhật thông tin thành công!",
          data: response['data']);
    } else if (response['error_code'] == 400) {
      if (response['message'] != null &&
          response['message'] == "Invalid argument") {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
      if (response['message']['phone_number'] != null &&
          response['message']['phone_number'] == "Exist") {
        return Response(
            success: false, message: "Số điện thoại đã được sử dụng!");
      } else if (response['message']['health_insurance_number'] != null &&
          response['message']['health_insurance_number'] == "Invalid") {
        return Response(
            success: false, message: "Số bảo hiểm y tế không hợp lệ!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Invalid") {
        return Response(success: false, message: "Số hộ chiếu không hợp lệ!");
      } else if (response['message']['identity_number'] != null &&
          response['message']['identity_number'] == "Exist") {
        return Response(success: false, message: "Số CMND/CCCD đã tồn tại!");
      } else if (response['message']['quarantine_room_id'] != null &&
          response['message']['quarantine_room_id'] == "Full") {
        return Response(success: false, message: "Phòng đã hết chỗ trống!");
      } else if (response['message']['email'] != null &&
          response['message']['email'] == "Exist") {
        return Response(success: false, message: "Email đã được sử dụng!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> denyMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.denyMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Từ chối thành công!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> acceptMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.acceptMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Xét duyệt thành công!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> finishMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.finishMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Đã hoàn thành cách ly!");
    } else {
      return Response(success: false, message: "Không thể hoàn thành cách ly!");
    }
  }
}
