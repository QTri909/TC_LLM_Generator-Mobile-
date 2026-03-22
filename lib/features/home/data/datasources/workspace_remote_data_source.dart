import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/api_response.dart';
import '../models/workspace_model.dart';
import '../models/project_model.dart';

class WorkspaceRemoteDataSource {
  final http.Client client;

  WorkspaceRemoteDataSource({required this.client});

  Future<List<WorkspaceModel>> getMyWorkspaces(String accessToken) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => WorkspaceModel.fromJson(e)).toList(),
      );

      if (apiResponse.success && apiResponse.data != null) {
        final List<WorkspaceModel> workspaces = apiResponse.data!;

        // Fetch projects for each workspace to populate the entity
        // Note: In a production app, you might want to fetch projects on-demand
        for (int i = 0; i < workspaces.length; i++) {
          final projects = await _getProjectsForWorkspace(
            baseUrl,
            accessToken,
            workspaces[i].id,
          );
          workspaces[i] = _cloneWorkspaceWithProjects(workspaces[i], projects);
        }

        return workspaces;
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception(
        'Failed to load workspaces: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<ProjectModel>> _getProjectsForWorkspace(
    String baseUrl,
    String accessToken,
    String workspaceId,
  ) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/projects/workspace/$workspaceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => ProjectModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    }
    return [];
  }

  WorkspaceModel _cloneWorkspaceWithProjects(
    WorkspaceModel workspace,
    List<ProjectModel> projects,
  ) {
    return WorkspaceModel(
      id: workspace.id,
      ownerId: workspace.ownerId,
      name: workspace.name,
      description: workspace.description,
      createdAt: workspace.createdAt,
      updatedAt: workspace.updatedAt,
      projects: projects,
    );
  }

  Future<WorkspaceModel> createWorkspace(
    String accessToken,
    String name,
    String? description,
  ) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
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
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => WorkspaceModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
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
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';

    // In the real backend, project creation is at /api/v1/projects
    // and requires projectKey too. Let's try to derive one or add it to request.
    final String projectKey = name
        .split(' ')
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join('');

    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'workspaceId': workspaceId,
        'name': name,
        'projectKey': projectKey.isEmpty ? 'PROJ' : projectKey,
        if (description != null) 'description': description,
        // Backend Project entity might not have businessRules yet,
        // or it's handled differently. Check ProjectController again if needed.
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => ProjectModel.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        // We return a workspace model with projects re-fetched for simplicity in bloc
        return await getWorkspaceDetails(accessToken, workspaceId);
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception(
        'Failed to create project: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<WorkspaceModel> getWorkspaceDetails(
    String accessToken,
    String workspaceId,
  ) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/workspaces/$workspaceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => WorkspaceModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        final workspace = apiResponse.data!;
        final projects = await _getProjectsForWorkspace(
          baseUrl,
          accessToken,
          workspaceId,
        );
        return _cloneWorkspaceWithProjects(workspace, projects);
      }
    }
    throw Exception('Failed to get workspace details');
  }
}
