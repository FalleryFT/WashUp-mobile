# WashUp - Aplikasi Layanan Laundry

WashUp adalah aplikasi mobile berbasis Flutter untuk pelanggan layanan laundry. Pelanggan dapat memantau pesanan, melihat riwayat, menerima notifikasi status cucian, melacak nota, dan berkomunikasi lewat chat.

Aplikasi dapat berjalan dalam dua mode:

- **Mode mock (bawaan):** memakai data contoh bawaan aplikasi, tanpa backend.
- **Mode API:** terhubung ke backend REST API (`/api`) yang berjalan di server sendiri.

## Fitur

| Fitur | Keterangan |
|---|---|
| Splash screen | Layar pembuka dan pengecekan sesi login |
| Autentikasi | Login dan registrasi pelanggan, serta login demo cepat |
| Beranda (dashboard) | Ringkasan statistik, banner, dan daftar layanan |
| Pesanan | Daftar pesanan yang sedang berjalan, lengkap dengan progres |
| Riwayat | Daftar pesanan yang sudah selesai atau dibatalkan, dengan filter |
| Lacak pesanan | Pelacakan pesanan berdasarkan nomor nota, tampil sebagai timeline |
| Notifikasi | Pemberitahuan status: diterima, dipilah, dicuci, siap ambil, selesai, batal |
| Profil | Ubah data diri, atur mode mock, dan atur URL server |
| Chat | Percakapan dengan admin laundry |

## Struktur Folder

```
lib/
├── main.dart                  # Titik masuk aplikasi, tema, dan provider
├── core/
│   ├── constants/             # Warna (app_colors) dan endpoint API (api_constants)
│   ├── services/              # api_service, app_state, mock_data_service, session_service
│   └── utils/                 # Format mata uang dan format tanggal
├── models/                    # User, Order, Notification, DashboardStats, ServiceItem, ChatMessage
├── screens/
│   ├── auth/                  # Login dan registrasi
│   ├── customer/              # Dashboard, pesanan, riwayat, lacak, notifikasi, profil
│   ├── chat_screen.dart
│   ├── main_navigation.dart   # Navigasi bawah (5 tab)
│   └── splash_screen.dart
└── widgets/                   # Komponen UI: tombol, input, kartu pesanan, timeline, stepper, badge, banner
assets/
└── images/                    # logo.png, hero.png, Home.png, About.png
```

Aplikasi memakai **Provider** (`ChangeNotifier`) untuk manajemen state. Semua state utama berada di `AppState`.

## Library / Package yang Dipakai

| Package | Fungsi dalam proyek |
|---|---|
| [`flutter`](https://flutter.dev) (Material 3) | Framework UI |
| [`provider`](https://pub.dev/packages/provider) | Manajemen state (`AppState`) |
| [`http`](https://pub.dev/packages/http) | Pemanggilan REST API ke backend |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Penyimpanan lokal: token, data user, URL server, status mode mock |
| [`intl`](https://pub.dev/packages/intl) | Format tanggal dan mata uang (Rupiah) |

Font yang dirujuk tema: **Poppins** (opsional, lihat bagian Font).

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi **3.27 atau lebih baru** (kode memakai `Color.withValues`)
- Untuk Android: Android Studio, Android SDK, dan emulator atau perangkat fisik
- Untuk web: Google Chrome

Periksa lingkungan dengan:

```bash
flutter doctor
```

## Panduan Menjalankan Aplikasi

Repositori ini hanya berisi folder `lib/` dan `assets/`. Buat dulu proyek Flutter sebagai wadah.

### 1. Buat proyek Flutter

```bash
flutter create washup
cd washup
```

### 2. Salin source code

Hapus folder `lib/` bawaan, lalu salin folder `lib/` dan `assets/` dari repositori ini ke dalam folder `washup/`.

### 3. Pasang dependensi

```bash
flutter pub add provider http intl shared_preferences
```

### 4. Daftarkan aset di `pubspec.yaml`

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Indentasi harus 2 spasi.

### 5. Ambil paket dan periksa kode

```bash
flutter pub get
flutter analyze
```

### 6. Jalankan

```bash
flutter run -d chrome    # web, cara paling mudah
flutter run              # emulator atau perangkat Android
```

Pada tampilan awal, isi username dan password apa saja (mode mock menerima semuanya), atau pilih login demo.

## Mode Mock dan Mode API

Mode ditentukan oleh `SessionService.isUseMock()` di `lib/core/services/session_service.dart`. Nilai bawaannya `true`, sehingga aplikasi langsung berjalan dengan data contoh dari `mock_data_service.dart`.

Untuk berpindah ke backend sungguhan:

1. Buka tab **Profil**, lalu matikan sakelar mode mock.
2. Atur URL server, atau ubah `activeBaseUrl` di `lib/core/constants/api_constants.dart`.

| Lingkungan | Base URL |
|---|---|
| Emulator Android | `http://10.0.2.2:8000/api` |
| Chrome / desktop | `http://localhost:8000/api` |
| Perangkat fisik | `http://<IP-komputer-di-jaringan-yang-sama>:8000/api` |

### Endpoint yang dipakai

- Autentikasi: `/login`, `/register`, `/logout`, `/user`, `/send-otp`, `/verify-otp`, `/reset-password`
- Pelanggan: `/customer/dashboard`, `/customer/orders`, `/customer/history`, `/customer/notifications`, `/customer/notifications/unread-count`, `/customer/profile`
- Publik: `/landing/services`, `/landing/track`

Catatan: kode memanggil endpoint `/login` dan `/register` dengan field `username` dan `password`.

## Font (Opsional)

Tema memakai `fontFamily: 'Poppins'`. Tanpa file font, Flutter memakai font bawaan dan aplikasi tetap berjalan. Untuk tampilan sesuai desain:

1. Unduh Poppins dari [Google Fonts](https://fonts.google.com/specimen/Poppins).
2. Taruh file `.ttf` di `assets/fonts/`.
3. Daftarkan di `pubspec.yaml`:

```yaml
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

## Pemecahan Masalah

| Masalah | Solusi |
|---|---|
| `withValues` tidak dikenali | Jalankan `flutter upgrade` |
| Login gagal, padahal tanpa backend | Pastikan mode mock aktif. Hapus data aplikasi jika sebelumnya sempat memakai mode API |
| Gradle gagal (`Could not close incremental caches`) di Windows | Pindahkan proyek ke drive yang sama dengan cache pub (misalnya `C:\src\washup`), atau tambahkan `kotlin.incremental=false` di `android/gradle.properties`, lalu `flutter clean` |
| Aplikasi tidak bisa menjangkau API dari emulator | Gunakan `10.0.2.2`, bukan `localhost` |
| Ingin cepat tanpa Android | `flutter run -d chrome` |

## Lisensi

Tambahkan lisensi sesuai kebutuhan proyek.
