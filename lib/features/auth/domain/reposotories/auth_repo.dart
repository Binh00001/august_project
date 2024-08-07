import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/common/models/api_response_model.dart';
import 'package:flutter_project_august/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_project_august/data/datasource/remote/exception/api_error_handle.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});
  Future<ApiResponseModel> login({String? email, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"username": email, "password": password},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
