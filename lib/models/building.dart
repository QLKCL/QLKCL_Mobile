// To parse this JSON data, do
//
//     final building = buildingFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

Building buildingFromJson(String str) => Building.fromJson(json.decode(str));

String buildingToJson(Building data) => json.encode(data.toJson());

class Building {
    Building({
        required this.id,
        required this.name,
        required this.quarantineWard,
        required this.numCurrentMember,
        this.totalCapacity,
    });

    final int id;
    final String name;
    final int quarantineWard;
    final int numCurrentMember;
    final int? totalCapacity;

    factory Building.fromJson(Map<String, dynamic> json) => Building(
        id: json["id"],
        name: json["name"],
        quarantineWard: json["quarantine_ward"],
        numCurrentMember: json["num_current_member"],
        totalCapacity: json["total_capacity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quarantine_ward": quarantineWard,
        "num_current_member": numCurrentMember,
        "total_capacity": totalCapacity,
    };
}

Future<dynamic> fetchBuilding({id}) async {
  ApiHelper api = ApiHelper();
  final response = await api.getHTTP(Constant.getBuilding + '?id=' + id);
  return response["data"];
}

//fetchBuildingList is in quarantine.dart

Future<dynamic> createBuilding(Map<String, dynamic> data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.createBuilding, data);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          success: true,
          message: "Tạo tòa thành công!",
          data: response['data']);
    } else {
       print(response['message']);
      // return Response(success: false, message: jsonEncode(response['message']));
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

