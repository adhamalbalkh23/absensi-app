import 'dart:convert';
import 'package:absensi_apps/view/chekin_page.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<bool> checkInApi({
  required String token,
  required double lat,
  required double lng,
  required String address,
}) async {
  final now = DateTime.now();

  final formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

  final formattedDate =
      "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.post(
    Uri.parse(Endpoint.checkin),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "attendance_date": formattedDate,
      "check_in": formattedTime,
      "check_in_lat": lat,
      "check_in_lng": lng,
      "check_in_address": address,
    }),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}
