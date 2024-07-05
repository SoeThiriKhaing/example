import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceData {
  static const String accessRole = "role";

  Future<void> setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessRole, role);
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessRole) ?? "";
  }

  static Future<void> removeRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessRole);
  }
}
