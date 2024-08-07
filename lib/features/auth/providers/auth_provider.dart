// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_august/common/models/api_response_model.dart';
import 'package:flutter_project_august/common/models/response_model.dart';
import 'package:flutter_project_august/features/auth/domain/reposotories/auth_repo.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  // for login section
  String? _loginErrorMessage = '';

  bool _isLoading = false;

  String? get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login(String? email, String? password) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.login(email: email, password: password);
    ResponseModel responseModel;
    print(apiResponse);
    _isLoading = false;
    notifyListeners();
    return responseModel = ResponseModel(false, "");
  }
}
