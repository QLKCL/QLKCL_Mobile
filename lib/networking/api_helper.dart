import 'package:dio/dio.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'dart:convert';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/helper/authentication.dart';

// cre: https://stackoverflow.com/questions/56740793/using-interceptor-in-dio-for-flutter-to-refresh-token

// cre: https://gist.github.com/RyanDsilva/ee205c02f98df9f830dcd9034e9a5e9b

class ApiHelper {
  static BaseOptions opts = BaseOptions(
    baseUrl: Constant.baseUrl,
    responseType: ResponseType.json,
    connectTimeout: 15000,
    receiveTimeout: 12000,
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    // adding interceptor
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // var accessToken = await getAccessToken();
        // var refreshToken = await getRefreshToken();
        // bool _token = isTokenExpired(accessToken!);
        // bool _refresh = isTokenExpired(refreshToken!);
        requestInterceptor(options);
        return handler.next(options); //modify your request
      },
      onResponse: (response, handler) {
        //on success it is getting called here
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        if (e.response != null) {
          if (e.response!.statusCode == 401) {
            //catch the 401 here
            dio.interceptors.requestLock.lock();
            dio.interceptors.responseLock.lock();
            RequestOptions requestOptions = e.requestOptions;

            await refreshToken();
            var accessToken = await getAccessToken();
            final opts = new Options(method: requestOptions.method);
            dio.options.headers["Authorization"] = "Bearer " + accessToken!;
            dio.options.headers["Accept"] = "*/*";
            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();
            final response = await dio.request(requestOptions.path,
                options: opts,
                cancelToken: requestOptions.cancelToken,
                onReceiveProgress: requestOptions.onReceiveProgress,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters);

            handler.resolve(response);
          } else {
            handler.next(e);
          }
        }
      },
    ));
    return dio;
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    // Get your JWT accessToken
    String? accessToken = await getAccessToken();
    if (accessToken != null && accessToken != '')
      options.headers.addAll({"Authorization": "Bearer $accessToken"});
    return options;
  }

  static refreshToken() async {
    Response response;
    var dio = Dio();
    final Uri apiUrl = Uri.parse(Constant.baseUrl + "/api/token/refresh");
    var refreshToken = await getRefreshToken();
    dio.options.headers["Authorization"] = "Bearer " + refreshToken!;
    try {
      response = await dio.postUri(apiUrl);
      if (response.statusCode == 200) {
        var refreshTokenResponse = jsonDecode(response.toString());
        var accessToken = refreshTokenResponse.data.access;
        await setAccessToken(accessToken);
      } else {
        print(response.toString());
        showTextToast(
            'Phiên làm việc đã hết hạn, vui lòng đăng xuất và đăng nhập lại');
        await logout();
      }
    } catch (e) {
      print(e.toString());
      showTextToast(
          'Phiên làm việc đã hết hạn, vui lòng đăng xuất và đăng nhập lại');
      await logout();
    }
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  Future<dynamic> getHTTP(String url) async {
    try {
      Response response = await baseAPI.get(url);
      return response.data;
    } on DioError catch (e) {
      // Handle error
      handleException(e);
    }
  }

  Future<dynamic> postHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.post(url,
          data: data != null ? FormData.fromMap(data) : null);
      return response.data;
    } on DioError catch (e) {
      // Handle error
      handleException(e);
    }
  }

  Future<dynamic> putHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.put(url,
          data: data != null ? FormData.fromMap(data) : null);
      return response.data;
    } on DioError catch (e) {
      // Handle error
      handleException(e);
    }
  }

  Future<dynamic> deleteHTTP(String url) async {
    try {
      Response response = await baseAPI.delete(url);
      return response.data;
    } on DioError catch (e) {
      // Handle error
      handleException(e);
    }
  }

  void handleException(e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print('Dio error!');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('HEADERS: ${e.response?.headers}');
    } else {
      // Error due to setting up or sending the request
      print('Error sending request!');
      print(e.message);
    }
  }
}
