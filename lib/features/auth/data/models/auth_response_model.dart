import '../../domain/entities/auth_entity.dart';

class AuthResponseModel extends AuthEntity {
  AuthResponseModel({required super.accessToken, required super.refreshToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
