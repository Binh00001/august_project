import 'package:dio/dio.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class StatisticsRepo {
  final Dio dio;

  StatisticsRepo({required this.dio});

  // Method to fetch statistical data
  Future<dynamic> getStatisticalData(int startDate, int endDate) async {
    try {
      print('$startDate, $endDate');
      Response response = await dio.get(
        '${AppConstants.baseUrl}/v1/order/statistical',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to fetch data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch statistical data: $e');
      throw Exception(
          'Failed to connect to the server or the request timed out.');
    }
  }
}
