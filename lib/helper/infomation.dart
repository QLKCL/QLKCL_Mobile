import 'package:hive_flutter/hive_flutter.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

Future<int> getRole() async {
  var infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('role')) {
    return infoBox.get('role');
  } else {
    return -1;
  }
}

Future<String> getCode() async {
  var infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('code')) {
    return infoBox.get('code');
  } else {
    return "-1";
  }
}

Future<String> getName() async {
  var infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('name')) {
    return infoBox.get('name');
  } else {
    return "";
  }
}

Future<int> getQuarantineWard() async {
  var infoBox = await Hive.openBox('myInfo');
  return infoBox.get('quarantineWard');
}

Future<String> getQuarantineStatus() async {
  var infoBox = await Hive.openBox('myInfo');
  return infoBox.get('status');
}

Future<void> setInfo() async {
  var infoBox = await Hive.openBox('myInfo');
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.getMember, null);
  int role = response['data']['custom_user']['role'];
  infoBox.put('role', role);
  String name = response['data']['custom_user']['full_name'];
  infoBox.put('name', name);
  int quarantineWard = response['data']['custom_user']['quarantine_ward']['id'];
  infoBox.put('quarantineWard', quarantineWard);
  String code = response['data']['custom_user']['code'];
  infoBox.put('code', code);
  String status = response['data']['custom_user']['status'];
  infoBox.put('status', status);
}
