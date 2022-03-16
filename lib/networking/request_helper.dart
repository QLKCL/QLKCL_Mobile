import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/response.dart';
import 'dart:convert';
import 'dart:async';

import 'package:qlkcl/utils/api.dart';

// cre: https://ichi.pro/vi/flutter-xu-ly-cac-lenh-goi-api-mang-cua-ban-nhu-mot-ong-chu-158964374994071

class RequestHelper {
  final String? baseUrl;
  String _baseUrl = Api.baseUrl;

  RequestHelper({this.baseUrl});

  Future<dynamic> get(String url) async {
    _baseUrl = baseUrl ?? _baseUrl;
    var response;
    try {
      response = await http.get(Uri.parse(_baseUrl + url));
    } catch (e) {
      print('Error: $e');
    }

    return _response(response);
  }

  _response(response) {
    if (response == null) {
      return Response(success: false, message: "Lỗi kết nối!");
    } else if (response.statusCode == 200) {
      var resp = response.body.toString();
      final data = jsonDecode(resp);
      return Response(success: true, data: data);
    } else if (response.statusCode == 401) {
      return Response(success: false, message: "Lỗi xác thực!");
    } else {
      print("Response code: " + response.statusCode.toString());
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}
