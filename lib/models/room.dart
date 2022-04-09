// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

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
  var response = await api.getHTTP(Api.getRoom + '?id=' + id);
  return response["data"];
}

Future<dynamic> createRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.createRoom, data);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Tạo phòng thành công!",
          data: response['data']);
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> fetchRoomList(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.getListRoom, data);

  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<int> fetchNumOfRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.getListRoom, data);
  return response != null && response['data'] != null
      ? response['data']['totalRows']
      : null;
}

Future<Response> updateRoom(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  var response = await api.postHTTP(Api.updateRoom, data);

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Cập nhật thông tin thành công!",
          data: Room.fromJson(response['data']));
    } else if (response['error_code'] == 400) {
      if (response['message']['name'] != null &&
          response['message']['name'] == "Exist") {
        return Response(status: Status.error, message: 'Tên phòng đã tồn tại!');
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
