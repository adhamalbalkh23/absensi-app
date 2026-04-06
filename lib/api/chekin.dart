import 'package:absensi_apps/api/endpoint.dart';
import 'package:http/http.dart' as http;

Future<bool> checkIn() async {
  final response = await http.post(Uri.parse(Endpoint.checkin));
  return response.statusCode == 200;
}
