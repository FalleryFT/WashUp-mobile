import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../constants/api_constants.dart';

class SessionService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final savedBaseUrl = _prefs?.getString(ApiConstants.keyBaseUrl);
    if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
      ApiConstants.activeBaseUrl = savedBaseUrl;
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getString(ApiConstants.keyToken);
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.keyUser, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final userStr = prefs.getString(ApiConstants.keyUser);
    if (userStr == null) return null;
    try {
      final json = jsonDecode(userStr);
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.keyToken);
    await prefs.remove(ApiConstants.keyUser);
  }

  static Future<void> setUseMock(bool useMock) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(ApiConstants.keyUseMock, useMock);
  }

  static Future<bool> isUseMock() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getBool(ApiConstants.keyUseMock) ?? true;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.keyBaseUrl, url);
    ApiConstants.activeBaseUrl = url;
  }

  static Future<String> getBaseUrl() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getString(ApiConstants.keyBaseUrl) ?? ApiConstants.defaultEmulatorBaseUrl;
  }
}