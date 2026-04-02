class ProfileModel {
  final String? message;
  final ProfileData? data;

  const ProfileModel({this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileModel();
    return ProfileModel(
      message: json['message'] as String?,
      data: ProfileData.fromJson(json['data'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson()};
}

class ProfileData {
  final int? id;
  final String? name;
  final String? email;
  final String? createdAt;

  const ProfileData({this.id, this.name, this.email, this.createdAt});

  factory ProfileData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileData();
    return ProfileData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'created_at': createdAt,
  };
}
