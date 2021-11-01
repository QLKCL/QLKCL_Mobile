import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

Future<bool> getLoginState() async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var loginInfoBox = await Hive.openBox('loginInfo',
      encryptionCipher: HiveAesCipher(encryptionKey));

  if (loginInfoBox.containsKey('isLoggedIn')) {
    return loginInfoBox.get('isLoggedIn');
  } else {
    loginInfoBox.put('isLoggedIn', false);
    return false;
  }
}

Future<void> setLoginState(bool state) async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var loginInfoBox = await Hive.openBox('loginInfo',
      encryptionCipher: HiveAesCipher(encryptionKey));

  loginInfoBox.put('isLoggedIn', state);
}

Future<String> getRole() async {
  var roleBox = await Hive.openBox('role');

  if (roleBox.containsKey('role')) {
    return roleBox.get('role');
  } else {
    roleBox.put('role', "5"); // vi du 5 la member
    return "5";
  }
}
