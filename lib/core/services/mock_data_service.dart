import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/notification_model.dart';
import '../../models/chat_message_model.dart';
import '../../models/service_item_model.dart';
import '../../models/dashboard_stats_model.dart';

class MockDataService {
  static final UserModel defaultUser = UserModel(
    id: 1,
    name: 'Budi Santoso',
    username: 'budisantoso',
    email: 'budi@washup.id',
    noHp: '0812-3456-7890',
    alamat: 'Jl. Merdeka No. 45, Kebayoran Baru, Jakarta Selatan',
    role: 'customer',
    memberSejak: 'Januari 2026',
  );

  static final DashboardStatsModel dashboardStats = DashboardStatsModel(
    pesananAktif: 2,
    selesai: 14,
    pengeluaranBulanIni: 245000,
  );

  static List<OrderModel> getActiveOrders() {
    return [
      OrderModel(
        id: '101',
        nota: 'WU-20261001-001',
        customerName: 'Budi Santoso',
        status: 'Sedang Dicuci',
        activeStep: 2,
        layanan: 'Cuci Komplit Express',
        tanggalOrder: '01/10/2026',
        totalBerat: '4.5 kg',
        totalHarga: 'Rp 45.000',
        estimasi: '02 Okt 2026 (17:00)',
        items: [
          OrderItemModel(item: 'Kemeja Katun', jumlah: '3 Pcs', harga: 'Rp 10.000', sub: 'Rp 30.000'),
          OrderItemModel(item: 'Celana Panjang Jeans', jumlah: '1 Pcs', harga: 'Rp 15.000', sub: 'Rp 15.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n01 Okt 09:30',
          'Sedang Di Pilah\n01 Okt 11:15',
          'Sedang Di Cuci\n01 Okt 14:00',
          null,
        ],
      ),
      OrderModel(
        id: '102',
        nota: 'WU-20261001-002',
        customerName: 'Budi Santoso',
        status: 'Sedang Dipilah',
        activeStep: 1,
        layanan: 'Cuci Satuan Spesial',
        tanggalOrder: '01/10/2026',
        totalBerat: '2.0 kg',
        totalHarga: 'Rp 75.000',
        estimasi: '03 Okt 2026 (12:00)',
        items: [
          OrderItemModel(item: 'Jas Formal Pria', jumlah: '1 Set', harga: 'Rp 50.000', sub: 'Rp 50.000'),
          OrderItemModel(item: 'Sepatu Sneakers', jumlah: '1 Pasang', harga: 'Rp 25.000', sub: 'Rp 25.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n01 Okt 13:00',
          'Sedang Di Pilah\n01 Okt 15:30',
          null,
          null,
        ],
      ),
    ];
  }

  static List<OrderModel> getHistoryOrders() {
    return [
      OrderModel(
        id: '101',
        nota: 'WU-20261001-001',
        customerName: 'Budi Santoso',
        status: 'Sedang Dicuci',
        activeStep: 2,
        layanan: 'Cuci Komplit Express',
        tanggalOrder: '01/10/2026',
        totalBerat: '4.5 kg',
        totalHarga: 'Rp 45.000',
        estimasi: '02 Okt 2026',
        items: [
          OrderItemModel(item: 'Kemeja Katun', jumlah: '3 Pcs', harga: 'Rp 10.000', sub: 'Rp 30.000'),
          OrderItemModel(item: 'Celana Panjang Jeans', jumlah: '1 Pcs', harga: 'Rp 15.000', sub: 'Rp 15.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n01 Okt 09:30',
          'Sedang Di Pilah\n01 Okt 11:15',
          'Sedang Di Cuci\n01 Okt 14:00',
          null,
        ],
      ),
      OrderModel(
        id: '102',
        nota: 'WU-20261001-002',
        customerName: 'Budi Santoso',
        status: 'Sedang Dipilah',
        activeStep: 1,
        layanan: 'Cuci Satuan Spesial',
        tanggalOrder: '01/10/2026',
        totalBerat: '2.0 kg',
        totalHarga: 'Rp 75.000',
        estimasi: '03 Okt 2026',
        items: [
          OrderItemModel(item: 'Jas Formal Pria', jumlah: '1 Set', harga: 'Rp 50.000', sub: 'Rp 50.000'),
          OrderItemModel(item: 'Sepatu Sneakers', jumlah: '1 Pasang', harga: 'Rp 25.000', sub: 'Rp 25.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n01 Okt 13:00',
          'Sedang Di Pilah\n01 Okt 15:30',
          null,
          null,
        ],
      ),
      OrderModel(
        id: '99',
        nota: 'WU-20260928-015',
        customerName: 'Budi Santoso',
        status: 'Selesai',
        activeStep: 3,
        layanan: 'Cuci Kering Setrika',
        tanggalOrder: '28/09/2026',
        totalBerat: '5.0 kg',
        totalHarga: 'Rp 50.000',
        estimasi: '30/09/2026',
        items: [
          OrderItemModel(item: 'Pakaian Harian', jumlah: '5.0 kg', harga: 'Rp 10.000', sub: 'Rp 50.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n28 Sep 08:00',
          'Sedang Di Pilah\n28 Sep 09:30',
          'Sedang Di Cuci\n28 Sep 11:00',
          'Siap Di Ambil\n29 Sep 16:00',
        ],
      ),
      OrderModel(
        id: '98',
        nota: 'WU-20260920-008',
        customerName: 'Budi Santoso',
        status: 'Selesai',
        activeStep: 3,
        layanan: 'Cuci Bed Cover',
        tanggalOrder: '20/09/2026',
        totalBerat: '4.0 kg',
        totalHarga: 'Rp 60.000',
        estimasi: '22/09/2026',
        items: [
          OrderItemModel(item: 'Bed Cover King Size', jumlah: '1 Pcs', harga: 'Rp 45.000', sub: 'Rp 45.000'),
          OrderItemModel(item: 'Sarung Bantal Guling', jumlah: '4 Pcs', harga: 'Rp 3.750', sub: 'Rp 15.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n20 Sep 10:00',
          'Sedang Di Pilah\n20 Sep 11:30',
          'Sedang Di Cuci\n20 Sep 14:00',
          'Siap Di Ambil\n22 Sep 10:00',
        ],
      ),
      OrderModel(
        id: '95',
        nota: 'WU-20260912-004',
        customerName: 'Budi Santoso',
        status: 'Selesai',
        activeStep: 3,
        layanan: 'Cuci Setrika Reguler',
        tanggalOrder: '12/09/2026',
        totalBerat: '3.5 kg',
        totalHarga: 'Rp 35.000',
        estimasi: '14/09/2026',
        items: [
          OrderItemModel(item: 'Campuran Kiloan', jumlah: '3.5 kg', harga: 'Rp 10.000', sub: 'Rp 35.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n12 Sep 09:00',
          'Sedang Di Pilah\n12 Sep 10:00',
          'Sedang Di Cuci\n12 Sep 13:00',
          'Siap Di Ambil\n14 Sep 11:00',
        ],
      ),
      OrderModel(
        id: '92',
        nota: 'WU-20260825-003',
        customerName: 'Budi Santoso',
        status: 'Dibatalkan',
        activeStep: 0,
        layanan: 'Cuci Sepatu Premium',
        tanggalOrder: '25/08/2026',
        totalBerat: '1.0 kg',
        totalHarga: 'Rp 40.000',
        estimasi: '27/08/2026',
        items: [
          OrderItemModel(item: 'Sepatu Kulit Formal', jumlah: '1 Pasang', harga: 'Rp 40.000', sub: 'Rp 40.000'),
        ],
        rawTimeline: [
          'Order Di Terima\n25 Agu 14:00',
          null,
          null,
          null,
        ],
      ),
    ];
  }

  static List<NotificationModel> getNotifications() {
    return [
      NotificationModel(
        id: 1,
        title: 'Pesanan Sedang Dicuci',
        message: 'Pesanan nota WU-20261001-001 saat ini sedang masuk tahap pencucian higienis.',
        waktu: '14:00',
        tanggal: '01/10/2026',
        isRead: false,
      ),
      NotificationModel(
        id: 2,
        title: 'Pesanan Sedang Dipilah',
        message: 'Pesanan nota WU-20261001-002 telah diterima dan staf kami sedang memilah bahan kain.',
        waktu: '11:15',
        tanggal: '01/10/2026',
        isRead: false,
      ),
      NotificationModel(
        id: 3,
        title: 'Order Berhasil Diterima',
        message: 'Order WU-20261001-001 telah tercatat di sistem kami. Terima kasih atas kepercayaan Anda!',
        waktu: '09:30',
        tanggal: '01/10/2026',
        isRead: true,
      ),
      NotificationModel(
        id: 4,
        title: 'Pesanan Selesai & Siap Diambil',
        message: 'Pesanan WU-20260928-015 sudah bersih, wangi, rapi, dan siap diambil di outlet.',
        waktu: '16:00',
        tanggal: '29/09/2026',
        isRead: true,
      ),
      NotificationModel(
        id: 5,
        title: 'Maaf atas Kekeliruan Estimasi',
        message: 'Kami sempat melakukan penyesuaian waktu proses untuk bahan tertentu agar tetap awet.',
        waktu: '10:00',
        tanggal: '20/09/2026',
        isRead: true,
      ),
    ];
  }

  static List<ChatMessageModel> getInitialChatMessages() {
    return [
      ChatMessageModel(
        id: '1',
        from: 'admin',
        text: 'Halo Kak Budi! 👋 Selamat datang di layanan Customer Care WashUp. Ada yang bisa kami bantu seputar cucian Anda hari ini?',
        time: '14.05',
      ),
      ChatMessageModel(
        id: '2',
        from: 'customer',
        text: 'Halo CS, mau tanya pesanan saya WU-20261001-001 estimasi selesai jam berapa ya?',
        time: '14.07',
      ),
      ChatMessageModel(
        id: '3',
        from: 'admin',
        text: 'Baik Kak Budi, cucian dengan nota WU-20261001-001 saat ini sedang tahap pencucian dan diperkirakan selesai besok sore sekitar jam 17:00 ya. Kami kabari segera begitu siap diambil! 😊',
        time: '14.09',
      ),
    ];
  }

  static List<ServiceItemModel> getServices() {
    return [
      ServiceItemModel(
        id: 1,
        name: 'Cuci Komplit Reguler',
        price: 8000,
        unit: 'Kg',
        type: 'kiloan',
        description: 'Cuci bersih, pewangi premium, pengeringan higienis & setrika rapi.',
      ),
      ServiceItemModel(
        id: 2,
        name: 'Cuci Komplit Express (6 Jam)',
        price: 15000,
        unit: 'Kg',
        type: 'kiloan',
        description: 'Selesai dalam 6 jam! Pilihan tepat saat mendesak.',
      ),
      ServiceItemModel(
        id: 3,
        name: 'Cuci Kering Saja',
        price: 6000,
        unit: 'Kg',
        type: 'kiloan',
        description: 'Pencucian wangi dan pengeringan optimal tanpa setrika.',
      ),
      ServiceItemModel(
        id: 4,
        name: 'Setrika Uap Presisi',
        price: 5000,
        unit: 'Kg',
        type: 'kiloan',
        description: 'Pelipatan rapi & setrika uap anti kusut untuk pakaian siap pakai.',
      ),
      ServiceItemModel(
        id: 5,
        name: 'Jas / Blazer Formal',
        price: 45000,
        unit: 'Pcs',
        type: 'satuan',
        description: 'Dry cleaning & steam press perawatan khusus serat jas mewah.',
      ),
      ServiceItemModel(
        id: 6,
        name: 'Bed Cover King Size',
        price: 40000,
        unit: 'Pcs',
        type: 'satuan',
        description: 'Pembersihan tungau, noda membandel & aroma tahan lama.',
      ),
      ServiceItemModel(
        id: 7,
        name: 'Sepatu Sneakers / Formal',
        price: 30000,
        unit: 'Pasang',
        type: 'satuan',
        description: 'Deep cleaning midsole, insole & upper dengan proteksi anti bakteri.',
      ),
      ServiceItemModel(
        id: 8,
        name: 'Karpet & Gorden',
        price: 25000,
        unit: 'Meter',
        type: 'satuan',
        description: 'Vacuum intensif & pencucian higienis untuk serat tebal.',
      ),
    ];
  }
}
