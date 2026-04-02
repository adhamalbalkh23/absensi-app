class LoginModel {
  final String? message;
  final LoginData? data;

  const LoginModel({this.message, this.data});

  factory LoginModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginModel();
    return LoginModel(
      message: json['message'] as String?,
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson()};
}

class LoginData {
  final String? token;
  final LoginUser? user;

  const LoginData({this.token, this.user});

  factory LoginData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginData();
    return LoginData(
      token: json['token'] as String?,
      user: LoginUser.fromJson(json['user'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'user': user?.toJson()};
}

class LoginUser {
  final int? id;
  final String? name;
  final String? email;

  const LoginUser({this.id, this.name, this.email});

  factory LoginUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginUser();
    return LoginUser(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
