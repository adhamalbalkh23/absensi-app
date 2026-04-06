import 'package:absensi_apps/api/endpoint.dart';
import 'package:http/http.dart' as http;

Future<bool> checkOut() async {
  final response = await http.post(Uri.parse(Endpoint.checkout));
  return response.statusCode == 200;
}
