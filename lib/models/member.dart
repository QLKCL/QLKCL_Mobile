// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/member_personal_info.dart';
import 'package:qlkcl/utils/api.dart';

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
    this.quarantinedFinishExpectedAt,
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
  final dynamic quarantinedFinishExpectedAt;
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
        quarantinedFinishExpectedAt: json["quarantined_finish_expected_at"],
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
        "quarantined_finish_expected_at": quarantinedFinishExpectedAt,
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

Future<FilterResponse<FilterMember>> fetchMemberList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListMembers, data);
  if (response != null) {
    if (response['error_code'] == 0 && response['data'] != null) {
      List<FilterMember> itemList = response['data']['content']
          .map<FilterMember>((json) => FilterMember.fromJson(json))
          .toList();
      return FilterResponse<FilterMember>(
          data: itemList,
          totalPages: response['data']['totalPages'],
          totalRows: response['data']['totalRows'],
          currentPage: response['data']['currentPage']);
    } else if (response['error_code'] == 401) {
      if (response['message']['quarantine_ward_id'] != null &&
          response['message']['quarantine_ward_id'] == "Permission denied") {
        showNotification('Không có quyền thực hiện chức năng này!',
            status: 'error');
      }
      return FilterResponse<FilterMember>();
    } else {
      showNotification('Có lỗi xảy ra!', status: 'error');
      return FilterResponse<FilterMember>();
    }
  }

  return FilterResponse<FilterMember>();
}

Future<Response> createMember(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.createMember, data);
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
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateMember(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.updateMember, data);
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
      } else if (response['message']['phone_number'] != null &&
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
      } else if (response['message']['quarantine_ward_id'] != null &&
          response['message']['quarantine_ward_id'] == "Cannot change") {
        return Response(
            success: false, message: "Không thể thay đổi khu cách ly!");
      } else if (response['message']['quarantine_room_id'] != null &&
          response['message']['quarantine_room_id'] ==
              "This room does not satisfy max_day_quarantined") {
        return Response(
            success: false, message: "Phòng đã chọn không phù hợp!");
      } else if (response['message']['quarantine_room_id'] != null &&
          response['message']['quarantine_room_id'] ==
              "This member positive, but this room has member that is not positive") {
        return Response(
            success: false,
            message: "Khổng thể chuyển người dương tính sang phòng này!");
      } else if (response['message']['passport_number'] != null &&
          response['message']['passport_number'] == "Exist") {
        return Response(success: false, message: "Số hộ chiếu đã tồn tại!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> denyMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.denyMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Từ chối thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message']['member_codes'] != null &&
          response['message']['member_codes'] == "empty") {
        return Response(
            success: false, message: "Vui lòng chọn tài khoản cần xét duyệt!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> acceptManyMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.acceptManyMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0 && response['data'] == {}) {
      showNotification("Chấp nhận thành công!");
      return Response(success: true, message: "Chấp nhận thành công!");
    } else if (response['error_code'] == 0 && response['data'] != {}) {
      showNotification("Một số tài khoản không thể xét duyệt!",
          status: 'warning');
      return Response(
          success: true, message: "Một số tài khoản không thể xét duyệt!");
    } else if (response['error_code'] == 400) {
      if (response['message']['member_codes'] != null &&
          response['message']['member_codes'] == "empty") {
        showNotification("Vui lòng chọn tài khoản cần xét duyệt!",
            status: 'error');
        return Response(
            success: false, message: "Vui lòng chọn tài khoản cần xét duyệt!");
      } else {
        showNotification("Có lỗi xảy ra!", status: 'error');
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      showNotification("Có lỗi xảy ra!", status: 'error');
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> acceptOneMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.acceptOneMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Xét duyệt thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message']['member_codes'] != null &&
          response['message']['member_codes'] == "empty") {
        return Response(
            success: false, message: "Vui lòng chọn tài khoản cần xét duyệt!");
      } else if (response['message']['main'] != null &&
          response['message']['main'] ==
              "All rooms are not accept any more member") {
        return Response(
            success: false, message: "Khu cách ly này đã hết giường trống!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> finishMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.finishMember, data);
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

Future<Response> changeRoomMember(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.changeRoomMember, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Chuyển phòng thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message']['quarantine_room_id'] != null &&
          response['message']['quarantine_room_id'] ==
              "This room does not satisfy max_day_quarantined") {
        return Response(
            success: false, message: "Phòng đã chọn không phù hợp!");
      } else if (response['message']['quarantine_room_id'] != null &&
          response['message']['quarantine_room_id'] ==
              "This member positive, but this room has member that is not positive") {
        return Response(
            success: false,
            message: "Khổng thể chuyển người dương tính sang phòng này!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

// To parse this JSON data, do
//
//     final filterMember = filterMemberFromJson(jsonString);

FilterMember filterMemberFromJson(String str) =>
    FilterMember.fromJson(json.decode(str));

String filterMemberToJson(FilterMember data) => json.encode(data.toJson());

class FilterMember {
  FilterMember({
    required this.code,
    required this.status,
    required this.fullName,
    required this.gender,
    this.birthday,
    this.quarantineRoom,
    required this.phoneNumber,
    required this.createdAt,
    this.quarantinedAt,
    this.quarantinedFinishExpectedAt,
    this.quarantineFloor,
    this.quarantineBuilding,
    required this.quarantineWard,
    required this.healthStatus,
    this.positiveTestNow,
    this.lastTested,
    this.lastTestedHadResult,
    required this.label,
    required this.numberOfVaccineDoses,
    this.quarantineLocation,
  });

  final String code;
  final String status;
  final String fullName;
  final String gender;
  final String? birthday;
  final KeyValue? quarantineRoom;
  final String phoneNumber;
  final String createdAt;
  final String? quarantinedAt;
  final String? quarantinedFinishExpectedAt;
  final KeyValue? quarantineFloor;
  final KeyValue? quarantineBuilding;
  final KeyValue? quarantineWard;
  final String healthStatus;
  final bool? positiveTestNow;
  final String? lastTested;
  final String? lastTestedHadResult;
  final String label;
  final String numberOfVaccineDoses;
  final String? quarantineLocation;

  factory FilterMember.fromJson(Map<String, dynamic> json) => FilterMember(
        code: json["code"],
        status: json["status"],
        fullName: json["full_name"],
        gender: json["gender"],
        birthday: json["birthday"],
        quarantineRoom: json["quarantine_room"] != null
            ? KeyValue.fromJson(json["quarantine_room"])
            : null,
        phoneNumber: json["phone_number"],
        createdAt: json["created_at"],
        quarantinedAt: json["quarantined_at"],
        quarantinedFinishExpectedAt: json["quarantined_finish_expected_at"],
        quarantineFloor: json["quarantine_floor"] != null
            ? KeyValue.fromJson(json["quarantine_floor"])
            : null,
        quarantineBuilding: json["quarantine_building"] != null
            ? KeyValue.fromJson(json["quarantine_building"])
            : null,
        quarantineWard: KeyValue.fromJson(json["quarantine_ward"]),
        healthStatus: json["health_status"],
        positiveTestNow: json["positive_test_now"],
        lastTested: json["last_tested"],
        lastTestedHadResult: json["last_tested_had_result"],
        label: json["label"],
        numberOfVaccineDoses: json["number_of_vaccine_doses"],
        quarantineLocation: (json['quarantine_room'] != null
                ? "${json['quarantine_room']['name']} - "
                : "") +
            (json['quarantine_floor'] != null
                ? "${json['quarantine_floor']['name']} - "
                : "") +
            (json['quarantine_building'] != null
                ? "${json['quarantine_building']['name']}"
                : ""),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "full_name": fullName,
        "gender": gender,
        "birthday": birthday,
        "quarantine_room": quarantineRoom?.toJson(),
        "phone_number": phoneNumber,
        "created_at": createdAt,
        "quarantined_at": quarantinedAt,
        "quarantined_finish_expected_at": quarantinedFinishExpectedAt,
        "quarantine_floor": quarantineFloor?.toJson(),
        "quarantine_building": quarantineBuilding?.toJson(),
        "quarantine_ward": quarantineWard?.toJson(),
        "health_status": healthStatus,
        "positive_test_now": positiveTestNow,
        "last_tested": lastTested,
        "last_tested_had_result": lastTestedHadResult,
        "label": label,
        "number_of_vaccine_doses": numberOfVaccineDoses,
      };

  @override
  String toString() {
    return "$code";
  }
}

class FilterResponse<T> {
  final int currentPage;
  final int totalPages;
  final int totalRows;
  final List<T> data;

  FilterResponse({
    this.data = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalRows = 0,
  });
}
