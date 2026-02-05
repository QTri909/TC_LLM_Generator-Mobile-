import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({required this.client});

  Future<void> loginWithGoogle(String idToken) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/auth/login-google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      // Handle success - maybe return token/user
      // For now void as requested, but usually returns model
      print('Login Success: ${response.body}');
    } else {
      throw Exception('Failed to login with Google: ${response.body}');
    }
  }
}
