import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/workspace_model.dart';

class WorkspaceRemoteDataSource {
  final http.Client client;

  WorkspaceRemoteDataSource({required this.client});

  Future<List<WorkspaceModel>> getMyWorkspaces(String accessToken) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/workspaces/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => WorkspaceModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to load workspaces: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
