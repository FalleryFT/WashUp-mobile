import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class OrderTimelineView extends StatelessWidget {
  final List<String?> rawTimeline;
  final String status;

  const OrderTimelineView({
    super.key,
    required this.rawTimeline,
    required this.status,
  });

  static const List<String> _labels = [
    'Order Di Terima',
    'Sedang Di Pilah',
    'Sedang Di Cuci',
    'Siap Di Ambil',
  ];

  @override
  Widget build(BuildContext context) {
    final isCancelled = status.toLowerCase() == 'dibatalkan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_labels.length, (i) {
        final label = _labels[i];
        final rawInfo = i < rawTimeline.length ? rawTimeline[i] : null;
        final bool isDone = !isCancelled && rawInfo != null;
        final bool isLast = i == _labels.length - 1;

        String dateStr = '-';
        if (isDone && rawInfo.isNotEmpty) {
          final parts = rawInfo.split('\n');
          if (parts.length > 1) {
            dateStr = parts[1];
          } else {
            dateStr = parts[0];
          }
        }

        Color dotColor;
        if (isCancelled) {
          dotColor = i == 0 ? Colors.red : Colors.grey.shade300;
        } else if (isDone) {
          dotColor = AppColors.statusCompleted;
        } else {
          dotColor = Colors.grey.shade300;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dot and vertical line
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? dotColor : Colors.white,
                      border: Border.all(
                        color: dotColor,
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isDone && (i + 1 < rawTimeline.length && rawTimeline[i + 1] != null)
                            ? AppColors.statusCompleted
                            : Colors.grey.shade200,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Text info
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isCancelled && i == 0
                            ? Colors.red
                            : isDone
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isCancelled && i == 0
                          ? 'Pesanan dibatalkan'
                          : isDone
                              ? dateStr
                              : 'Belum terjadi',
                      style: TextStyle(
                        fontSize: 11,
                        color: isCancelled && i == 0
                            ? Colors.red.shade300
                            : isDone
                                ? AppColors.textSecondary
                                : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
