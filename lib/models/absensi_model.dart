class AbsensiModel {
  final String? message;
  final List<AbsensiData>? data;

  const AbsensiModel({this.message, this.data});

  factory AbsensiModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AbsensiModel();
    return AbsensiModel(
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => AbsensiData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class AbsensiData {
  final int? id;
  final String? tanggal;
  final String? checkIn;
  final String? checkOut;

  const AbsensiData({this.id, this.tanggal, this.checkIn, this.checkOut});

  factory AbsensiData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AbsensiData();
    return AbsensiData(
      id: (json['id'] as num?)?.toInt(),
      tanggal: json['tanggal'] as String?,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tanggal': tanggal,
    'check_in': checkIn,
    'check_out': checkOut,
  };
}
