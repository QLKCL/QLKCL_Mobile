// To parse this JSON data, do
//
//     final floor = floorFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

Floor floorFromJson(String str) => Floor.fromJson(json.decode(str));

String floorToJson(Floor data) => json.encode(data.toJson());

class Floor {
    Floor({
        required this.id,
        required this.name,
        required this.quarantineBuilding,
        required this.numCurrentMember,
        this.totalCapacity,
    });

    final int id;
    final String name;
    final int quarantineBuilding;
    final int numCurrentMember;
    final int? totalCapacity;

    factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json["id"],
        name: json["name"],
        quarantineBuilding: json["quarantine_building"],
        numCurrentMember: json["num_current_member"],
        totalCapacity: json["total_capacity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quarantine_building": quarantineBuilding,
        "num_current_member": numCurrentMember,
        "total_capacity": totalCapacity,
    };
}

Future<dynamic> fetchFloor({id}) async {
  ApiHelper api = ApiHelper();
  final response = await api.getHTTP(Constant.getFloor + '?id=' + id);
  return response["data"];
}

Future<dynamic> createFloor(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createFloor, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true,
          message: "Tạo tầng thành công!",
          data: response['data']);
    } else {
       print(response['message']);
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

Future<dynamic> fetchFloorList(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListFloor, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}

Future<int> fetchNumOfFloor(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListFloor, data);
  return response != null && response['data'] != null
      ? response['data']['totalRows']
      : null;
}