import 'package:dio/dio.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class CategoryRepo {
  final Dio dio;

  CategoryRepo({required this.dio});

  Future<List<Category>> getCategories(int page, int pageSize) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/category',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        // Parse the data from the response
        List<dynamic> data = response.data['data']['docs'];
        return data.map((category) => Category.fromJson(category)).toList();
      } else {
        throw Exception(
            'Failed to load categories with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }
}
