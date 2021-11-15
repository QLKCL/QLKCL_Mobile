import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

KeyValue keyValueFromJson(str) => KeyValue.fromJson(json.decode(str));

String keyValueToJson(KeyValue data) => json.encode(data.toJson());

class KeyValue {
  var name;
  var id;
  KeyValue({required this.name, required this.id});
  factory KeyValue.fromJson(Map<String, dynamic> json) => KeyValue(
        id: json["code"] ?? json["id"],
        name: json["name"] ?? json["full_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static List<KeyValue> fromJsonList(List list) {
    return list.map((item) => KeyValue.fromJson(item)).toList();
  }
}

Future<List<KeyValue>> fetchCountry() async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListCountry, null);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchCity(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListCity, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchDistrict(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListDistrict, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchWard(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListWard, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineWard() async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListQuarantine, null);
  final dataResponse = response['data']['content'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineBuilding(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListBuilding, data);
  final dataResponse = response['data']['content'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineFloor(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListFloor, data);
  final dataResponse = response['data']['content'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineRoom(data) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getListRoom, data);
  final dataResponse = response['data']['content'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}
