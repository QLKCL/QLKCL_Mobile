Map<String, String> loginDataForm(String phoneNumber, String password) {
  return {'phone_number': phoneNumber, 'password': password};
}

Map<String, dynamic> registerDataForm(
    String phoneNumber, String password, String quarantineWard) {
  return {
    'phone_number': phoneNumber,
    'password': password,
    'quarantine_ward_id': quarantineWard
  };
}
