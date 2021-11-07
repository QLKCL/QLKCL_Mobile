import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:qlkcl/utils/constant.dart';

final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

Future<bool> getLoginState() async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  if (authBox.containsKey('isLoggedIn')) {
    return authBox.get('isLoggedIn');
  } else {
    authBox.put('isLoggedIn', false);
    return false;
  }
}

Future<void> setLoginState(bool state) async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  authBox.put('isLoggedIn', state);
}

Future<String?> getAccessToken() async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  if (authBox.containsKey('accessToken')) {
    return authBox.get('accessToken');
  } else {
    return null;
  }
}

Future<void> setAccessToken(String accessToken) async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  authBox.put('accessToken', accessToken);
}

Future<String?> getRefreshToken() async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  if (authBox.containsKey('refreshToken')) {
    return authBox.get('refreshToken');
  } else {
    return null;
  }
}

Future<void> setRefreshToken(String refreshToken) async {
  var encryptionKey =
      base64Url.decode((await _secureStorage.read(key: 'key'))!);

  var authBox = await Hive.openBox('auth',
      encryptionCipher: HiveAesCipher(encryptionKey));

  authBox.put('refreshToken', refreshToken);
}

Future<bool> setToken(String accessToken, String refreshToken) async {
  setLoginState(true);
  setAccessToken(accessToken);
  setRefreshToken(refreshToken);
  return true;
}

Future<Map<String, dynamic>> login(Map<String, String> loginDataForm) async {
  var headers = {'Accept': 'application/json'};
  var request =
      http.MultipartRequest('POST', Uri.parse(Constant.baseUrl + '/token'));
  request.fields.addAll(loginDataForm);
  request.headers.addAll(headers);
  http.StreamedResponse? response;
  try {
    response = await request.send();
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return {'success': false, "message": "Lỗi kết nối!"};
  } else if (response.statusCode == 200) {
    var resp = await response.stream.bytesToString();
    final data = jsonDecode(resp);
    var accessToken = data['access'];
    var refreshToken = data['refresh'];
    setToken(accessToken, refreshToken);
    return {'success': true, "message": ""};
  } else if (response.statusCode == 401) {
    return {
      'success': false,
      "message": "Số điện thoại hoặc mật khẩu không hợp lệ!"
    };
  } else {
    print("Response code: " + response.statusCode.toString());
    return {'success': false, "message": "Có lỗi xảy ra!"};
  }
}

Future<bool> logout() async {
  Hive.box('auth').clear();
  setLoginState(false);
  return true;
}

bool isTokenExpired(String _token) {
  bool isExpired = false;
  DateTime? expiryDate = Jwt.getExpiryDate(_token);
  isExpired = expiryDate!.compareTo(DateTime.now()) < 0;
  return isExpired;
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
