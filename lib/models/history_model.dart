import 'dart:convert';

class HistoryModel {
  final String time;
  final String date;
  final String location;

  HistoryModel({
    required this.time,
    required this.date,
    required this.location,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'date': date,
      'location': location,
    };
  }

  // Convert from JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
    );
  }

  // Convert to string for storage
  String toJsonString() => jsonEncode(toJson());

  // Convert from string
  static HistoryModel fromJsonString(String jsonString) {
    return HistoryModel.fromJson(jsonDecode(jsonString));
  }
}
