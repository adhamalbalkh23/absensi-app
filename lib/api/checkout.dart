Future<bool> checkOut() async {
  final response = await http.post(Uri.parse(Endpoint.checkout));
  return response.statusCode == 200;
}
