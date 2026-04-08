import 'dart:convert';
import 'package:absensi_apps/view/chekin_page.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<bool> checkOutApi({
  required String token,
  required String attendanceDate,
  required double lat,
  required double lng,
  required String address,
}) async {
  final now = DateTime.now();

  final formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

  final response = await http.post(
    Uri.parse(Endpoint.checkout),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "attendance_date": attendanceDate,
      "check_out": formattedTime,
      "check_out_lat": lat,
      "check_out_lng": lng,
      "check_out_address": address,
    }),
  );

  print("CHECKOUT STATUS: ${response.statusCode}");
  print("CHECKOUT BODY: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}
