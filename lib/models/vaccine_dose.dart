// To parse this JSON data, do
//
//     final vaccineDose = vaccineDoseFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/api.dart';

VaccineDose vaccineDoseFromJson(String str) =>
    VaccineDose.fromJson(json.decode(str));

String vaccineDoseToJson(VaccineDose data) => json.encode(data.toJson());

class VaccineDose {
  VaccineDose({
    required this.id,
    required this.vaccine,
    required this.customUser,
    required this.injectionDate,
    required this.injectionPlace,
    required this.batchNumber,
    required this.symptomAfterInjected,
  });

  final int id;
  final Vaccine vaccine;
  final CustomUser customUser;
  final DateTime injectionDate;
  final dynamic injectionPlace;
  final dynamic batchNumber;
  final dynamic symptomAfterInjected;

  factory VaccineDose.fromJson(Map<String, dynamic> json) => VaccineDose(
        id: json["id"],
        vaccine: Vaccine.fromJson(json["vaccine"]),
        customUser: CustomUser.fromJson(json["custom_user"]),
        injectionDate: DateTime.parse(json["injection_date"]),
        injectionPlace: json["injection_place"],
        batchNumber: json["batch_number"],
        symptomAfterInjected: json["symptom_after_injected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vaccine": vaccine.toJson(),
        "custom_user": customUser.toJson(),
        "injection_date": injectionDate.toIso8601String(),
        "injection_place": injectionPlace,
        "batch_number": batchNumber,
        "symptom_after_injected": symptomAfterInjected,
      };
}

class CustomUser {
  CustomUser({
    required this.code,
    required this.fullName,
  });

  final String code;
  final String fullName;

  factory CustomUser.fromJson(Map<String, dynamic> json) => CustomUser(
        code: json["code"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "full_name": fullName,
      };
}

class Vaccine {
  Vaccine({
    required this.id,
    required this.name,
    required this.manufacturer,
  });

  final int id;
  final String name;
  final String manufacturer;

  factory Vaccine.fromJson(Map<String, dynamic> json) => Vaccine(
        id: json["id"],
        name: json["name"],
        manufacturer: json["manufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "manufacturer": manufacturer,
      };
}

Future<dynamic> fetchVaccineDose({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getVaccineDose, data);
  return response["data"];
}

Future<dynamic> fetchVaccineDoseList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.filterVaccineDose, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}
