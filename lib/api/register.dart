import 'dart:convert';
import 'dart:developer';

import 'package:absensi_apps/api/endpoint.dart';
import 'package:absensi_apps/models/register_model.dart';
import 'package:http/http.dart' as http;

Future<RegisterModel?> registerUser({
  required String name,
  required String email,
  required String password,
  required String confirmPassword,
  required String batchId,
  required String trainingId,
  required String jenisKelamin,
}) async {
  final response = await http.post(
    Uri.parse(Endpoint.register),
    headers: {"Accept": "application/json"},
    body: {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "batch_id": batchId,
      "training_id": trainingId,
      "jenis_kelamin": jenisKelamin,
    },
  );

  log("STATUS: ${response.statusCode}");
  log("BODY: ${response.body}");

  final data = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return RegisterModel.fromJson(data);
  } else {
    final error = RegisterModel.fromJson(data);
    log(error.toString());
    throw Exception(error.message ?? "Register gagal");
  }
}
