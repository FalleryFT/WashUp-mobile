import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/notification_model.dart';
import '../../models/chat_message_model.dart';
import '../../models/dashboard_stats_model.dart';
import 'session_service.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = true;
  bool _isUseMock = false;
  String _baseUrl = '';

  DashboardStatsModel? _stats;
  List<OrderModel> _activeOrders = [];
  List<OrderModel> _historyOrders = [];
  List<NotificationModel> _notifications = [];
  List<ChatMessageModel> _chatMessages = [];

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isUseMock => _isUseMock;
  String get baseUrl => _baseUrl;

  DashboardStatsModel? get stats => _stats;
  List<OrderModel> get activeOrders => _activeOrders;
  List<OrderModel> get historyOrders => _historyOrders;
  List<NotificationModel> get notifications => _notifications;
  List<ChatMessageModel> get chatMessages => _chatMessages;

  /// Returns history as Map list for dashboard table display
  List<Map<String, dynamic>> get recentHistory => _historyOrders.map((o) => {
    'tanggal': o.tanggalOrder,
    'nota': o.nota,
    'layanan': o.layanan,
    'total': o.totalHarga,
    'status': o.status,
  }).toList();

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await SessionService.init();
    _currentUser = await SessionService.getUser();
    _isUseMock = await SessionService.isUseMock();
    _baseUrl = await SessionService.getBaseUrl();
    _chatMessages = MockDataService.getInitialChatMessages();

    if (_currentUser != null) {
      await refreshAllData();
    } else {
      // Preload mock data for instant preview if needed
      _stats = MockDataService.dashboardStats;
      _activeOrders = MockDataService.getActiveOrders();
      _historyOrders = MockDataService.getHistoryOrders();
      _notifications = MockDataService.getNotifications();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAllData() async {
    await Future.wait([
      refreshDashboard(),
      refreshOrders(),
      refreshHistory(),
      refreshNotifications(),
    ]);
  }

  Future<void> refreshDashboard() async {
    final res = await ApiService.getDashboard();
    if (res.success && res.data != null) {
      _stats = res.data!['stats'];
      _activeOrders = res.data!['active_orders'] ?? [];
      _historyOrders = res.data!['recent_history'] ?? [];
      notifyListeners();
    }
  }

  Future<void> refreshOrders() async {
    final res = await ApiService.getOrders();
    if (res.success && res.data != null) {
      _activeOrders = res.data!;
      notifyListeners();
    }
  }

  Future<void> refreshHistory({String? status, String? bulan, String? sort, String? nota}) async {
    final res = await ApiService.getHistory(status: status, bulan: bulan, sort: sort, nota: nota);
    if (res.success && res.data != null) {
      _historyOrders = res.data!;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    final res = await ApiService.getNotifications();
    if (res.success && res.data != null) {
      _notifications = res.data!;
      notifyListeners();
    }
  }

  // Mark single notification as read
  void markNotificationRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all notifications read
  void markAllNotificationsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Delete read notifications
  void deleteReadNotifications() {
    _notifications.removeWhere((n) => n.isRead);
    notifyListeners();
  }

  // Send Chat message with simulated CS reply
  void sendChatMessage(String text) {
    if (text.trim().isEmpty) return;
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    final userMsg = ChatMessageModel(
      id: now.millisecondsSinceEpoch.toString(),
      from: 'customer',
      text: text.trim(),
      time: timeStr,
    );
    _chatMessages.add(userMsg);
    notifyListeners();

    // Auto reply from CS after 1 second
    Timer(const Duration(milliseconds: 1200), () {
      final replyTime = DateTime.now();
      final replyTimeStr = '${replyTime.hour.toString().padLeft(2, '0')}.${replyTime.minute.toString().padLeft(2, '0')}';

      String replyText = 'Terima kasih telah menghubungi CS WashUp! Staf kami sedang memproses permintaan Anda.';
      final lower = text.toLowerCase();
      if (lower.contains('status') || lower.contains('pesanan') || lower.contains('nota')) {
        replyText = 'Pesanan Anda dengan nota WU-20261001-001 saat ini sedang tahap pencucian higienis dan ditangani dengan hati-hati oleh tim kami.';
      } else if (lower.contains('harga') || lower.contains('biaya') || lower.contains('tarif')) {
        replyText = 'Tarif kami mulai dari Rp 8.000/kg untuk Cuci Komplit Reguler dan Rp 15.000/kg untuk layanan kilat 6 Jam. Cek tab Layanan untuk daftar lengkapnya ya!';
      } else if (lower.contains('jemput') || lower.contains('antar') || lower.contains('delivery')) {
        replyText = 'Layanan antar-jemput cucian tersedia setiap hari pukul 08:00 - 20:00 WIB. Driver kami siap meluncur ke alamat Anda!';
      }

      final adminMsg = ChatMessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        from: 'admin',
        text: replyText,
        time: replyTimeStr,
      );
      _chatMessages.add(adminMsg);
      notifyListeners();
    });
  }

  // Login
  Future<ApiResponse<UserModel>> login(String username, String password) async {
    final res = await ApiService.login(username, password);
    if (res.success && res.data != null) {
      _currentUser = res.data;
      await refreshAllData();
      notifyListeners();
    }
    return res;
  }

  // Register
  Future<ApiResponse<UserModel>> register(Map<String, dynamic> data) async {
    final res = await ApiService.register(data);
    if (res.success && res.data != null) {
      _currentUser = res.data;
      await refreshAllData();
      notifyListeners();
    }
    return res;
  }

  // Quick Demo Login
  Future<void> loginAsDemo() async {
    _currentUser = MockDataService.defaultUser;
    _isUseMock = true;
    await SessionService.setUseMock(true);
    await SessionService.saveUser(_currentUser!);
    await SessionService.saveToken('mock_demo_token');
    _stats = MockDataService.dashboardStats;
    _activeOrders = MockDataService.getActiveOrders();
    _historyOrders = MockDataService.getHistoryOrders();
    _notifications = MockDataService.getNotifications();
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await ApiService.logout();
    _currentUser = null;
    notifyListeners();
  }

  // Update Profile
  Future<bool> updateProfile({required String nama, required String noHp, required String alamat}) async {
    if (_currentUser == null) return false;
    final updated = _currentUser!.copyWith(name: nama, noHp: noHp, alamat: alamat);
    _currentUser = updated;
    await SessionService.saveUser(updated);
    notifyListeners();
    return true;
  }

  // Switch Mock Mode
  Future<void> toggleMockMode(bool enable) async {
    _isUseMock = enable;
    await SessionService.setUseMock(enable);
    await refreshAllData();
    notifyListeners();
  }

  // Update Base URL
  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    await SessionService.setBaseUrl(url);
    notifyListeners();
  }
}
