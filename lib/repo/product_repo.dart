import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepo {
  final Dio dio;

  ProductRepo({required this.dio});
  //create new product
  Future<bool> createProduct({
    required Map<String, dynamic> data,
  }) async {
    try {
      FormData formData;
// Ensure you're in an async function to use 'await'
      if (data['image'] == null) {
        formData = await createFormData(
            name: data['name'],
            price: data['price'],
            categoryId: data['categoryId'],
            originId: data['originId']);
      } else {
        formData = await createFormData(
            name: data['name'],
            price: data['price'],
            categoryId: data['categoryId'],
            originId: data['originId'],
            imageFile: data['image']);
      }

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
      print('Error creating product: $e');
      return false;
    }
  }

  Future<FormData> createFormData({
    required String name,
    required String price,
    required String categoryId,
    required String originId,
    XFile? imageFile,
  }) async {
    var formData = FormData();

    // Add text fields to FormData
    formData.fields
      ..add(MapEntry('name', name))
      ..add(MapEntry('price', price))
      ..add(MapEntry('category_id', categoryId))
      ..add(MapEntry('origin_id', originId));

    // Add file to FormData if it's not null
    if (imageFile != null) {
      // Create a MultipartFile from XFile
      MultipartFile multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.name, // Uses the original filename
      );
      // Add the file to FormData
      formData.files.add(MapEntry(
        'images', // This 'image' key should match the server-side expected key for the file
        multipartFile,
      ));
    }

    return formData;
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
      if (originId != null && originId.isNotEmpty) {
        queryParams['originId'] = originId;
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
