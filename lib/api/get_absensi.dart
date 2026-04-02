import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/absensi_model.dart';
import 'endpoint.dart';

Future<List<AbsensiModel>> getAbsensi() async {
  final response = await http.get(Uri.parse(Endpoint.getAbsensi));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List list = data['data'];

    return list.map((e) => AbsensiModel.fromJson(e)).toList();
  } else {
    throw Exception("Gagal");
  }
}
