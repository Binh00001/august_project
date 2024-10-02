import 'package:flutter_project_august/models/staff_model.dart';
import 'package:flutter_project_august/models/user_model.dart';

class AppConstants {
  static const String baseUrl = "http://3.0.96.19:3008";
  static const String token = 'token';
  static const String loginUri = "/v1/auth/login";
  static User defaultUser = User(
      id: "", username: "", name: "", role: "", schoolId: "", schoolName: "");
  static Staff defaultStaff = Staff(id: "", username: "", name: "", role: "");
}
