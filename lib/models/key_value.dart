import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/api.dart';

KeyValue keyValueFromJson(str) => KeyValue.fromJson(json.decode(str));

String keyValueToJson(KeyValue data) => json.encode(data.toJson());

@immutable
class KeyValue {
  final dynamic name;
  final dynamic id;
  const KeyValue({required this.name, required this.id});
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

  @override
  String toString() {
    return '$id - $name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyValue && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => name.hashCode & id.hashCode;
}

Future<List<KeyValue>> fetchCountry() async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListCountry, null);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchCity(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListCity, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchDistrict(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListDistrict, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchWard(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListWard, data);
  final dataResponse = response['data'];
  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineWard(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListQuarantine, data);

  if (response['data'] != null) {
    final dataResponse = response['data']['content'];
    if (dataResponse != null) {
      return KeyValue.fromJsonList(dataResponse);
    }
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineBuilding(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListBuilding, data);

  if (response['data'] != null) {
    final dataResponse = response['data']['content'];
    if (dataResponse != null) {
      return KeyValue.fromJsonList(dataResponse);
    }
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineFloor(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListFloor, data);

  if (response['data'] != null) {
    final dataResponse = response['data']['content'];
    if (dataResponse != null) {
      return KeyValue.fromJsonList(dataResponse);
    }
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineRoom(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListRoom, data);

  if (response['data'] != null) {
    final dataResponse = response['data']['content'];
    if (dataResponse != null) {
      return KeyValue.fromJsonList(dataResponse);
    }
  }
  return [];
}

Future<List<KeyValue>> fetchQuarantineWardNoToken(data) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse(Api.baseUrl + Api.getListQuarantineNoToken),
            headers: {
              'Accept': 'application/json',
            },
            body: data);
  } catch (e) {
    print('Error: $e');
  }
  if (response != null) {
    final resp = response.body;
    final dataResponse = jsonDecode(resp);
    if (dataResponse != null) {
      return KeyValue.fromJsonList(dataResponse['data']);
    }
  }
  return [];
}

Future<List<KeyValue>> fetchNotMemberList(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListNotMem, data);
  final dataResponse = response['data'];

  if (dataResponse != null) {
    return KeyValue.fromJsonList(dataResponse);
  }
  return [];
}

class CustomKeyValue {
  dynamic name;
  dynamic id;
  CustomKeyValue({required this.name, required this.id});
  factory CustomKeyValue.fromJson(Map<String, dynamic> json) => CustomKeyValue(
        id: json["id"],
        name: '${json["name"]} - ${json["quarantine_building"]["name"]}',
      );

  static List<KeyValue> fromJsonList(List list) {
    return list
        .map((item) => KeyValue(
            name: CustomKeyValue.fromJson(item).name,
            id: CustomKeyValue.fromJson(item).id))
        .toList();
  }

  @override
  String toString() {
    return '$id - $name';
  }
}

Future<List<KeyValue>> fetchCustomQuarantineFloor(data) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getListFloor, data);

  if (response['data'] != null) {
    final dataResponse = response['data']['content'];
    if (dataResponse != null) {
      return CustomKeyValue.fromJsonList(dataResponse);
    }
  }
  return [];
}
