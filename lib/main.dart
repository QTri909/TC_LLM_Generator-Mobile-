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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitializerApp());
}

class InitializerApp extends StatefulWidget {
  const InitializerApp({super.key});

  @override
  State<InitializerApp> createState() => _InitializerAppState();
}

class _InitializerAppState extends State<InitializerApp> {
  AuthRepository? _authRepository;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _initDependencies();
  }

  Future<void> _initDependencies() async {
    try {
      await dotenv.load(fileName: ".env");

      // 1. KHỞI TẠO DEPENDENCIES Ở ĐÂY
      final client = http.Client();
      const secureStorage = FlutterSecureStorage();
      final authRemoteDataSource = AuthRemoteDataSource(client: client);
      final authLocalDataSource = AuthLocalDataSource(
        secureStorage: secureStorage,
      );
      final authRepository = AuthRepositoryImpl(
        remoteDataSource: authRemoteDataSource,
        localDataSource: authLocalDataSource,
      );

      // Trigger rebuild với Repository đã khởi tạo
      setState(() {
        _authRepository = authRepository;
      });
    } catch (e, stacktrace) {
      debugPrint("App initialization error: $e");
      debugPrint("$stacktrace");
      setState(() {
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: Text("Error: $_error"))),
      );
    }

    if (_authRepository == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // 2. Truyền Repository đã khởi tạo vào MyApp
    return MyApp(authRepository: _authRepository!);
  }
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  // 3. Nhận Repository qua constructor
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    // Hàm build giờ đây đã rất nhẹ nhàng, chỉ làm nhiệm vụ vẽ UI
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
