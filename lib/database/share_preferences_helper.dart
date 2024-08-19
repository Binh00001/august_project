import 'dart:convert';

import 'package:flutter_project_august/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const accessToken = '_accessToken';
  static const userKey = '_userKey';
  //Get token
  static Future<String> getApiTokenKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(accessToken) ?? "";
    } catch (e) {
      return "";
    }
  }

  //Set token
  static void setApiTokenKey(String tokenValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessToken, tokenValue);
  }

  static void removeApiTokenKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessToken);
  }

  // Save user information
  static Future<void> setUserInfo(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  // Get user information
  static Future<User?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<bool> checkUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('_accessToken');
    return token != null;
  }

  // Remove user information
  static Future<void> removeUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}
