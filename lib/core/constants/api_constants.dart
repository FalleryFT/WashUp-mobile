class ApiConstants {
  // Default Base URL for Android Emulator (10.0.2.2) and Desktop/Web (localhost)
  static const String defaultEmulatorBaseUrl = 'http://10.0.2.2:8000/api';
  static const String defaultLocalhostBaseUrl = 'http://localhost:8000/api';

  // Current active base URL can be dynamically updated from settings
  static String activeBaseUrl = defaultEmulatorBaseUrl;

  // Storage keys
  static const String keyToken = 'washup_token';
  static const String keyUser = 'washup_user';
  static const String keyBaseUrl = 'washup_base_url';
  static const String keyUseMock = 'washup_use_mock';

  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String sendOtp = '/send-otp';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';

  // Customer endpoints
  static const String customerDashboard = '/customer/dashboard';
  static const String customerOrders = '/customer/orders';
  static const String customerHistory = '/customer/history';
  static const String customerNotifications = '/customer/notifications';
  static const String customerNotificationsUnreadCount = '/customer/notifications/unread-count';
  static const String customerProfile = '/customer/profile';

  // Public/Landing endpoints
  static const String landingServices = '/landing/services';
  static const String landingTrack = '/landing/track';
}
