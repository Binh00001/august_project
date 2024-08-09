import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import '../database/share_preferences_helper.dart';

class DioClient {
  static Future<Dio> createDio() async {
    Dio dio = Dio();

    // Thiết lập cấu hình mặc định cho Dio
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout =
        const Duration(milliseconds: 5000); // 5 seconds
    dio.options.receiveTimeout =
        const Duration(milliseconds: 3000); // 3 seconds

    // Có thể thêm interceptors nếu cần xử lý thêm
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Retrieve the token from secure storage / shared preferences
        String token = await SharedPreferencesHelper.getApiTokenKey();
        if (token != "") {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors or refresh token logic here if needed
        return handler.next(e);
      },
    ));
    return dio;
  }
}
