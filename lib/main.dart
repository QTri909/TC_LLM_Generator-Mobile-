import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:automation_generate_tc/features/auth/presentation/screens/login_page.dart';
import 'package:automation_generate_tc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:automation_generate_tc/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:automation_generate_tc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:automation_generate_tc/features/auth/domain/repositories/auth_repository.dart';
import 'package:automation_generate_tc/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing dependencies
    final client = http.Client();
    final secureStorage = const FlutterSecureStorage();
    final authRemoteDataSource = AuthRemoteDataSource(client: client);
    final authLocalDataSource = AuthLocalDataSource(
      secureStorage: secureStorage,
    );
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    return RepositoryProvider<AuthRepository>.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository),
        child: MaterialApp(
          title: 'QA Artifacts',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2B7CEE),
            ),
            useMaterial3: true,
            fontFamily: 'Inter',
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
