import 'package:dio/dio.dart';
import 'app_endpoints.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await dio.get(
      url,
      queryParameters: queryParameters,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await dio.post(
      url,
      queryParameters: queryParameters,
      data: data,
    );
  }
}
