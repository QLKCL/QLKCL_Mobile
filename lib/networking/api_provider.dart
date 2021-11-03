import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:qlkcl/networking/custom_exception.dart';
import 'package:qlkcl/utils/constant.dart';

// cre: https://ichi.pro/vi/flutter-xu-ly-cac-lenh-goi-api-mang-cua-ban-nhu-mot-ong-chu-158964374994071

class ApiProvider {
  final String? baseUrl;
  String _baseUrl = Constant.baseUrl;

  ApiProvider({this.baseUrl});

  Future<dynamic> get(String url) async {
    _baseUrl = baseUrl ?? _baseUrl;
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
