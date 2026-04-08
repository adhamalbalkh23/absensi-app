class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com/api";

  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";

  static const String getAbsensi = "$baseUrl/absen/today";
  static const String checkin = "$baseUrl/absen/check-in";
  static const String checkout = "$baseUrl/absen/check-out";
  static const String training = "$baseUrl/trainings";
  static const String batch = "$baseUrl/batches";
  static const String history = "$baseUrl/absen/history";
  static const String profile = "$baseUrl/profile";
  static const String profilephoto = "$baseUrl/profile/photo";
}
