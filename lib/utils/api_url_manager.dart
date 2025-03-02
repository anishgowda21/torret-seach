import 'package:shared_preferences/shared_preferences.dart';

class ApiUrlManager {
  static const String _apiUrlKey = 'api_url';

  static Future<String?> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey);
  }

  static Future<void> setApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, url);
  }

  static Future<void> clearApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiUrlKey);
  }
}
