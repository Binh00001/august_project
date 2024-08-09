import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/database/local_database.dart';

class SchoolRepo {
  final Dio dio;
  final LocalDatabase localDatabase;

  SchoolRepo({required this.dio, required this.localDatabase});

  Future<List<Map<String, dynamic>>> getAllSchools(
      int page, int pageSize) async {
    try {
      Response response = await dio.get(
        '${AppConstants.baseUrl}/v1/school',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, parse the JSON.
        await _saveSchoolsToDatabase(response.data['data']['docs']);
        return response.data['data']['docs'];
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

  Future<void> _saveSchoolsToDatabase(List<dynamic> schools) async {
    for (var school in schools) {
      await localDatabase.addSchool({
        'id': school['id'],
        'name': school['name'],
        'address': school['address'],
        'phone_number': school['phoneNumber'],
      });
    }
  }
}
