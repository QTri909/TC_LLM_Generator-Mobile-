import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSource({required this.secureStorage});

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: 'accessToken', value: accessToken);
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refreshToken');
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
  }
}
