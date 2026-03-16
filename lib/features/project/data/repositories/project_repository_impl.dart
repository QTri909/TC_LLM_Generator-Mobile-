import '../../domain/entities/story_entity.dart';
import '../../domain/entities/test_suite_entity.dart';
import '../../domain/entities/test_plan_entity.dart';
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
    required String priority,
    required int points,
    required List<String> acceptanceCriteria,
  }) async {
    return await remoteDataSource.createStory(
      projectId: projectId,
      title: title,
      role: role,
      action: action,
      reason: reason,
      priority: priority,
      points: points,
      acceptanceCriteria: acceptanceCriteria,
    );
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
}
