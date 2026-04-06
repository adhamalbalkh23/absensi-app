import 'dart:convert';
import 'dart:developer';

import 'package:absensi_apps/api/endpoint.dart';
import 'package:absensi_apps/models/login_model.dart';
import 'package:http/http.dart' as http;

Future<LoginModel?> loginUser({
  required String email,
  required String password,
}) async {
  print(Endpoint.login);
  final response = await http.post(
    Uri.parse(Endpoint.login),
    headers: {"Accept": "application/json"},
    body: {"email": email, "password": password},
  );

  log(response.body);

  if (response.statusCode == 200) {
    return LoginModel.fromJson(json.decode(response.body));
  } else {
    final error = LoginModel.fromJson(json.decode(response.body));
    log(error.toString());

    throw Exception(error.message);
  }
}
