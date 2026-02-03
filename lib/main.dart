import 'package:flutter/material.dart';
import 'package:automation_generate_tc/features/auth/presentation/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA Artifacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7CEE)),
        useMaterial3: true,
        fontFamily: 'Inter', // Will fall back to default if not available
      ),
      home: const LoginPage(),
    );
  }
}
