/// 🔥 KONFIGURASI APLIKASI
class AppConfig {
  /// JAM MAKSIMAL CHECK-IN (standar 08:00)
  /// Jika check-in setelah jam ini, dihitung TELAT
  static const int maxCheckInHour = 8;
  static const int maxCheckInMinute = 0;

  /// JAM MINIMAL CHECK-OUT (standar 17:00 / 5 PM)
  static const int minCheckOutHour = 17;
  static const int minCheckOutMinute = 0;
}
