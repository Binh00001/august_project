import 'package:dio/dio.dart';
import 'package:flutter_project_august/models/order_model.dart'; // Assuming Order model exists
import 'package:flutter_project_august/models/staff_model.dart';
import 'package:flutter_project_august/models/task_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class OrderRepo {
  final Dio dio;

  OrderRepo({required this.dio});

  Future<bool> markOrderAsPaid(String orderId) async {
    try {
      final response = await dio.patch(
        '${AppConstants.baseUrl}/v1/order/pay/$orderId',
      );

      if (response.statusCode == 200) {
        print('Order marked as paid successfully');
        return true;
      } else {
        print('Failed to mark order as paid: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error marking order as paid: $e');
      return false;
    }
  }

  Future<bool> assignStaffToTask(String userId, String schoolId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/user/assign',
        data: {
          "userId": userId,
          "schoolId": schoolId,
        },
      );

      if (response.statusCode == 200) {
        print('Staff assignment successful');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error assigning staff: $e');
      return false;
    }
  }

  Future<List<Task>> getTasks(int date, String schoolId) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/order/buy?schoolId=$schoolId',
        queryParameters: {'date': date},
      );
      // Parse the response data into a list of BuyTask objects
      List<Task> tasks = (response.data['data']['products'] as List)
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList();

      return tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow; // Re-throw the error after logging it
    }
  }

  Future<Staff?> getAssignedStaff(int date, String schoolId) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/order/buy?schoolId=$schoolId',
        queryParameters: {'date': date},
      );

      // Check if userAssigned exists in the response
      if (response.data['data']['userAssigned'] != null) {
        // Parse userAssigned into a Staff object
        Staff staff = Staff.fromJson(
            response.data['data']['userAssigned'] as Map<String, dynamic>);
        return staff;
      } else {
        // Return null if userAssigned is null
        return null;
      }
    } catch (e) {
      print('Error fetching assigned staff: $e');
      rethrow; // Re-throw the error after logging it
    }
  }

  Future<bool> createOrder(
      List<Map<String, dynamic>> products, num totalAmount) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/v1/order',
        data: {
          'totalAmount': totalAmount,
          'products': products,
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Order created successfully: ${response.data}');
        return true;
      } else {
        // Handle error
        print('Failed to create order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

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
        queryParameters: _buildQueryParameters(
            page: page,
            pageSize: pageSize,
            schoolId: schoolId,
            startDate: startDate,
            endDate: endDate),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data']['docs'];
        int totalPage = response.data['data']['paging']['totalPages'];
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

  Future<int> getTotalPages({
    required int page,
    required int pageSize,
    String? schoolId,
    int? startDate,
    int? endDate,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/order',
        queryParameters: _buildQueryParameters(
            page: page,
            pageSize: pageSize,
            schoolId: schoolId,
            startDate: startDate,
            endDate: endDate),
      );

      if (response.statusCode == 200) {
        int totalPage = response.data['data']['paging']['totalPages'];
        return totalPage;
      } else {
        throw Exception(
            'Failed to load orders with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }

  Future<num> getDebtOrders(Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/v1/order/debt',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        // Adjust according to your JSON structure
        return response.data['data']['debt'];
      } else {
        throw Exception(
            'Failed to load debt orders with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to connect to the API: ${e.response?.data ?? e.message}');
    }
  }

  Map<String, dynamic> _buildQueryParameters({
    int? page,
    int? pageSize,
    String? schoolId,
    int? startDate,
    int? endDate,
  }) {
    final Map<String, dynamic> params = {};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (schoolId != null) params['schoolId'] = schoolId;
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;

    return params;
  }
}
