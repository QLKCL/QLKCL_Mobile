// To parse this JSON data, do
//
//     final vaccineDose = vaccineDoseFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/api.dart';
import 'package:intl/intl.dart';

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
  final KeyValue customUser;
  final DateTime injectionDate;
  final dynamic injectionPlace;
  final dynamic batchNumber;
  final dynamic symptomAfterInjected;

  factory VaccineDose.fromJson(Map<String, dynamic> json) => VaccineDose(
        id: json["id"],
        vaccine: Vaccine.fromJson(json["vaccine"]),
        customUser: KeyValue.fromJson(json["custom_user"]),
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

// To parse this JSON data, do
//
//     final vaccinationCertification = vaccinationCertificationFromJson(jsonString);

VaccinationCertification vaccinationCertificationFromJson(String str) =>
    VaccinationCertification.fromJson(json.decode(str));

String vaccinationCertificationToJson(VaccinationCertification data) =>
    json.encode(data.toJson());

class VaccinationCertification {
  VaccinationCertification({
    required this.patientInfo,
    required this.qrCode,
  });

  final PatientInfo patientInfo;
  final String qrCode;

  factory VaccinationCertification.fromJson(Map<String, dynamic> json) =>
      VaccinationCertification(
        patientInfo: PatientInfo.fromJson(json["patientInfo"]),
        qrCode: json["qrCode"],
      );

  Map<String, dynamic> toJson() => {
        "patientInfo": patientInfo.toJson(),
        "qrCode": qrCode,
      };
}

class PatientInfo {
  PatientInfo({
    required this.fullname,
    required this.birthday,
    required this.personalPhoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.identification,
    required this.fullyVaccinated,
    required this.currentProvinceId,
    required this.currentDistrictId,
    required this.currentWardId,
    required this.vaccinatedInfoes,
  });

  final String fullname;
  final String birthday;
  final String personalPhoneNumber;
  final String province;
  final String district;
  final String ward;
  final String identification;
  final int fullyVaccinated;
  final String currentProvinceId;
  final String currentDistrictId;
  final String currentWardId;
  final List<VaccinatedInfoe> vaccinatedInfoes;

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
        fullname: json["fullname"],
        birthday: DateFormat("dd/MM/yyyy")
            .format(DateTime.fromMillisecondsSinceEpoch(json["birthday"])),
        personalPhoneNumber: json["personalPhoneNumber"],
        province: json["province"],
        district: json["district"],
        ward: json["ward"],
        identification: json["identification"],
        fullyVaccinated: json["fullyVaccinated"],
        currentProvinceId: json["currentProvinceId"],
        currentDistrictId: json["currentDistrictId"],
        currentWardId: json["currentWardId"],
        vaccinatedInfoes: List<VaccinatedInfoe>.from(
            json["vaccinatedInfoes"].map((x) => VaccinatedInfoe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "birthday": birthday,
        "personalPhoneNumber": personalPhoneNumber,
        "province": province,
        "district": district,
        "ward": ward,
        "identification": identification,
        "fullyVaccinated": fullyVaccinated,
        "currentProvinceId": currentProvinceId,
        "currentDistrictId": currentDistrictId,
        "currentWardId": currentWardId,
        "vaccinatedInfoes":
            List<dynamic>.from(vaccinatedInfoes.map((x) => x.toJson())),
      };
}

class VaccinatedInfoe {
  VaccinatedInfoe({
    required this.vaccineId,
    required this.vaccineName,
    required this.injectionDate,
    required this.injectionPlace,
    required this.batchNumber,
  });

  final String vaccineId;
  final String vaccineName;
  final int injectionDate;
  final String injectionPlace;
  final String batchNumber;

  factory VaccinatedInfoe.fromJson(Map<String, dynamic> json) =>
      VaccinatedInfoe(
        vaccineId: json["vaccineId"],
        vaccineName: json["vaccineName"],
        injectionDate: json["injectionDate"],
        injectionPlace: json["injectionPlace"],
        batchNumber: json["batchNumber"],
      );

  Map<String, dynamic> toJson() => {
        "vaccineId": vaccineId,
        "vaccineName": vaccineName,
        "injectionDate": injectionDate,
        "injectionPlace": injectionPlace,
        "batchNumber": batchNumber,
      };
}
