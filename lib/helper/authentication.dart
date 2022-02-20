import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
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
  int role = response['data']['custom_user']['role']['id'];
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

Future<Response> login(Map<String, String> loginDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Constant.baseUrl + Constant.login),
        headers: {
          'Accept': 'application/json',
        },
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
    await setToken(accessToken, refreshToken);
    await setInfo();
    return Response(success: true);
  } else if (response.statusCode == 401) {
    return Response(
        success: false, message: "Số điện thoại hoặc mật khẩu không hợp lệ!");
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<Response> register(Map<String, dynamic> registerDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Constant.baseUrl + Constant.register),
        headers: {
          'Accept': 'application/json',
        },
        body: registerDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(success: true);
    } else if (data['message']['phone_number'] == "Exist") {
      return Response(
          success: false, message: "Số điện thoại đã được sử dụng!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<bool> logout() async {
  Hive.box('auth').clear();
  Hive.box('myInfo').clear();
  await setLoginState(false);
  return true;
}

bool isTokenExpired(String _token) {
  bool isExpired = false;
  DateTime? expiryDate = Jwt.getExpiryDate(_token);
  isExpired = expiryDate!.compareTo(DateTime.now()) < 0;
  return isExpired;
}

Future<Response> requestOtp(Map<String, String> requestOtpDataForm) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse(Constant.baseUrl + Constant.requestOtp),
            headers: {
              'Accept': 'application/json',
            },
            body: requestOtpDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(success: true, message: "Gửi OTP thành công!");
    } else if (data['error_code'] == 400) {
      if (data['message'] == "User is not exist") {
        return Response(
            success: false, message: "Email không tồn tại trong hệ thống!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<Response> sendOtp(Map<String, String> sendOtpDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Constant.baseUrl + Constant.sendOtp),
        headers: {
          'Accept': 'application/json',
        },
        body: sendOtpDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(success: true, data: data["data"]['new_otp']);
    } else if (data['error_code'] == 400) {
      return Response(success: false, message: "OTP không hợp lệ!");
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<Response> createPass(Map<String, String> createPassDataForm) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse(Constant.baseUrl + Constant.createPass),
            headers: {
              'Accept': 'application/json',
            },
            body: createPassDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    var resp = response.body.toString();
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(
          success: true,
          message: "Tạo mật khẩu thành công. Vui lòng đăng nhập lại!");
    } else if (data['error_code'] == 400) {
      if (data['message'] == "New password is the same with old password") {
        return Response(
            success: false, message: "Mật khẩu đã từng được sử dụng!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: " + response.statusCode.toString());
    return Response(success: false, message: "Có lỗi xảy ra!");
  }
}

Future<Response> changePass(Map<String, String> changePassDataForm) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.changePass, changePassDataForm);
  if (response == null) {
    return Response(success: false, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(success: true, message: "Đổi mật khẩu thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message'] == "Wrong password") {
        return Response(
            success: false, message: "Mật khẩu cũ không chính xác!");
      } else if (response['message'] ==
          "New password is the same with old password") {
        return Response(
            success: false, message: "Mật khẩu mới trùng mật khẩu cũ!");
      } else {
        return Response(success: false, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
