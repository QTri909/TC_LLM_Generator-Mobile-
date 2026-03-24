import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> loginWithGoogle();
  Future<AuthEntity> loginWithEmailPassword(String email, String password);
  Future<void> saveTokens(String accessToken, String refreshToken);
}
