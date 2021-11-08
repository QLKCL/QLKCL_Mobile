import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

Future<bool> getLoginState() async {
  var authBox = await Hive.openBox('auth');

  if (authBox.containsKey('isLoggedIn')) {
    return authBox.get('isLoggedIn');
  } else {
    authBox.put('isLoggedIn', false);
    return false;
  }
}

Future<void> setLoginState(bool state) async {
  var authBox = await Hive.openBox('auth');

  authBox.put('isLoggedIn', state);
}

Future<String?> getAccessToken() async {
  var authBox = await Hive.openBox('auth');
  return authBox.get('accessToken');
}

Future<void> setAccessToken(String accessToken) async {
  var authBox = await Hive.openBox('auth');
  authBox.put('accessToken', accessToken);
}

Future<String?> getRefreshToken() async {
  var authBox = await Hive.openBox('auth');

  return authBox.get('refreshToken');
}

Future<void> setRefreshToken(String refreshToken) async {
  var authBox = await Hive.openBox('auth');

  authBox.put('refreshToken', refreshToken);
}

Future<bool> setToken(String accessToken, String refreshToken) async {
  await setLoginState(true);
  await setAccessToken(accessToken);
  await setRefreshToken(refreshToken);
  return true;
}

var headers = {
  'Accept': 'application/json',
};

Future<Response> login(Map<String, String> loginDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Constant.baseUrl + '/token'),
        headers: headers, body: loginDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    var accessToken = data['access'];
    var refreshToken = data['refresh'];
    await setToken(accessToken, refreshToken);
    return Response(success: true);
  } else if (response.statusCode == 401) {
    return Response(
        success: false, message: "Số điện thoại hoặc mật khẩu không hợp lệ!");
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<Response> register(Map<String, String> loginDataForm) async {
  http.Response? response;
  try {
    response = await http.post(
        Uri.parse(Constant.baseUrl + '/user/member/register'),
        headers: headers,
        body: loginDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    var accessToken = data['access'];
    var refreshToken = data['refresh'];
    setToken(accessToken, refreshToken);
    return Response(success: true);
  } else if (response.statusCode == 401) {
    return Response(
        success: false, message: "Số điện thoại hoặc mật khẩu không hợp lệ!");
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<bool> logout() async {
  Hive.box('auth').clear();
  await setLoginState(false);
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
