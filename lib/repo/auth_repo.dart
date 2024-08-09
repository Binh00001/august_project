import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

abstract class AuthRepo {
  Future<dynamic> signIn(String username, String password);
}

class AuthRepositoryImpl extends AuthRepo {
  final Dio dio; // Khai báo biến để giữ thể hiện của Dio

  AuthRepositoryImpl(this.dio); // Yêu cầu Dio được truyền vào khi khởi tạo

  @override
  Future<dynamic> signIn(String username, String password) async {
    var loginData = {"username": username, "password": password};

    try {
      // Thực hiện yêu cầu POST để đăng nhập
      Response response = await dio.post(
        '${AppConstants.baseUrl}/v1/auth/login', // Địa chỉ API cho đăng nhập
        data: loginData,
      );
      return response.data; // Trả về dữ liệu nhận được
    } on DioException catch (e) {
      // Xử lý lỗi và trả về thông tin lỗi
      // print("Error occurred: ${e.response?.data ?? e.message}");
      return e.response?.data ?? {"error": e.message};
    }
  }
}
