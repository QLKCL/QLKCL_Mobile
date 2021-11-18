// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room({
    required this.id,
    required this.numCurrentMember,
    required this.name,
    required this.capacity,
    required this.quarantineFloor,
  });

  final int id;
  final int numCurrentMember;
  final String name;
  final int capacity;
  final dynamic quarantineFloor;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        numCurrentMember: json["num_current_member"],
        name: json["name"],
        capacity: json["capacity"],
        quarantineFloor: json["quarantine_floor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num_current_member": numCurrentMember,
        "name": name,
        "capacity": capacity,
        "quarantine_floor": quarantineFloor,
      };
}

Future<dynamic> fetchRoom({id}) async {
  ApiHelper api = ApiHelper();
  final response = await api.getHTTP(Constant.getRoom + '?id=' + id);
  return response["data"];
}

Future<dynamic> createRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createRoom, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      print('response data');
      print(response['data']);
      return Response(
          success: true,
          message: "Tạo phòng thành công!",
          data: response['data']);
    } else {
      print('response mes');
      print(response['message']);
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> fetchRoomList(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListRoom, data);
  print(response['data']['content']);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<int> fetchNumOfRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListRoom, data);
  return response != null && response['data'] != null
      ? response['data']['totalRows']
      : null;
}

Future<dynamic> updateRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.updateRoom, data);
  print('response data');
  print(response['data']);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true,
          message: "Cập nhật thông tin thành công!",
          data: response['data']);
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
