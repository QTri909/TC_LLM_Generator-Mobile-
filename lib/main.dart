import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:automation_generate_tc/features/auth/presentation/screens/login_page.dart';
import 'package:automation_generate_tc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:automation_generate_tc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:automation_generate_tc/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSource(client: http.Client()),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'QA Artifacts',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7CEE)),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const LoginPage(),
      ),
    );
  }
}
