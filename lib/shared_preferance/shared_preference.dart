import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late final SharedPreferences prefs;

  static Future init() async => prefs = await SharedPreferences.getInstance();
  static void setLogin(bool isLogedin) => prefs.setBool("islogedin", isLogedin);

  static bool? getLogin() => prefs.getBool("islogedin");

  static void setRole(bool isAdmin) => prefs.setBool("isAdmin", isAdmin);

  static bool? getRole() => prefs.getBool("isAdmin");
}
