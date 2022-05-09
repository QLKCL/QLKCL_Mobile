import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/api.dart';

Future<int> getRole() async {
  final infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('role')) {
    return infoBox.get('role');
  } else {
    return 5; // Member
  }
}

Future<String> getCode() async {
  final infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('code')) {
    return infoBox.get('code');
  } else {
    return "-1";
  }
}

Future<String> getName() async {
  final infoBox = await Hive.openBox('myInfo');

  if (infoBox.containsKey('name')) {
    return infoBox.get('name');
  } else {
    return "";
  }
}

Future<int> getQuarantineWard() async {
  final infoBox = await Hive.openBox('myInfo');
  return infoBox.get('quarantineWard');
}

Future<String> getQuarantineStatus() async {
  final infoBox = await Hive.openBox('myInfo');
  return infoBox.get('quarantineStatus');
}

Future<String> getGender() async {
  final infoBox = await Hive.openBox('myInfo');
  return infoBox.get('gender');
}

Future<String> getBirthday() async {
  final infoBox = await Hive.openBox('myInfo');
  return infoBox.get('birthday');
}

Future<String> getPhoneNumber() async {
  final infoBox = await Hive.openBox('myInfo');
  return infoBox.get('phoneNumber');
}

Future<dynamic> setInfo() async {
  final infoBox = await Hive.openBox('myInfo');
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.getMember, null);
  final int role = response['data']['custom_user']['role']['id'];
  infoBox.put('role', role);
  final String name = response['data']['custom_user']['full_name'];
  infoBox.put('name', name);
  final String gender = response['data']['custom_user']['gender'];
  infoBox.put('gender', gender);
  final String birthday = response['data']['custom_user']['birthday'] ?? "";
  infoBox.put('birthday', birthday);
  final String phoneNumber = response['data']['custom_user']['phone_number'];
  infoBox.put('phoneNumber', phoneNumber);
  final int quarantineWard =
      response['data']['custom_user']['quarantine_ward']['id'];
  infoBox.put('quarantineWard', quarantineWard);
  final String code = response['data']['custom_user']['code'];
  infoBox.put('code', code);
  final String quarantineStatus = response['data']['custom_user']['status'];
  infoBox.put('quarantineStatus', quarantineStatus);

  return response['data'];
}

Future<bool> getLoginState() async {
  final authBox = await Hive.openBox('auth');

  if (authBox.containsKey('isLoggedIn')) {
    return authBox.get('isLoggedIn');
  } else {
    authBox.put('isLoggedIn', false);
    return false;
  }
}

Future<void> setLoginState(isLoggedIn) async {
  final authBox = await Hive.openBox('auth');

  authBox.put('isLoggedIn', isLoggedIn);
}

Future<String?> getAccessToken() async {
  final authBox = await Hive.openBox('auth');
  return authBox.get('accessToken');
}

Future<void> setAccessToken(String accessToken) async {
  final authBox = await Hive.openBox('auth');
  authBox.put('accessToken', accessToken);
}

Future<String?> getRefreshToken() async {
  final authBox = await Hive.openBox('auth');

  return authBox.get('refreshToken');
}

Future<void> setRefreshToken(String refreshToken) async {
  final authBox = await Hive.openBox('auth');

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
    response = await http.post(Uri.parse(Api.baseUrl + Api.login),
        headers: {
          'Accept': 'application/json',
        },
        body: loginDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    final resp = response.body;
    final data = jsonDecode(resp);
    final accessToken = data['access'];
    final refreshToken = data['refresh'];
    final bool status = await setToken(accessToken, refreshToken);
    if (status) {
      await setInfo();
      return Response(status: Status.success);
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  } else if (response.statusCode == 401) {
    return Response(
        status: Status.error,
        message: "Số điện thoại hoặc mật khẩu không hợp lệ!");
  } else {
    print("Response code: ${response.statusCode}");
    return Response(status: Status.error, message: "Có lỗi xảy ra!");
  }
}

Future<Response> register(Map<String, dynamic> registerDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Api.baseUrl + Api.register),
        headers: {
          'Accept': 'application/json',
        },
        body: registerDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    final resp = response.body;
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(status: Status.success);
    } else if (data['message']['phone_number'] == "Exist") {
      return Response(
          status: Status.error, message: "Số điện thoại đã được sử dụng!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: ${response.statusCode}");
    return Response(status: Status.error, message: "Có lỗi xảy ra!");
  }
}

Future<bool> logout() async {
  Hive.box('auth').clear();
  Hive.box('myInfo').clear();
  await setLoginState(false);
  return true;
}

bool isTokenExpired(String token) {
  final DateTime? expiryDate = Jwt.getExpiryDate(token);
  return expiryDate!.compareTo(DateTime.now()) < 0;
}

Future<Response> requestOtp(Map<String, String> requestOtpDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Api.baseUrl + Api.requestOtp),
        headers: {
          'Accept': 'application/json',
        },
        body: requestOtpDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    final resp = response.body;
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(status: Status.success, message: "Gửi OTP thành công!");
    } else if (data['error_code'] == 400) {
      if (data['message'] == "User is not exist") {
        return Response(
            status: Status.error,
            message: "Email không tồn tại trong hệ thống!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: ${response.statusCode}");
    return Response(status: Status.error, message: "Có lỗi xảy ra!");
  }
}

Future<Response> sendOtp(Map<String, String> sendOtpDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Api.baseUrl + Api.sendOtp),
        headers: {
          'Accept': 'application/json',
        },
        body: sendOtpDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    final resp = response.body;
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(status: Status.success, data: data["data"]['new_otp']);
    } else if (data['error_code'] == 400) {
      return Response(status: Status.error, message: "OTP không hợp lệ!");
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: ${response.statusCode}");
    return Response(status: Status.error, message: "Có lỗi xảy ra!");
  }
}

Future<Response> createPass(Map<String, String> createPassDataForm) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse(Api.baseUrl + Api.createPass),
        headers: {
          'Accept': 'application/json',
        },
        body: createPassDataForm);
  } catch (e) {
    print('Error: $e');
  }

  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else if (response.statusCode == 200) {
    final resp = response.body;
    final data = jsonDecode(resp);
    if (data['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Tạo mật khẩu thành công. Vui lòng đăng nhập lại!");
    } else if (data['error_code'] == 400) {
      if (data['message'] == "New password is the same with old password") {
        return Response(
            status: Status.error, message: "Mật khẩu đã từng được sử dụng!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  } else {
    print("Response code: ${response.statusCode}");
    return Response(status: Status.error, message: "Có lỗi xảy ra!");
  }
}

Future<Response> changePass(Map<String, String> changePassDataForm) async {
  final ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Api.changePass, changePassDataForm);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success, message: "Đổi mật khẩu thành công!");
    } else if (response['error_code'] == 400) {
      if (response['message'] == "Wrong password") {
        return Response(
            status: Status.error, message: "Mật khẩu cũ không chính xác!");
      } else if (response['message'] ==
          "New password is the same with old password") {
        return Response(
            status: Status.error, message: "Mật khẩu mới trùng mật khẩu cũ!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}

Future<Response> resetPass(Map<String, String> resetPassDataForm) async {
  final api = ApiHelper();
  final response = await api.postHTTP(Api.resetPass, resetPassDataForm);
  if (response == null) {
    return Response(status: Status.error, message: "Lỗi kết nối!");
  } else {
    if (response['error_code'] == 0) {
      return Response(
          status: Status.success,
          message: "Mật khẩu mới là ${response['data']['new_password']}");
    } else if (response['error_code'] == 401) {
      if (response['message'] != null &&
          response['message'] == "Permission denied") {
        return Response(
            status: Status.error,
            message: 'Không có quyền thực hiện chức năng này!');
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else if (response['error_code'] == 400) {
      if (response['message']['code'] == "Not exist") {
        return Response(
            status: Status.error, message: "Tài khoản không tồn tại!");
      } else {
        return Response(status: Status.error, message: "Có lỗi xảy ra!");
      }
    } else {
      return Response(status: Status.error, message: "Có lỗi xảy ra!");
    }
  }
}
