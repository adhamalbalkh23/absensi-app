import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<bool> updateProfile({
  required String token,
  required String name,
  required String email,
}) async {
  final response = await http.post(
    Uri.parse(Endpoint.profile),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    body: {
      "name": name,
      "email": email,
      "_method": "PUT", // 🔥 INI KUNCI
    },
  );

  print("UPDATE STATUS: ${response.statusCode}");
  print("UPDATE BODY: ${response.body}");

  return response.statusCode == 200;
}
