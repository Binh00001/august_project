import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class UserRepo {
  final Dio dio;

  UserRepo({required this.dio});

  // Method to change password
  // Method to change password that returns HTTP status code
  Future<int> changePassword(String oldPassword, String newPassword) async {
    var passwordData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    try {
      Response response = await dio.patch(
        '${AppConstants.baseUrl}/v1/user', // Make sure your endpoint is correct
        data: passwordData,
      );
      // Directly return the status code from the HTTP response
      return response.statusCode ?? 0; // Returns 0 if statusCode is null
    } on DioException catch (e) {
      // Return a specific status code on error or default to a custom one if none is provided
      return e.response?.statusCode ??
          400; // Using 400 as a generic client error status
    }
  }

  Future<void> createNewStaff({
    required String username,
    required String password,
    required String name,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/auth/create-user',
        data: {
          'username': username,
          'password': password,
          'name': name,
          'role': 'staff',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create staff');
      }
    } catch (e) {
      throw Exception('Error creating staff: $e');
    }
  }

  Future<void> createNewUser({
    required String username,
    required String password,
    required String name,
    required String schoolId,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/auth/create-user',
        data: {
          'username': username,
          'password': password,
          'name': name,
          'schoolId': schoolId,
          'role': 'user',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<List<dynamic>> getUsersByRoleAndSchool(
      String role, String? schoolId, int page) async {
    try {
      final queryParams = {
        'role': role,
        'page': page,
        'pagesize': 100,
      };

      if (schoolId != null && schoolId.isNotEmpty) {
        queryParams['schoolId'] = schoolId;
      }

      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/user',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data['data']['docs'];
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
