import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> loginWithGoogle();
}
