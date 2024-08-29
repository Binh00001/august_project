import 'package:flutter_project_august/models/user_model.dart';

class AppConstants {
  static const String baseUrl = "http://18.141.222.147:3001";
  static const String token = 'token';
  static const String loginUri = "/v1/auth/login";
  static User defaultUser = User(
      id: "", username: "", name: "", role: "", schoolId: "", schoolName: "");
}
