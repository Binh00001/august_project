import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_august/models/order_model.dart'; // Assuming Order model exists
import 'package:flutter_project_august/utill/app_constants.dart';

class OrderRepo {
  final Dio dio;

  OrderRepo({required this.dio});

  Future<List<Order>> getOrders({
    required int page,
    required int pageSize,
    String? schoolId,
    int? startDate,
    int? endDate,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/order',
        queryParameters:
            _buildQueryParameters(page, pageSize, schoolId, startDate, endDate),
      );
      print(
        _buildQueryParameters(page, pageSize, schoolId, startDate, endDate),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data']
            ['docs']; // Adjust according to your JSON structure
        return data.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception(
            'Failed to load orders with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }

  Map<String, dynamic> _buildQueryParameters(
      int page, int pageSize, String? schoolId, int? startDate, int? endDate) {
    final Map<String, dynamic> params = {
      'page': page,
      'pageSize': pageSize,
    };
    if (schoolId != null) {
      params['schoolId'] = schoolId;
    }
    if (startDate != null && startDate != 0) {
      params['startDate'] = startDate;
    }
    if (endDate != null && endDate != 0) {
      params['endDate'] = endDate;
    }

    return params;
  }
}
