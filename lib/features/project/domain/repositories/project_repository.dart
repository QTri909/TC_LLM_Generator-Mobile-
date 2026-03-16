import '../entities/story_entity.dart';
import '../entities/test_suite_entity.dart';
import '../entities/test_plan_entity.dart';

abstract class ProjectRepository {
  Future<List<StoryEntity>> getStories(String projectId);

  Future<StoryEntity> createStory({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required String priority,
    required int points,
    required List<String> acceptanceCriteria,
  });

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
}
