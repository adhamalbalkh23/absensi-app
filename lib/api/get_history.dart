import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<List<dynamic>> getHistory(String token) async {
  final response = await http.get(
    Uri.parse(Endpoint.history),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  );

  print("STATUS HISTORY: ${response.statusCode}");
  print("BODY HISTORY: ${response.body}");

  final data = jsonDecode(response.body);

  return data['data'] ?? [];
}
