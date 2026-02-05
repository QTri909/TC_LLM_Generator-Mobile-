import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> loginWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        await remoteDataSource.loginWithGoogle(idToken);
      } else {
        throw Exception('Failed to get ID Token from Google');
      }
    } catch (e) {
      rethrow;
    }
  }
}
