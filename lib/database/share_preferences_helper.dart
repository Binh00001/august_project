import 'dart:convert';

import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const accessToken = '_accessToken';
  static const userKey = '_userKey';

  static const _printerIPAddress = '_printerIPAddress';
  static const _printerPort = '_printerPort';
  static const _printerScale = '_printerScale';

  //set printer ip
  static Future<void> setPrinterIP(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_printerIPAddress, newIP);
  }

  //get printer ip
  static Future<String> getPrinterIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_printerIPAddress) ?? "192.168.1.219";
  }

  //set printer port
  static Future<void> setPrinterPort(int newPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_printerPort, newPort);
  }

  //get printer port
  static Future<int> getPrinterPort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_printerPort) ?? 9100;
  }

  //set printer scale
  static Future<void> setPrinterScale(double newScale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_printerScale, newScale);
  }

  //get printer scale
  static Future<double> getPrinterScale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_printerScale) ?? 1.8;
  }

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
  static Future<User> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return AppConstants.defaultUser;
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
