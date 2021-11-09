import 'package:qlkcl/models/key_value.dart';

class Constant {
  static const String baseUrl = 'https://qlkcl.herokuapp.com';
  static const String getMember = '/api/user/member/get';
}

enum Permission {
  add,
  edit,
  view,
  delete,
}

List<KeyValue> genderList = [
  KeyValue(id: "MALE", name: "Nam"),
  KeyValue(id: "FEMALE", name: "Nữ")
];
