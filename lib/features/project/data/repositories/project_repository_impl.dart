import '../../domain/entities/story_entity.dart';
import '../../domain/entities/test_suite_entity.dart';
import '../../domain/entities/test_plan_entity.dart';
import '../../domain/entities/test_case_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<StoryEntity>> getStories(String projectId) async {
    return await remoteDataSource.getStories(projectId);
  }

  @override
  Future<StoryEntity> createStory({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required List<String> acceptanceCriteria,
  }) async {
    return await remoteDataSource.createStory(
      projectId: projectId,
      title: title,
      role: role,
      action: action,
      reason: reason,
      acceptanceCriteria: acceptanceCriteria,
    );
  }

  @override
  Future<List<TestCaseEntity>> getTestCases(String userStoryId) async {
    return await remoteDataSource.getTestCases(userStoryId);
  }

  @override
  Future<TestCaseEntity> createTestCase({
    required String title,
    required String type,
    String? preconditions,
    required List<String> steps,
    required String expectedResult,
    String? userStoryId,
    String? acceptanceCriteriaId,
  }) async {
    return await remoteDataSource.createTestCase(
      title: title,
      type: type,
      preconditions: preconditions,
      steps: steps,
      expectedResult: expectedResult,
      userStoryId: userStoryId,
      acceptanceCriteriaId: acceptanceCriteriaId,
    );
  }

  @override
  Future<void> generateTestCases(String userStoryId) async {
    await remoteDataSource.generateTestCases(userStoryId);
  }

  @override
  Future<List<TestSuiteEntity>> getTestSuites(String projectId) async {
    return await remoteDataSource.getTestSuites(projectId);
  }

  @override
  Future<TestSuiteEntity> createTestSuite({
    required String projectId,
    required String name,
    String? description,
  }) async {
    return await remoteDataSource.createTestSuite(
      projectId: projectId,
      name: name,
      description: description,
    );
  }

  @override
  Future<List<TestPlanEntity>> getTestPlans(String projectId) async {
    return await remoteDataSource.getTestPlans(projectId);
  }

  @override
  Future<TestPlanEntity> createTestPlan({
    required String projectId,
    required String name,
    String? description,
    required List<String> suiteIds,
  }) async {
    return await remoteDataSource.createTestPlan(
      projectId: projectId,
      name: name,
      description: description,
      suiteIds: suiteIds,
    );
  }
  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    return await remoteDataSource.getUnreadNotificationCount();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    return await remoteDataSource.markNotificationAsRead(notificationId);
  }

  @override
  Future<List<ProjectMemberEntity>> getProjectMembers(String projectId) async {
    return await remoteDataSource.getProjectMembers(projectId);
  }

  @override
  Future<ProjectMemberEntity> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
  }) async {
    return await remoteDataSource.addProjectMember(
      projectId: projectId,
      userId: userId,
      role: role,
    );
  }
}
