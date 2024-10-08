import 'package:dio/dio.dart';
import 'package:flutter_project_august/models/revenue_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class RevenueRepo {
  final Dio dio;

  RevenueRepo({required this.dio});

  // Method to fetch revenue data
  Future<List<Revenue>> fetchRevenueData(int year) async {
    try {
      // Send a GET request to fetch revenue data
      Response response = await dio.get(
        '${AppConstants.baseUrl}/v1/order/revenue',
        queryParameters: {'year': year},
      );

      if (response.statusCode == 200) {
        List<dynamic> revenueList = response.data['data']['revenues'];
        return revenueList.map((json) => Revenue.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching revenue data: $e');
      throw Exception('Error fetching revenue data: $e');
    }
  }
}
