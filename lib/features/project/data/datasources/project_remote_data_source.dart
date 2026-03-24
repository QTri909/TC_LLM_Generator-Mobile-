import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/api_response.dart';
import '../models/story_model.dart';
import '../models/test_suite_model.dart';
import '../models/test_plan_model.dart';
import '../models/test_case_model.dart';
import '../models/notification_model.dart';
import '../models/project_member_model.dart';
import 'package:automation_generate_tc/core/network/token_storage.dart';

class ProjectRemoteDataSource {
  final http.Client client;

  ProjectRemoteDataSource({required this.client});

  Future<List<StoryModel>> getStories(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/user-stories/project/$projectId'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => StoryModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Failed to get stories: ${response.statusCode}');
    }
  }

  Future<StoryModel> createStory({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required List<String> acceptanceCriteria,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/user-stories'),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({
        'projectId': projectId,
        'title': title,
        'asA': role,
        'iWantTo': action,
        'soThat': reason,
        'status': 'DRAFT',
        'acceptanceCriteria': List.generate(
          acceptanceCriteria.length,
          (index) => {
            'content': acceptanceCriteria[index],
            'orderNo': index + 1,
          },
        ),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => StoryModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception(
        'Failed to create story: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<TestCaseModel>> getTestCases(String userStoryId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/test-cases/user-story/$userStoryId'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => TestCaseModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Failed to get test cases: ${response.statusCode}');
    }
  }

  Future<TestCaseModel> createTestCase({
    required String title,
    required String type,
    String? preconditions,
    required List<String> steps,
    required String expectedResult,
    String? userStoryId,
    String? acceptanceCriteriaId,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';

    // Convert steps to the format expected by the backend
    final stepDetails = steps
        .asMap()
        .entries
        .map(
          (entry) => {
            'stepNumber': entry.key + 1,
            'description': entry.value,
            'action': entry.value,
          },
        )
        .toList();

    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/test-cases'),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({
        if (userStoryId != null) 'userStoryId': userStoryId,
        if (acceptanceCriteriaId != null)
          'acceptanceCriteriaId': acceptanceCriteriaId,
        'title': title,
        'type': type,
        'preconditions': preconditions ?? '',
        'stepDetails': stepDetails,
        'expectedResult': expectedResult,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => TestCaseModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception(
        'Failed to create test case: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> generateTestCases(String userStoryId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse(
        '$baseUrl/api/v1/user-stories/$userStoryId/generate-test-cases',
      ),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate test cases: ${response.body}');
    }
  }

  Future<List<TestSuiteModel>> getTestSuites(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/test-suites/project/$projectId'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => TestSuiteModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Failed to get suites: ${response.statusCode}');
    }
  }

  Future<TestSuiteModel> createTestSuite({
    required String projectId,
    required String name,
    String? description,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/test-suites'),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({
        'projectId': projectId,
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => TestSuiteModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception('Failed to create suite: ${response.body}');
    }
  }

  Future<List<TestPlanModel>> getTestPlans(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/test-plans/project/$projectId'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => TestPlanModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
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
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/test-plans'),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({
        'projectId': projectId,
        'name': name,
        'description': description,
        'testSuiteIds': suiteIds,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => TestPlanModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception('Failed to create plan: ${response.body}');
    }
  }
  Future<List<NotificationModel>> getNotifications() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/notifications'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => NotificationModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Failed to get notifications: ${response.statusCode}');
    }
  }

  Future<int> getUnreadNotificationCount() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/notifications/unread-count'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['data']['unreadCount'] as int;
      }
      return 0;
    } else {
      throw Exception('Failed to get unread count: ${response.statusCode}');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.patch(
      Uri.parse('$baseUrl/api/v1/notifications/$notificationId/read'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark as read: ${response.body}');
    }
  }

  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/project-members/project/$projectId'),
      headers: TokenStorage.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromPagedJson(
        jsonResponse,
        (list) => list.map((e) => ProjectMemberModel.fromJson(e)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Failed to get project members: ${response.statusCode}');
    }
  }

  Future<ProjectMemberModel> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/project-members'),
      headers: TokenStorage.authHeaders,
      body: jsonEncode({
        'projectId': projectId,
        'userId': userId,
        'role': role,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(
        jsonResponse,
        (data) => ProjectMemberModel.fromJson(data),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception('Failed to add member: ${response.body}');
    }
  }
}
