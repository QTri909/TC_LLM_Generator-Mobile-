import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/story_model.dart';
import '../models/test_suite_model.dart';
import '../models/test_plan_model.dart';

class ProjectRemoteDataSource {
  final http.Client client;

  ProjectRemoteDataSource({required this.client});

  Future<List<StoryModel>> getStories(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/stories'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => StoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get stories: ${response.statusCode} - ${response.body}');
    }
  }

  Future<StoryModel> createStory({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required String priority,
    required int points,
    required List<String> acceptanceCriteria,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/stories'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'role': role,
        'action': action,
        'reason': reason,
        'priority': priority,
        'points': points,
        'acceptanceCriteria': acceptanceCriteria,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return StoryModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create story: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<TestSuiteModel>> getTestSuites(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/test-suites'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => TestSuiteModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get suites: ${response.statusCode}');
    }
  }

  Future<TestSuiteModel> createTestSuite({
    required String projectId,
    required String name,
    String? description,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/test-suites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return TestSuiteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create suite: ${response.body}');
    }
  }

  Future<List<TestPlanModel>> getTestPlans(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/test-plans'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => TestPlanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get plans: ${response.statusCode}');
    }
  }

  Future<TestPlanModel> createTestPlan({
    required String projectId,
    required String name,
    String? description,
    required List<String> suiteIds,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/projects/$projectId/test-plans'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'suites': suiteIds,
      }),
    );

    if (response.statusCode == 201) {
      return TestPlanModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create plan: ${response.body}');
    }
  }
}
