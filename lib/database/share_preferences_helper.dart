import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const accessToken = '_accessToken';

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
}
