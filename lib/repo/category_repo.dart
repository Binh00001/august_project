import 'package:dio/dio.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class CategoryRepo {
  final Dio dio;

  CategoryRepo({required this.dio});

  Future<bool> createCategory({required String name}) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/category',
        data: {
          'name': name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error creating category: $e');
      return false;
    }
  }

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

  Future<bool> updateCategory(String id, String name) async {
    try {
      final response = await dio.patch(
        '${AppConstants.baseUrl}/v1/category',
        data: {
          'id': id,
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }
}
