import 'package:flutter/material.dart';

enum NotificationType { diterima, dipilah, dicuci, siapAmbil, selesai, batal, undo }

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String waktu;
  final String tanggal;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.waktu,
    required this.tanggal,
    this.isRead = false,
  });

  NotificationType get type {
    final t = title.toLowerCase();
    if (t.contains('maaf') || t.contains('kekeliruan') || t.contains('khilaf')) {
      return NotificationType.undo;
    }
    if (t.contains('dibatalkan') || t.contains('batal')) {
      return NotificationType.batal;
    }
    if (t.contains('dicuci')) {
      return NotificationType.dicuci;
    }
    if (t.contains('dipilah')) {
      return NotificationType.dipilah;
    }
    if (t.contains('selesai') || t.contains('siap')) {
      return NotificationType.selesai;
    }
    return NotificationType.diterima;
  }

  IconData get icon {
    switch (type) {
      case NotificationType.undo:
        return Icons.replay_rounded;
      case NotificationType.batal:
        return Icons.warning_amber_rounded;
      case NotificationType.dicuci:
        return Icons.local_laundry_service_rounded;
      case NotificationType.dipilah:
        return Icons.layers_outlined;
      case NotificationType.siapAmbil:
        return Icons.check_circle_outline_rounded;
      case NotificationType.selesai:
        return Icons.check_circle_rounded;
      case NotificationType.diterima:
        return Icons.assignment_turned_in_outlined;
    }
  }

  Color get iconBgColor {
    switch (type) {
      case NotificationType.undo:
        return const Color(0xFFF59E0B);
      case NotificationType.batal:
        return const Color(0xFFEF4444);
      case NotificationType.dicuci:
        return const Color(0xFF38BDF8);
      case NotificationType.dipilah:
        return const Color(0xFFA855F7);
      case NotificationType.siapAmbil:
      case NotificationType.selesai:
        return const Color(0xFF10B981);
      case NotificationType.diterima:
        return const Color(0xFF10B981);
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? 'Pemberitahuan',
      message: json['message'] ?? '',
      waktu: json['waktu'] ?? json['time'] ?? '12:00',
      tanggal: json['tanggal'] ?? json['date'] ?? '-',
      isRead: json['is_read'] == true || json['is_read'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'waktu': waktu,
      'tanggal': tanggal,
      'is_read': isRead,
    };
  }
}
