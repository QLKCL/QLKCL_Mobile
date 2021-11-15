import 'package:qlkcl/models/key_value.dart';

class Constant {
  static const String baseUrl = 'https://qlkcl.herokuapp.com';
  static const String login = '/api/token';
  static const String register = '/api/user/member/register';
  static const String getMember = '/api/user/member/get';
  static const String getListMembers = '/api/user/member/filter';
  static const String createMember = '/api/user/member/create';
  static const String homeManager = '/api/user/home/manager';
  static const String getListTests = '/api/form/test/filter';
  static const String createTest = '/api/form/test/create';
  static const String updateTest = '/api/form/test/update';
  static const String getTest = '/api/form/test/get';
  static const String getQuarantine = '/api/quarantine_ward/ward/get';
  static const String getListQuarantine = '/api/quarantine_ward/ward/filter';
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

List<KeyValue> testStateList = [
  KeyValue(id: "WAITING", name: "Đang chờ kết quả"),
  KeyValue(id: "DONE", name: "Đã có kết quả")
];

List<KeyValue> testTypeList = [
  KeyValue(id: "QUICK", name: "Test nhanh"),
  KeyValue(id: "RT-PCR", name: "Real time PCR")
];

List<KeyValue> testValueList = [
  KeyValue(id: "NONE", name: "Chưa có kết quả"),
  KeyValue(id: "NEGATIVE", name: "Âm tính"),
  KeyValue(id: "POSITIVE", name: "Dương tính")
];

List<KeyValue> roleList = [
  KeyValue(id: "1", name: "ADMINISTRATOR"),
  KeyValue(id: "2", name: "SUPER_MANAGER"),
  KeyValue(id: "3", name: "MANAGER"),
  KeyValue(id: "4", name: "STAFF"),
  KeyValue(id: "5", name: "MEMBER"),
];

const int PAGE_SIZE = 10;
