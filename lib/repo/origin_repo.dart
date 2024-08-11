import 'package:dio/dio.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class OriginRepo {
  final Dio dio;

  OriginRepo({required this.dio});

  Future<List<Origin>> getOrigins(int page, int pageSize) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/origin',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data']['docs'];
        return data.map((origin) => Origin.fromJson(origin)).toList();
      } else {
        throw Exception(
            'Failed to load origins with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }
}
