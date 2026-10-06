import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/notification_model.dart';
import '../../models/service_item_model.dart';
import '../../models/dashboard_stats_model.dart';
import 'mock_data_service.dart';
import 'session_service.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final bool isFromMock;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.isFromMock = false,
  });
}

class ApiService {
  static final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 4);

  // Headers helper
  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await SessionService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ---------------- AUTHENTICATION ----------------
  static Future<ApiResponse<UserModel>> login(String username, String password) async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      final user = MockDataService.defaultUser.copyWith(username: username, name: username);
      await SessionService.saveToken('mock_token_demo_123');
      await SessionService.saveUser(user);
      return ApiResponse(success: true, data: user, isFromMock: true);
    }

    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.login}');
      final response = await _client.post(
        url,
        headers: await _getHeaders(withAuth: false),
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(_timeout);

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = body['token'] ?? '';
        final user = UserModel.fromJson(body['user'] ?? {});
        await SessionService.saveToken(token);
        await SessionService.saveUser(user);
        return ApiResponse(success: true, data: user);
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Login gagal. Periksa kembali username/password.',
        );
      }
    } catch (_) {
      // Fallback to Mock on connection error
      final user = MockDataService.defaultUser.copyWith(username: username, name: username);
      await SessionService.saveToken('mock_token_demo_123');
      await SessionService.saveUser(user);
      await SessionService.setUseMock(true);
      return ApiResponse(
        success: true,
        data: user,
        message: 'Server offline, beralih ke Mode Demo.',
        isFromMock: true,
      );
    }
  }

  static Future<ApiResponse<UserModel>> register(Map<String, dynamic> data) async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      final user = UserModel.fromJson(data);
      await SessionService.saveToken('mock_token_demo_123');
      await SessionService.saveUser(user);
      return ApiResponse(success: true, data: user, isFromMock: true);
    }

    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.register}');
      final response = await _client.post(
        url,
        headers: await _getHeaders(withAuth: false),
        body: jsonEncode(data),
      ).timeout(_timeout);

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = body['token'] ?? '';
        final user = UserModel.fromJson(body['user'] ?? {});
        await SessionService.saveToken(token);
        await SessionService.saveUser(user);
        return ApiResponse(success: true, data: user);
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Registrasi gagal.',
        );
      }
    } catch (_) {
      final user = UserModel.fromJson(data);
      await SessionService.saveToken('mock_token_demo_123');
      await SessionService.saveUser(user);
      await SessionService.setUseMock(true);
      return ApiResponse(
        success: true,
        data: user,
        message: 'Server offline, akun demo berhasil dibuat.',
        isFromMock: true,
      );
    }
  }

  static Future<void> logout() async {
    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.logout}');
      await _client.post(url, headers: await _getHeaders()).timeout(const Duration(seconds: 2));
    } catch (_) {}
    await SessionService.clearSession();
  }

  // ---------------- DASHBOARD ----------------
  static Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      return ApiResponse(
        success: true,
        data: {
          'stats': MockDataService.dashboardStats,
          'active_orders': MockDataService.getActiveOrders(),
          'recent_history': MockDataService.getHistoryOrders(),
        },
        isFromMock: true,
      );
    }

    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.customerDashboard}');
      final response = await _client.get(url, headers: await _getHeaders()).timeout(_timeout);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final stats = DashboardStatsModel.fromJson(body['stats'] ?? {});
        final activeList = (body['active_orders'] as List? ?? [])
            .map((e) => OrderModel.fromJson(e))
            .toList();
        final historyList = (body['recent_history'] as List? ?? [])
            .map((e) => OrderModel.fromJson(e))
            .toList();

        return ApiResponse(
          success: true,
          data: {
            'stats': stats,
            'active_orders': activeList,
            'recent_history': historyList,
          },
        );
      }
      throw Exception();
    } catch (_) {
      return ApiResponse(
        success: true,
        data: {
          'stats': MockDataService.dashboardStats,
          'active_orders': MockDataService.getActiveOrders(),
          'recent_history': MockDataService.getHistoryOrders(),
        },
        isFromMock: true,
      );
    }
  }

  // ---------------- ORDERS & TRACKING ----------------
  static Future<ApiResponse<List<OrderModel>>> getOrders() async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      return ApiResponse(
        success: true,
        data: MockDataService.getActiveOrders(),
        isFromMock: true,
      );
    }

    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.customerOrders}');
      final response = await _client.get(url, headers: await _getHeaders()).timeout(_timeout);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = (body['data'] as List? ?? [])
            .map((e) => OrderModel.fromJson(e))
            .where((o) => o.status != 'Selesai' && o.status != 'Dibatalkan')
            .toList();
        return ApiResponse(success: true, data: list);
      }
      throw Exception();
    } catch (_) {
      return ApiResponse(
        success: true,
        data: MockDataService.getActiveOrders(),
        isFromMock: true,
      );
    }
  }

  // ---------------- ORDER HISTORY ----------------
  static Future<ApiResponse<List<OrderModel>>> getHistory({
    String? status,
    String? bulan,
    String? sort,
    String? nota,
  }) async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      var list = MockDataService.getHistoryOrders();
      if (status != null && status != 'Semua') {
        list = list.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
      }
      if (nota != null && nota.trim().isNotEmpty) {
        list = list.where((o) => o.nota.toLowerCase().contains(nota.toLowerCase())).toList();
      }
      return ApiResponse(success: true, data: list, isFromMock: true);
    }

    try {
      final queryParams = <String, String>{};
      if (status != null && status != 'Semua') queryParams['status'] = status;
      if (bulan != null && bulan != 'Semua') queryParams['bulan'] = bulan;
      if (sort != null) queryParams['sort'] = sort;
      if (nota != null && nota.isNotEmpty) queryParams['nota'] = nota;

      final uri = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.customerHistory}')
          .replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: await _getHeaders()).timeout(_timeout);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = (body['data'] as List? ?? [])
            .map((e) => OrderModel.fromJson(e))
            .toList();
        return ApiResponse(success: true, data: list);
      }
      throw Exception();
    } catch (_) {
      var list = MockDataService.getHistoryOrders();
      if (status != null && status != 'Semua') {
        list = list.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
      }
      if (nota != null && nota.trim().isNotEmpty) {
        list = list.where((o) => o.nota.toLowerCase().contains(nota.toLowerCase())).toList();
      }
      return ApiResponse(success: true, data: list, isFromMock: true);
    }
  }

  // ---------------- NOTIFICATIONS ----------------
  static Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    final useMock = await SessionService.isUseMock();
    if (useMock) {
      return ApiResponse(
        success: true,
        data: MockDataService.getNotifications(),
        isFromMock: true,
      );
    }

    try {
      final url = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.customerNotifications}');
      final response = await _client.get(url, headers: await _getHeaders()).timeout(_timeout);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = (body['data'] as List? ?? [])
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        return ApiResponse(success: true, data: list);
      }
      throw Exception();
    } catch (_) {
      return ApiResponse(
        success: true,
        data: MockDataService.getNotifications(),
        isFromMock: true,
      );
    }
  }

  // ---------------- PUBLIC TRACKING (NO LOGIN REQUIRED) ----------------
  static Future<ApiResponse<OrderModel>> trackByNota(String nota) async {
    try {
      final uri = Uri.parse('${ApiConstants.activeBaseUrl}${ApiConstants.landingTrack}')
          .replace(queryParameters: {'nota': nota.trim()});
      final response = await _client.get(uri, headers: await _getHeaders(withAuth: false)).timeout(_timeout);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['data'] != null) {
        final order = OrderModel.fromJson(body['data']);
        return ApiResponse(success: true, data: order);
      }
      throw Exception();
    } catch (_) {
      // Look in mock data
      final all = [...MockDataService.getActiveOrders(), ...MockDataService.getHistoryOrders()];
      final match = all.firstWhere(
        (o) => o.nota.toLowerCase() == nota.trim().toLowerCase(),
        orElse: () => all.first,
      );
      return ApiResponse(success: true, data: match, isFromMock: true);
    }
  }

  // ---------------- SERVICES ----------------
  static Future<ApiResponse<List<ServiceItemModel>>> getServices() async {
    return ApiResponse(
      success: true,
      data: MockDataService.getServices(),
      isFromMock: true,
    );
  }
}
