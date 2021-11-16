import 'package:qlkcl/models/key_value.dart';

class Constant {
  static const String baseUrl = 'https://qlkcl.herokuapp.com';
  static const String login = '/api/token';
  static const String register = '/api/user/member/register';
  static const String getMember = '/api/user/member/get';
  static const String getListMembers = '/api/user/member/filter';
  static const String createMember = '/api/user/member/create';
  static const String updateMember = '/api/user/member/update';
  static const String denyMember = '/api/user/member/refuse';
  static const String acceptMember = '/api/user/member/accept';
  static const String homeManager = '/api/user/home/manager';
  static const String getListTests = '/api/form/test/filter';
  static const String createTest = '/api/form/test/create';
  static const String updateTest = '/api/form/test/update';
  static const String getTest = '/api/form/test/get';
  static const String getQuarantine = '/api/quarantine_ward/ward/get';
  static const String getListQuarantine = '/api/quarantine_ward/ward/filter';
  static const String getListQuarantineNoToekn =
      '/api/quarantine_ward/ward/filter_register';
  static const String getListCountry = '/api/address/country/filter';
  static const String getListCity = '/api/address/city/filter';
  static const String getListDistrict = '/api/address/district/filter';
  static const String getListWard = '/api/address/ward/filter';
  static const String getListBuilding = '/api/quarantine_ward/building/filter';
  static const String getListFloor = '/api/quarantine_ward/floor/filter';
  static const String getListRoom = '/api/quarantine_ward/room/filter';
  static const String requestOtp = '/api/oauth/reset_password/set';
  static const String sendOtp = '/api/oauth/reset_password/otp';
  static const String createPass = '/api/oauth/reset_password/confirm';
  static const String changePass = '/api/oauth/change_password/confirm';
  static const String createQuarantine = '/api/quarantine_ward/ward/create';
}

enum Permission {
  add,
  edit,
  view,
  delete,
  change_status,
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

List<KeyValue> nationalityList = [
  KeyValue(id: 1, name: 'Việt Nam'),
];

List<KeyValue> backgroundDiseaseList = [
  KeyValue(id: 1, name: "Tiểu đường"),
  KeyValue(id: 2, name: "Ung thư"),
  KeyValue(id: 3, name: "Tăng huyết áp"),
  KeyValue(id: 4, name: "Bệnh hen suyễn"),
  KeyValue(id: 5, name: "Bệnh gan"),
  KeyValue(id: 6, name: "Bệnh thận mãn tính"),
  KeyValue(id: 7, name: "Tim mạch"),
  KeyValue(id: 8, name: "Bệnh lý mạch máu não"),
];

const int PAGE_SIZE = 10;
const int PAGE_SIZE_MAX = 0;
