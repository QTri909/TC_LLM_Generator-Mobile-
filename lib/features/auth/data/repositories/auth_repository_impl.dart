import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthEntity> loginWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        return await remoteDataSource.loginWithGoogle(idToken);
      } else {
        throw Exception('Failed to get ID Token from Google');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await localDataSource.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
