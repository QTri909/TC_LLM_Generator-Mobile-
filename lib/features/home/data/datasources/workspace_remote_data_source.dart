import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/workspace_model.dart';

class WorkspaceRemoteDataSource {
  final http.Client client;

  WorkspaceRemoteDataSource({required this.client});

  Future<List<WorkspaceModel>> getMyWorkspaces(String accessToken) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
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

  Future<WorkspaceModel> createWorkspace(
    String accessToken,
    String name,
    String? description,
  ) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'name': name,
        if (description != null) 'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return WorkspaceModel.fromJson(jsonResponse);
    } else {
      throw Exception(
        'Failed to create workspace: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<WorkspaceModel> createProject(
    String accessToken,
    String workspaceId,
    String name,
    String? description,
    List<Map<String, dynamic>>? businessRules,
  ) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/workspaces/$workspaceId/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'name': name,
        if (description != null) 'description': description,
        if (businessRules != null) 'businessRules': businessRules,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return WorkspaceModel.fromJson(jsonResponse);
    } else {
      throw Exception(
        'Failed to create project: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

