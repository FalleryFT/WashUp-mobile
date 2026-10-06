class DashboardStatsModel {
  final int pesananAktif;
  final int selesai;
  final num pengeluaranBulanIni;

  DashboardStatsModel({
    required this.pesananAktif,
    required this.selesai,
    required this.pengeluaranBulanIni,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      pesananAktif: json['pesanan_aktif'] is int
          ? json['pesanan_aktif']
          : int.tryParse(json['pesanan_aktif']?.toString() ?? '0') ?? 0,
      selesai: json['selesai'] is int
          ? json['selesai']
          : int.tryParse(json['selesai']?.toString() ?? '0') ?? 0,
      pengeluaranBulanIni: json['pengeluaran_bulan_ini'] is num
          ? json['pengeluaran_bulan_ini']
          : num.tryParse(json['pengeluaran_bulan_ini']?.toString().replaceAll(RegExp(r'\D'), '') ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pesanan_aktif': pesananAktif,
      'selesai': selesai,
      'pengeluaran_bulan_ini': pengeluaranBulanIni,
    };
  }
}
