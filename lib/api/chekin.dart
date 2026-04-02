Future<bool> checkIn() async {
  final response = await http.post(Uri.parse(Endpoint.checkin));
  return response.statusCode == 200;
}
