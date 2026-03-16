import '../entities/test_plan_entity.dart';
import '../repositories/project_repository.dart';

class CreateTestPlan {
  final ProjectRepository repository;

  CreateTestPlan(this.repository);

  Future<TestPlanEntity> call({
    required String projectId,
    required String name,
    String? description,
    required List<String> suiteIds,
  }) async {
    return await repository.createTestPlan(
      projectId: projectId,
      name: name,
      description: description,
      suiteIds: suiteIds,
    );
  }
}
