import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/database/local_database.dart';

class SchoolRepo {
  final Dio dio;
  final LocalDatabase localDatabase;

  SchoolRepo({required this.dio, required this.localDatabase});

  Future<Response> createSchool({required Map<String, String> dataForm}) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/school',
        data: dataForm,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create school: $e');
    }
  }

  Future<void> deleteSchool(String schoolId) async {
    try {
      final response = await dio.delete(
        '${AppConstants.baseUrl}/v1/school/$schoolId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete school');
      }
    } on DioException catch (e) {
      throw Exception(
          'Error deleting school: ${e.response?.data ?? e.message}');
    }
  }

  Future<List<Map<String, String>>> getAllSchools(
      int page, int pageSize) async {
    try {
      Response response = await dio.get(
        '${AppConstants.baseUrl}/v1/school',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, parse the JSON.
        List<dynamic> docs = response.data['data']['docs'];
        return docs.map((doc) {
          return Map.from(doc).map((key, value) =>
              MapEntry<String, String>(key.toString(), value.toString()));
        }).toList();
      } else {
        // If the server did not return a 200 OK response, handle accordingly
        throw Exception(
            'Failed to load schools with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle errors on request and throw an exception with a message
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }
}
