import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/order_timeline_view.dart';
import '../../widgets/status_badge.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Lacak #${order.nota}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nota: ${order.nota}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Poppins'),
                      ),
                      StatusBadge(status: order.status, light: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.calendar_today_outlined, label: 'Masuk', value: DateFormatter.formatDate(order.tanggalOrder), light: true),
                  const SizedBox(height: 6),
                  _InfoRow(icon: Icons.event_outlined, label: 'Estimasi Selesai', value: DateFormatter.formatDate(order.estimasi), light: true),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    label: 'Total',
                    value: CurrencyFormatter.formatFromString(order.totalHarga),
                    light: true,
                    valueStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress Stepper
            const Text('Status Pengerjaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            ProgressStepper(status: order.status),

            const SizedBox(height: 20),

            // Order Items
            if (order.items.isNotEmpty) ...[
              const Text('Rincian Cucian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: order.items.asMap().entries.map((e) {
                    final i = e.key;
                    final item = e.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.dry_cleaning_outlined, color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.item, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                                    Text(item.jumlah, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Text(CurrencyFormatter.formatFromString(item.sub), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 14)),
                            ],
                          ),
                        ),
                        if (i < order.items.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Timeline
            const Text('Riwayat Aktivitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            OrderTimelineView(rawTimeline: order.rawTimeline, status: order.status),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.light = false, this.valueStyle});
  final IconData icon;
  final String label;
  final String value;
  final bool light;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: light ? Colors.white70 : AppColors.textSecondary),
        const SizedBox(width: 6),
        Text('$label: ', style: TextStyle(fontSize: 12, color: light ? Colors.white70 : AppColors.textSecondary)),
        Text(value, style: valueStyle ?? TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: light ? Colors.white : AppColors.textPrimary)),
      ],
    );
  }
}
