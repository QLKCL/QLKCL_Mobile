import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/utils/constant.dart';

Map<String, String> loginDataForm(
    {required String phoneNumber, required String password}) {
  return {'phone_number': phoneNumber, 'password': password};
}

Map<String, dynamic> registerDataForm(
    {required String phoneNumber,
    required String password,
    required String quarantineWard}) {
  return {
    'phone_number': phoneNumber,
    'password': password,
    'quarantine_ward_id': quarantineWard
  };
}

Map<String, dynamic> createMemberDataForm({
  required String phoneNumber,
  required String fullName,
  String? email,
  required String birthday,
  required String gender,
  required String nationality,
  required String country,
  required String city,
  required String district,
  required String ward,
  required String address,
  String? identity,
  String? healthInsurance,
  String? passport,
  required String quarantineWard,
  String? quarantineRoom,
  String? label,
  String? quarantinedAt,
  bool? positiveBefore,
  String? backgroundDisease,
  String? otherBackgroundDisease,
  String? numberOfVaccineDoses,
  String? careStaff,
  String? quarantineReason,
  String? professional,
  String? firstPositiveTestDate,
}) {
  final data = {
    "phone_number": phoneNumber,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "quarantine_room_id": quarantineRoom,
    "label": label,
    "quarantined_at": quarantinedAt,
    "positive_tested_before": positiveBefore,
    "background_disease": backgroundDisease,
    "other_background_disease": otherBackgroundDisease,
    "number_of_vaccine_doses": numberOfVaccineDoses,
    "care_staff_code": careStaff,
    "quarantine_reason": quarantineReason,
    "professional": professional,
    "first_positive_test_date": firstPositiveTestDate,
  };
  return prepareDataForm(data,
      exceptionField: ["quarantine_reason", "first_positive_test_date"]);
}

Map<String, dynamic> updateMemberDataForm({
  required String code,
  String? fullName,
  String? email,
  String? birthday,
  String? gender,
  String? nationality,
  String? country,
  String? city,
  String? district,
  String? ward,
  String? address,
  String? identity,
  String? healthInsurance,
  String? passport,
  String? quarantineWard,
  String? quarantineRoom,
  String? label,
  String? quarantinedAt,
  String? quarantinedFinishExpectedAt,
  bool? positiveBefore,
  String? backgroundDisease,
  String? otherBackgroundDisease,
  String? careStaff,
  String? quarantineReason,
  String? professional,
  String? firstPositiveTestDate,
}) {
  final data = {
    "code": code,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "quarantine_room_id": quarantineRoom,
    "label": label,
    "quarantined_at": quarantinedAt,
    "quarantined_finish_expected_at": quarantinedFinishExpectedAt,
    "positive_tested_before": positiveBefore,
    "background_disease": backgroundDisease,
    "other_background_disease": otherBackgroundDisease,
    "care_staff_code": careStaff,
    "quarantine_reason": quarantineReason,
    "professional": professional,
    "first_positive_test_date": firstPositiveTestDate,
  };
  return prepareDataForm(data,
      exceptionField: ["quarantine_reason", "first_positive_test_date"]);
}

Map<String, dynamic> filterMemberDataForm({
  required String keySearch,
  String? quarantineWard,
  String? quarantineBuilding,
  String? quarantineFloor,
  String? quarantineRoom,
  String? quarantineAtMin,
  String? quarantineAtMax,
  String? quarantinedFinishExpectedAtMin,
  String? quarantinedFinishExpectedAtMax,
  String? label,
  String? healthStatus,
  String? test,
  String? careStaff,
  required int page,
}) {
  final data = {
    "search": keySearch,
    "quarantine_ward_id": quarantineWard,
    "quarantine_building_id": quarantineBuilding,
    "quarantine_floor_id": quarantineFloor,
    "quarantine_room_id": quarantineRoom,
    "created_at_min": quarantineAtMin,
    "created_at_max": quarantineAtMax,
    "quarantined_finish_expected_at_min": quarantinedFinishExpectedAtMin,
    "quarantined_finish_expected_at_max": quarantinedFinishExpectedAtMax,
    "label_list": label,
    "health_status_list": healthStatus,
    "care_staff_code": careStaff,
    "positive_test_now_list": test,
    "page": page,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createTestDataForm({
  required String phoneNumber,
  String? status,
  String? type,
  String? result,
}) {
  final data = {
    "phone_number": phoneNumber,
    "status": status,
    "type": type,
    "result": result,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateTestDataForm({
  required String code,
  String? status,
  String? type,
  String? result,
}) {
  final data = {
    "code": code,
    "status": status,
    "type": type,
    "result": result,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterTestDataForm({
  required String keySearch,
  String? status,
  String? type,
  String? result,
  String? createAtMin,
  String? createAtMax,
  required int page,
}) {
  final data = {
    "search": keySearch,
    "status": status,
    "type": type,
    "result": result,
    "created_at_min": createAtMin,
    "created_at_max": createAtMax,
    "page": page,
  };
  return prepareDataForm(data);
}

Map<String, String> requestOtpDataForm({
  required String email,
}) {
  final data = {
    "email": email,
  };
  return prepareDataForm(data);
}

Map<String, String> sendOtpDataForm({
  required String email,
  required String otp,
}) {
  final data = {
    "email": email,
    'otp': otp,
  };
  return prepareDataForm(data);
}

Map<String, String> createPassDataForm({
  required String email,
  required String otp,
  required String newPassword,
  required String confirmPassword,
}) {
  final data = {
    "email": email,
    'confirm_otp': otp,
    'new_password': newPassword,
    'confirm_password': confirmPassword,
  };
  return prepareDataForm(data);
}

Map<String, String> changePassDataForm({
  required String oldPassword,
  required String newPassword,
  required String confirmPassword,
}) {
  final data = {
    'old_password': oldPassword,
    'new_password': newPassword,
    'confirm_password': confirmPassword,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createQuarantineDataForm({
  required String email,
  required String fullName,
  required String country,
  required String city,
  required String district,
  required String ward,
  String? address,
  String? latitude,
  String? longtitude,
  required String status,
  String? type,
  String? phoneNumber,
  required String mainManager,
  String? image,
  String? pandemic,
}) {
  final data = {
    "email": email,
    "full_name": fullName,
    "country": country,
    "city": city,
    "district": district,
    "ward": ward,
    "address": address,
    "latitude": latitude,
    "longtitude": longtitude,
    "staus": status,
    "type": type,
    "main_manager": mainManager,
    "phone_number": phoneNumber,
    "image": image,
    "pandemic_id": pandemic,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createRoomDataForm({
  required String capacity,
  required int quarantineFloor,
  required String name,
}) {
  final data = {
    "name": name,
    "quarantine_floor": quarantineFloor,
    "capacity": capacity,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateQuarantineDataForm({
  required int id,
  String? email,
  String? fullName,
  String? country,
  String? city,
  String? district,
  String? ward,
  String? address,
  String? latitude,
  String? longtitude,
  String? status,
  String? type,
  int? quarantineTime,
  String? mainManager,
  String? phoneNumber,
  String? image,
  String? pandemic,
}) {
  final data = {
    "id": id,
    "email": email,
    "full_name": fullName,
    "country": country,
    "city": city,
    "district": district,
    "ward": ward,
    "address": address,
    "latitude": latitude,
    "longtitude": longtitude,
    "status": status,
    "type": type,
    "phone_number": phoneNumber,
    "quarantine_time": quarantineTime,
    "main_manager": mainManager,
    "image": image,
    "pandemic_id": pandemic,
  };
  return prepareDataForm(data, exceptionField: ["image"]);
}

Map<String, dynamic> filterQuarantineDataForm({
  required String keySearch,
  String? createAtMin,
  String? createAtMax,
  String? pandemicId,
  required int page,
  String? city,
  String? district,
  String? ward,
  String? mainManager,
}) {
  final data = {
    "search": keySearch,
    "created_at_min": createAtMin,
    "created_at_max": createAtMax,
    'pandemic_id': pandemicId,
    "country": "VNM",
    "city": city,
    "district": district,
    "ward": ward,
    "main_manager": mainManager,
    "page": page,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createBuildingDataForm({
  required String name,
  required int quarantineWard,
}) {
  final data = {
    "name": name,
    "quarantine_ward": quarantineWard,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateBuildingDataForm({
  String? name,
  int? quarantineWard,
  required int id,
}) {
  final data = {
    "id": id,
    "quarantine_ward": quarantineWard,
    "name": name,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateFloorDataForm({
  String? name,
  int? quarantineBuilding,
  required int id,
}) {
  final data = {
    "id": id,
    "quarantine_building": quarantineBuilding,
    "name": name,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createFloorDataForm({
  required int quarantineBuilding,
  required String name,
  required String roomQuantity,
}) {
  final data = {
    "name": name,
    "quarantine_building": quarantineBuilding,
    "room_quantity": roomQuantity,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateRoomDataForm({
  String? name,
  int? quarantineFloor,
  int? capacity,
  required int id,
}) {
  final data = {
    "id": id,
    // "quarantine_floor": quarantineFloor,
    "name": name,
    "capacity": capacity,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterMemberByRoomDataForm({
  int? quarantineWard,
  int? quarantineBuilding,
  int? quarantineFloor,
  int? quarantineRoom,
}) {
  final data = {
    "quarantine_ward_id": quarantineWard,
    "quarantine_building_id": quarantineBuilding,
    "quarantine_floor_id": quarantineFloor,
    "quarantine_room_id": quarantineRoom,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createMedDeclDataForm({
  String? phoneNumber,
  int? heartBeat,
  double? temperature,
  int? breathing,
  double? spo2,
  double? bloodPressure,
  String? mainSymtoms,
  String? extraSymtoms,
  String? otherSymtoms,
}) {
  final data = {
    "phone_number": phoneNumber,
    "heartbeat": heartBeat,
    "temperature": temperature,
    "breathing": breathing,
    "spo2": spo2,
    "blood_pressure": bloodPressure,
    "main_symptoms": mainSymtoms,
    "extra_symptoms": extraSymtoms,
    "other_symptoms": otherSymtoms,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterMedDeclDataForm({
  String? userCode,
  String? createAtMax,
  String? createAtMin,
  int? page,
  int? pageSize,
  String? search,
}) {
  final data = {
    "user_code": userCode,
    "created_at_max": createAtMax,
    "created_at_min": createAtMin,
    "page": page,
    "page_size": pageSize,
    "search": search,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> acceptOneMemberDataForm({
  required String code,
  String? quarantineRoom,
  String? quarantinedAt,
  String? staffCode,
}) {
  final data = {
    "code": code,
    "quarantine_room_id": quarantineRoom,
    "quarantined_at": quarantinedAt,
    "care_staff_code": staffCode,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> changeRoomMemberDataForm({
  required String code,
  required String quarantineWard,
  String? quarantineRoom,
  String? staffCode,
}) {
  final data = {
    "custom_user_code": code,
    "quarantine_ward_id": quarantineWard,
    "quarantine_room_id": quarantineRoom,
    "care_staff_code": staffCode,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createNotificationDataForm({
  required String title,
  required String description,
  required int receiverType,
  int? role,
  int? quarantineWard,
  String? users,
  String? image,
  String? url,
  String? type,
}) {
  final data = {
    "title": title,
    "description": description,
    "receiver_type": receiverType,
    "role": role,
    "quarantine_ward": quarantineWard,
    "users": users,
    "image": image,
    "type": type,
    "url": url,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createDestiantionHistoryDataForm({
  required String code,
  required String country,
  required String city,
  String? district,
  String? ward,
  String? address,
  required String startTime,
  String? endTime,
  String? note,
}) {
  final data = {
    "user_code": code,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "start_time": startTime,
    "end_time": endTime,
    "note": note
  };
  return prepareDataForm(data);
}

Map<String, dynamic> getAddressWithMembersPassByDataForm({
  required String addressType,
  String? fatherAddressId,
  String? quarantineWardId,
  String? startTimeMin,
  String? startTimeMax,
  String? page,
  String? pageSize,
  String? orderBy,
  String? search,
}) {
  final data = {
    "address_type": addressType,
    "father_address_id": fatherAddressId,
    "quarantine_ward_id": quarantineWardId,
    "start_time_min": startTimeMin,
    "start_time_max": startTimeMax,
    "page": page,
    "page_size": pageSize ?? pageSizeMax,
    "order_by": orderBy,
    "search": search
  };
  return prepareDataForm(data);
}

Map<String, String> syncVaccinePortalDataForm(
    {required String fullName,
    required String birthday,
    required String gender,
    required String phoneNumber,
    String? identityNumber,
    String? healthInsuranceNumber,
    String? otpNumber}) {
  final data = {
    "fullname": fullName,
    "birthday": birthday,
    "genderId": gender,
    "personalPhoneNumber": phoneNumber,
    "identification": identityNumber,
    "healthInsuranceNumber": healthInsuranceNumber,
    "otp": otpNumber
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createManagerDataForm({
  required String phoneNumber,
  required String fullName,
  String? email,
  required String birthday,
  required String gender,
  required String nationality,
  required String country,
  required String city,
  required String district,
  required String ward,
  required String address,
  String? identity,
  String? healthInsurance,
  String? passport,
  required String quarantineWard,
  String? professional,
}) {
  final data = {
    "phone_number": phoneNumber,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "professional": professional,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateManagerDataForm({
  required String code,
  String? fullName,
  String? email,
  String? birthday,
  String? gender,
  String? nationality,
  String? country,
  String? city,
  String? district,
  String? ward,
  String? address,
  String? identity,
  String? healthInsurance,
  String? passport,
  String? quarantineWard,
  String? professional,
}) {
  final data = {
    "code": code,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "professional": professional,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createStaffDataForm({
  required String phoneNumber,
  required String fullName,
  String? email,
  required String birthday,
  required String gender,
  required String nationality,
  required String country,
  required String city,
  required String district,
  required String ward,
  required String address,
  String? identity,
  String? healthInsurance,
  String? passport,
  required String quarantineWard,
  String? careArea,
  String? professional,
}) {
  final data = {
    "phone_number": phoneNumber,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "care_area": careArea,
    "professional": professional,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> updateStaffDataForm({
  required String code,
  String? fullName,
  String? email,
  String? birthday,
  String? gender,
  String? nationality,
  String? country,
  String? city,
  String? district,
  String? ward,
  String? address,
  String? identity,
  String? healthInsurance,
  String? passport,
  String? quarantineWard,
  String? careArea,
  String? professional,
}) {
  final data = {
    "code": code,
    "full_name": fullName,
    "email": email,
    "birthday": birthday,
    "gender": gender,
    "nationality_code": nationality,
    "country_code": country,
    "city_id": city,
    "district_id": district,
    "ward_id": ward,
    "detail_address": address,
    "health_insurance_number": healthInsurance,
    "identity_number": identity,
    "passport_number": passport,
    "quarantine_ward_id": quarantineWard,
    "care_area": careArea,
    "professional": professional,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterStaffDataForm({
  required String keySearch,
  String? quarantineWard,
  String? statusList,
  String? isLastTested,
  String? careArea,
  String? quarantineAtMin,
  String? quarantineAtMax,
  String? pageSize,
  String? healthStatusList,
  String? positiveTestNowList,
  required int page,
}) {
  final data = {
    "search": keySearch,
    "status_list": statusList,
    "is_last_tested": isLastTested,
    "quarantine_ward_id": quarantineWard,
    "created_at_min": quarantineAtMin,
    "created_at_max": quarantineAtMax,
    "care_area": careArea,
    "health_status_list": healthStatusList,
    "positive_test_now_list": positiveTestNowList,
    "page": page,
    "page_size": pageSize,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> getSuitableRoomDataForm({
  required String quarantineWard,
  required String gender,
  required String label,
  required String numberOfVaccineDoses,
  String? positiveTestNow,
  String? oldQuarantineRoomId,
  String? notQuarantineRoomIds,
}) {
  final data = {
    "quarantine_ward_id": quarantineWard,
    "gender": gender,
    "label": label,
    "number_of_vaccine_doses": numberOfVaccineDoses,
    "positive_test_now": positiveTestNow,
    "old_quarantine_room_id": oldQuarantineRoomId,
    "not_quarantine_room_ids": notQuarantineRoomIds,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createVaccineDoseDataForm({
  required String vaccineId,
  required String userCode,
  required String injectionDate,
  String? injectionPlace,
  String? batchNumber,
  String? symptomAfterInjected,
}) {
  final data = {
    "vaccine_id": vaccineId,
    "custom_user_code": userCode,
    "injection_date": injectionDate,
    "injection_place": injectionPlace,
    "batch_number": batchNumber,
    "symptom_after_injected": symptomAfterInjected,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> requarantineMemberDataForm({
  required String code,
  required String quarantineWard,
  required String label,
  String? quarantineRoom,
  String? quarantinedAt,
  String? careStaff,
  bool? positiveTestedBefore,
  String? quarantineReason,
  String? firstPositiveTestDate,
}) {
  final data = {
    "code": code,
    "quarantine_ward_id": quarantineWard,
    "label": label,
    "positive_tested_before": positiveTestedBefore,
    "quarantined_at": quarantinedAt,
    "quarantine_room_id": quarantineRoom,
    "care_staff_code": careStaff,
    "quarantine_reason": quarantineReason,
    "first_positive_test_date": firstPositiveTestDate,
  };
  return prepareDataForm(data,
      exceptionField: ["quarantine_reason", "first_positive_test_date"]);
}
