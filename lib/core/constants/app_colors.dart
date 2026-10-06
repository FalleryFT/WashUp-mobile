import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0077B6);
  static const Color primaryDark = Color(0xFF023E8A);
  static const Color primaryLight = Color(0xFF00B4D8);
  static const Color primarySky = Color(0xFF5BBFE8);
  static const Color primarySoft = Color(0xFF7ECFE0);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundLight = Color(0xFFEAF6FB);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textNavy = Color(0xFF1A3D5C);

  // Status Badges & Accents
  static const Color statusOrderReceived = Color(0xFF2563EB); // Blue
  static const Color statusOrderReceivedBg = Color(0xFFDBEAFE);

  static const Color statusSorting = Color(0xFF9333EA); // Purple
  static const Color statusSortingBg = Color(0xFFF3E8FF);

  static const Color statusWashing = Color(0xFFD97706); // Yellow/Amber
  static const Color statusWashingBg = Color(0xFFFEF3C7);

  static const Color statusReady = Color(0xFF0891B2); // Cyan
  static const Color statusReadyBg = Color(0xFFCFFAFE);

  static const Color statusCompleted = Color(0xFF16A34A); // Green
  static const Color statusCompletedBg = Color(0xFFDCFCE7);

  static const Color statusCancelled = Color(0xFFDC2626); // Red
  static const Color statusCancelledBg = Color(0xFFFEE2E2);

  // Semantic colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color divider = Color(0xFFCBD5E1);

  // Helper method for status styling
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order diterima':
      case 'diterima':
        return statusOrderReceived;
      case 'sedang dipilah':
      case 'di pilah':
      case 'dipilah':
        return statusSorting;
      case 'sedang dicuci':
      case 'di cuci':
      case 'dicuci':
        return statusWashing;
      case 'siap diambil':
      case 'siap di ambil':
      case 'siap ambil':
        return statusReady;
      case 'selesai':
        return statusCompleted;
      case 'dibatalkan':
      case 'batal':
        return statusCancelled;
      default:
        return textSecondary;
    }
  }

  static Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'order diterima':
      case 'diterima':
        return statusOrderReceivedBg;
      case 'sedang dipilah':
      case 'di pilah':
      case 'dipilah':
        return statusSortingBg;
      case 'sedang dicuci':
      case 'di cuci':
      case 'dicuci':
        return statusWashingBg;
      case 'siap diambil':
      case 'siap di ambil':
      case 'siap ambil':
        return statusReadyBg;
      case 'selesai':
        return statusCompletedBg;
      case 'dibatalkan':
      case 'batal':
        return statusCancelledBg;
      default:
        return Color(0xFFF1F5F9);
    }
  }
}
