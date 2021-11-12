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
  required bool positiveBefore,
  String? backgroundDisease,
  String? otherBackgroundDisease,
}) {
  return {
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
    "positive_tested_before": false,
    "background_disease": "",
    "other_background_disease": "",
  };
}
