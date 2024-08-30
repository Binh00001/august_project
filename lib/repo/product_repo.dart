import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class ProductRepo {
  final Dio dio;

  ProductRepo({required this.dio});

  // Update product
  Future<bool> updateProduct({required FormData formData}) async {
    try {
      Response response = await dio.patch(
        '${AppConstants.baseUrl}/v1/product',
        data: formData,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //create new product
  Future<bool> createProduct({
    required FormData formData,
  }) async {
    try {
      Response response = await dio.post(
        '${AppConstants.baseUrl}/v1/product',
        data: formData,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //get all (can filter)
  Future<Map<String, dynamic>> getAllProducts(
      int page, int pageSize, String? categoryId, String? originId) async {
    try {
      // Build the query parameters map
      Map<String, dynamic> queryParams = {
        'page': page,
        'pageSize': pageSize,
      };

      // Conditionally add categoryId and originId if they are not null or empty
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      Response response = await dio.get(
        '${AppConstants.baseUrl}/v1/product',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        // Return a map with the products, totalItems, and totalPage
        return {
          'products': response.data['data']['docs'],
          'totalItems': response.data['data']['paging']['totalItems'],
          'totalPages': response.data['data']['paging']['totalPages'],
        };
      } else {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }
}
