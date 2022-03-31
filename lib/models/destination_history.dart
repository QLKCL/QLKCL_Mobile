// To parse this JSON data, do
//
//     final destinationHistory = destinationHistoryFromJson(jsonString);

import 'package:qlkcl/models/key_value.dart';
import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';
import 'package:qlkcl/utils/constant.dart';

DestinationHistory destinationHistoryFromJson(String str) =>
    DestinationHistory.fromJson(json.decode(str));

String destinationHistoryToJson(DestinationHistory data) =>
    json.encode(data.toJson());

class DestinationHistory {
  DestinationHistory({
    required this.id,
    required this.user,
    required this.country,
    required this.city,
    required this.district,
    required this.ward,
    required this.detailAddress,
    required this.startTime,
    required this.endTime,
    required this.note,
  });

  final int id;
  final KeyValue user;
  final KeyValue country;
  final KeyValue city;
  final KeyValue district;
  final KeyValue ward;
  final String detailAddress;
  final DateTime startTime;
  final DateTime endTime;
  final String note;

  factory DestinationHistory.fromJson(Map<String, dynamic> json) =>
      DestinationHistory(
        id: json["id"],
        user: KeyValue.fromJson(json["user"]),
        country: KeyValue.fromJson(json["country"]),
        city: KeyValue.fromJson(json["city"]),
        district: KeyValue.fromJson(json["district"]),
        ward: KeyValue.fromJson(json["ward"]),
        detailAddress: json["detail_address"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "country": country.toJson(),
        "city": city.toJson(),
        "district": district.toJson(),
        "ward": ward.toJson(),
        "detail_address": detailAddress,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "note": note,
      };
}

Future<dynamic> fetchDestiantionHistoryList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.filterDestiantionHistory, data);

  return response != null && response['data'] != null ? response['data'] : null;
}

Future<dynamic> fetchDestiantionHistory({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getDestiantionHistory, data);
  return response["data"];
}

Future<Response> createDestiantionHistory(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.createDestiantionHistory, data);

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Khai báo thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message']['user_code'] != null &&
          response['message']['user_code'] == "empty") {
        return Response(success: false, message: "Lỗi người khai báo!");
      } else if (response['message']['country_code'] != null &&
          response['message']['country_code'] == "empty") {
        return Response(
            success: false, message: "Quốc gia không được để trống!");
      } else if (response['message']['city_id'] != null &&
          response['message']['city_id'] == "empty") {
        return Response(
            success: false, message: "Tỉnh, thành phố không được để trống!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> updateDestiantionHistory(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.updateTest, data);

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Cập nhật khai báo thành công!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> getCityWithMembersPassBy({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(
      Api.getCityWithMembersPassBy, data ?? {'page_size': PAGE_SIZE_MAX});

  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}
