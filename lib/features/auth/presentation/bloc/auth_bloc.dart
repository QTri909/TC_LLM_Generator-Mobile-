import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:automation_generate_tc/core/network/token_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPassword);
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authEntity = await authRepository.loginWithEmailPassword(
        event.email,
        event.password,
      );

      // Save tokens
      await authRepository.saveTokens(
        authEntity.accessToken,
        authEntity.refreshToken,
      );
      TokenStorage.setToken(authEntity.accessToken);

      emit(AuthAuthenticated(authEntity: authEntity));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authEntity = await authRepository.loginWithGoogle();

      // Save tokens
      await authRepository.saveTokens(
        authEntity.accessToken,
        authEntity.refreshToken,
      );
      TokenStorage.setToken(authEntity.accessToken);

      emit(AuthAuthenticated(authEntity: authEntity));
    } catch (e) {
      // If the user dismissed the Google Sign In dialog, do not show an error
      if (e.toString().contains('canceled') ||
          e.toString().contains('sign_in_canceled') ||
          e.toString().contains('GoogleSignInExceptionCode.canceled')) {
        emit(AuthInitial());
        return;
      }
      emit(AuthError(message: e.toString()));
    }
  }
}
