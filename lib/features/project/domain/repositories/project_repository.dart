import '../entities/story_entity.dart';
import '../entities/test_suite_entity.dart';
import '../entities/test_plan_entity.dart';
import '../entities/test_case_entity.dart';
import '../entities/notification_entity.dart';
import '../entities/project_member_entity.dart';

abstract class ProjectRepository {
  Future<List<StoryEntity>> getStories(String projectId);

  Future<StoryEntity> createStory({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required List<String> acceptanceCriteria,
  });

  Future<List<TestCaseEntity>> getTestCases(String userStoryId);
  Future<TestCaseEntity> createTestCase({
    required String title,
    required String type,
    String? preconditions,
    required List<String> steps,
    required String expectedResult,
    String? userStoryId,
    String? acceptanceCriteriaId,
  });

  Future<void> generateTestCases(String userStoryId);

  Future<List<TestSuiteEntity>> getTestSuites(String projectId);
  Future<TestSuiteEntity> createTestSuite({
    required String projectId,
    required String name,
    String? description,
  });

  Future<List<TestPlanEntity>> getTestPlans(String projectId);
  Future<TestPlanEntity> createTestPlan({
    required String projectId,
    required String name,
    String? description,
    required List<String> suiteIds,
  });

  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadNotificationCount();
  Future<void> markNotificationAsRead(String notificationId);

  Future<List<ProjectMemberEntity>> getProjectMembers(String projectId);
  Future<ProjectMemberEntity> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
  });
}
