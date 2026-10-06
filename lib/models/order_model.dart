class OrderItemModel {
  final String item;
  final String jumlah;
  final String harga;
  final String sub;

  OrderItemModel({
    required this.item,
    required this.jumlah,
    required this.harga,
    required this.sub,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      item: json['item'] ?? json['item_name'] ?? 'Item',
      jumlah: json['jumlah']?.toString() ??
          (json['quantity'] != null
              ? '${json['quantity']} ${json['unit'] ?? 'Pcs'}'
              : '1'),
      harga: json['harga']?.toString() ??
          (json['unit_price'] != null ? 'Rp ${json['unit_price']}' : 'Rp 0'),
      sub: json['sub']?.toString() ??
          (json['subtotal'] != null ? 'Rp ${json['subtotal']}' : 'Rp 0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'jumlah': jumlah,
      'harga': harga,
      'sub': sub,
    };
  }
}

class TimelineStepModel {
  final String label;
  final String? date;
  final bool isDone;
  final bool isCurrent;

  TimelineStepModel({
    required this.label,
    this.date,
    this.isDone = false,
    this.isCurrent = false,
  });
}

class OrderModel {
  final String id;
  final String nota;
  final String customerName;
  final String status;
  final int activeStep;
  final String layanan;
  final String tanggalOrder;
  final String totalBerat;
  final String totalHarga;
  final String estimasi;
  final List<OrderItemModel> items;
  final List<String?> rawTimeline;

  OrderModel({
    required this.id,
    required this.nota,
    this.customerName = 'Pelanggan',
    required this.status,
    required this.activeStep,
    required this.layanan,
    required this.tanggalOrder,
    required this.totalBerat,
    required this.totalHarga,
    required this.estimasi,
    required this.items,
    this.rawTimeline = const [],
  });

  // Calculate step index from status
  static int getStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'order diterima':
      case 'diterima':
        return 0;
      case 'sedang dipilah':
      case 'di pilah':
      case 'dipilah':
        return 1;
      case 'sedang dicuci':
      case 'di cuci':
      case 'dicuci':
        return 2;
      case 'siap diambil':
      case 'siap di ambil':
      case 'siap ambil':
        return 3;
      case 'selesai':
        return 3;
      case 'dibatalkan':
      case 'batal':
        return 0;
      default:
        return 0;
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] ?? 'Order Diterima';
    final computedStep = json['activeStep'] is int
        ? json['activeStep']
        : getStepIndex(statusStr);

    List<OrderItemModel> itemsList = [];
    if (json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    }

    List<String?> timelineList = [];
    if (json['timeline'] is List) {
      timelineList = (json['timeline'] as List).map((t) {
        if (t == null) return null;
        if (t is String) return t;
        if (t is Map && t['date'] != null) return '${t['label'] ?? ''}\n${t['date']}';
        return t.toString();
      }).toList();
    }

    return OrderModel(
      id: json['id']?.toString() ?? json['nota'] ?? '',
      nota: json['nota'] ?? json['invoice_no'] ?? '-',
      customerName: json['customer_name'] ?? json['nama'] ?? 'Pelanggan',
      status: statusStr,
      activeStep: computedStep,
      layanan: json['layanan'] ?? json['service'] ?? 'Cuci Komplit',
      tanggalOrder: json['tanggalOrder'] ??
          json['order_date'] ??
          json['tgl'] ??
          json['tanggal'] ??
          '-',
      totalBerat: json['totalBerat'] ??
          (json['weight'] != null ? '${json['weight']} kg' : (json['berat'] ?? '-')),
      totalHarga: json['totalHarga'] ??
          json['totalBayar'] ??
          (json['total_price'] != null ? 'Rp ${json['total_price']}' : (json['total'] ?? 'Rp 0')),
      estimasi: json['estimasi'] ?? json['estimated_date'] ?? '-',
      items: itemsList,
      rawTimeline: timelineList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nota': nota,
      'nama': customerName,
      'status': status,
      'activeStep': activeStep,
      'layanan': layanan,
      'tanggalOrder': tanggalOrder,
      'totalBerat': totalBerat,
      'totalHarga': totalHarga,
      'estimasi': estimasi,
      'items': items.map((i) => i.toJson()).toList(),
      'timeline': rawTimeline,
    };
  }
}
