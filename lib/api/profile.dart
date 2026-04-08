import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<Map<String, dynamic>?> getProfile(String token) async {
  final response = await http.get(
    Uri.parse(Endpoint.profile),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  );

  print("STATUS PROFILE: ${response.statusCode}");
  print("BODY PROFILE: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'];
  } else {
    return null;
  }
}
