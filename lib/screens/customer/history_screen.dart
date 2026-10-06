import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/order_model.dart';
import '../../widgets/status_badge.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _filterStatus;
  String _sort = 'terbaru';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<String> _statusOptions = ['', 'selesai', 'diambil', 'dibatalkan'];
  final List<String> _statusLabels = ['Semua', 'Selesai', 'Diambil', 'Dibatalkan'];
  final List<String> _sortOptions = ['terbaru', 'terlama', 'tertinggi', 'terendah'];
  final List<String> _sortLabels = ['Terbaru', 'Terlama', 'Harga ↑', 'Harga ↓'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<OrderModel> _applyFilters(List<OrderModel> orders) {
    var filtered = orders.where((o) {
      final matchStatus = _filterStatus == null || _filterStatus!.isEmpty || o.status == _filterStatus;
      final matchSearch = _searchQuery.isEmpty ||
          o.nota.toLowerCase().contains(_searchQuery) ||
          o.customerName.toLowerCase().contains(_searchQuery);
      return matchStatus && matchSearch;
    }).toList();

    switch (_sort) {
      case 'terlama':
        filtered.sort((a, b) => a.tanggalOrder.compareTo(b.tanggalOrder));
        break;
      case 'tertinggi':
        filtered.sort((a, b) => b.totalHarga.compareTo(a.totalHarga));
        break;
      case 'terendah':
        filtered.sort((a, b) => a.totalHarga.compareTo(b.totalHarga));
        break;
      default:
        filtered.sort((a, b) => b.tanggalOrder.compareTo(a.tanggalOrder));
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final history = _applyFilters(state.historyOrders);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Laundry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<AppState>().refreshHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'Cari nota atau nama...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                            onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 10),
                // Filters Row
                Row(
                  children: [
                    // Status filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _filterStatus ?? '',
                        decoration: InputDecoration(
                          labelText: 'Status',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: List.generate(_statusOptions.length, (i) =>
                          DropdownMenuItem(value: _statusOptions[i], child: Text(_statusLabels[i], style: const TextStyle(fontSize: 13))),
                        ),
                        onChanged: (v) => setState(() => _filterStatus = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _sort,
                        decoration: InputDecoration(
                          labelText: 'Urutan',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: List.generate(_sortOptions.length, (i) =>
                          DropdownMenuItem(value: _sortOptions[i], child: Text(_sortLabels[i], style: const TextStyle(fontSize: 13))),
                        ),
                        onChanged: (v) => setState(() => _sort = v ?? 'terbaru'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Result count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text('${history.length} pesanan ditemukan', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),

          // List
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : history.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => context.read<AppState>().refreshHistory(),
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: history.length,
                          itemBuilder: (ctx, i) => _HistoryCard(order: history[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text('Tidak ada riwayat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Riwayat pesanan selesai akan tampil di sini', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.nota,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary, fontFamily: 'Poppins'),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 5),
              Text(DateFormatter.formatDate(order.tanggalOrder), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              const Icon(Icons.event_available_outlined, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 5),
              Text(DateFormatter.formatDate(order.estimasi), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.scale_outlined, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(order.totalBerat, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              Text(
                CurrencyFormatter.formatFromString(order.totalHarga),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primary, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
