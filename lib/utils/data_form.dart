import 'package:qlkcl/helper/function.dart';

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
}) {
  var data = {
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
  };
  return prepareDataForm(data);
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
}) {
  var data = {
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
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterMemberDataForm({
  required String keySearch,
  String? quarantineWard,
  String? quarantineBuilding,
  String? quarantineFloor,
  String? quarantineRoom,
  String? quarantineAtMin,
  String? quarantineAtMax,
  String? quarantinedFinishExpectedAt,
  String? label,
  String? healthStatus,
  String? test,
  String? careStaff,
  required int page,
}) {
  var data = {
    "search": keySearch,
    "quarantine_ward_id": quarantineWard,
    "quarantine_building_id": quarantineBuilding,
    "quarantine_floor_id": quarantineFloor,
    "quarantine_room_id": quarantineRoom,
    "created_at_min": quarantineAtMin,
    "created_at_max": quarantineAtMax,
    "quarantined_finish_expected_at_max": quarantinedFinishExpectedAt,
    "label_list": label,
    "health_status_list": healthStatus,
    "care_staff_code": careStaff,
    "positive_test_now_list": test,
    "page": page,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createTestDataForm({
  required String userCode,
  String? status,
  String? type,
  String? result,
}) {
  var data = {
    "user_code": userCode,
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
  var data = {
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
  var data = {
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
  var data = {
    "email": email,
  };
  return prepareDataForm(data);
}

Map<String, String> sendOtpDataForm({
  required String email,
  required String otp,
}) {
  var data = {
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
  var data = {
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
  var data = {
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
  required int quarantineTime,
  required String mainManager,
  String? image,
}) {
  var data = {
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
    "quarantine_time": quarantineTime,
    "main_manager": mainManager,
    "phone_number": phoneNumber,
    "image": image,
  };
  return prepareDataForm(data);
}

Map<String, dynamic> createRoomDataForm({
  required String capacity,
  required int quarantineFloor,
  required String name,
}) {
  var data = {
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
}) {
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
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
  var data = {
    "address_type": addressType,
    "father_address_id": fatherAddressId,
    "quarantine_ward_id": quarantineWardId,
    "start_time_min": startTimeMin,
    "start_time_max": startTimeMax,
    "page": page,
    "page_size": pageSize ?? 0,
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
  var data = {
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
}) {
  var data = {
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
}) {
  var data = {
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
}) {
  var data = {
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
}) {
  var data = {
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
  };
  return prepareDataForm(data);
}

Map<String, dynamic> filterStaffDataForm({
  required String keySearch,
  String? quarantineWard,
  String? status,
  String? isLastTested,
  String? careArea,
  String? quarantineAtMin,
  String? quarantineAtMax,
  String? pageSize,
  String? healthStatus,
  String? test,
  required int page,
}) {
  var data = {
    "search": keySearch,
    "status": status,
    "is_last_tested": isLastTested,
    "quarantine_ward_id": quarantineWard,
    "created_at_min": quarantineAtMin,
    "created_at_max": quarantineAtMax,
    "care_area": careArea,
    "health_status_list": healthStatus,
    "positive_test_now": test,
    "page": page,
    "page_size": pageSize,
  };
  return prepareDataForm(data);
}
