import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';

Future<bool> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse(Endpoint.login),
    body: {"email": email, "password": password},
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
