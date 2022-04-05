import 'package:http/http.dart' as http;
import 'package:qlkcl/networking/response.dart';
import 'dart:convert';
import 'dart:async';

import 'package:qlkcl/utils/api.dart';

// cre: https://ichi.pro/vi/flutter-xu-ly-cac-lenh-goi-api-mang-cua-ban-nhu-mot-ong-chu-158964374994071

class RequestHelper {
  final String? baseUrl;
  String _baseUrl = Api.baseUrl;
  Map<String, String>? params;

  RequestHelper({this.baseUrl, this.params});

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    _baseUrl = baseUrl ?? _baseUrl;
    var response;
    try {
      String query = '?';
      if (params != null) query += queryString(params);
      response = await http.get(Uri.parse(_baseUrl + url + query));
    } catch (e) {
      print('Error: $e');
    }

    return _response(response);
  }

  _response(response) {
    if (response == null) {
      return Response(success: false, message: "Lỗi kết nối!");
    } else if (response.statusCode == 200) {
      // var resp = response.body.toString();
      // final data = jsonDecode(resp);

      var resp = utf8.decode(response.bodyBytes);
      final data = jsonDecode(resp);
      return Response(success: true, data: data);
    } else if (response.statusCode == 400) {
      var resp = utf8.decode(response.bodyBytes);
      final data = jsonDecode(resp);
      return Response(success: false, data: data);
    } else if (response.statusCode == 401) {
      return Response(success: false, message: "Lỗi xác thực!");
    } else {
      print("Response code: " + response.statusCode.toString());
      return Response(success: false, message: "Có lỗi xảy ra!");
    }
  }
}

String queryString(Map<String, dynamic> queryParameters) {
  var result = StringBuffer();
  var separator = "";

  void writeParameter(String key, String? value) {
    result.write(separator);
    separator = "&";
    result.write(Uri.encodeQueryComponent(key));
    if (value != null && value.isNotEmpty) {
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }
  }

  queryParameters.forEach((key, value) {
    if (value == null || value is String) {
      writeParameter(key, value);
    } else {
      Iterable values = value;
      for (String value in values) {
        writeParameter(key, value);
      }
    }
  });
  return result.toString();
}
