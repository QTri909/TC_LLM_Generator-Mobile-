import '../entities/test_suite_entity.dart';
import '../repositories/project_repository.dart';

class CreateTestSuite {
  final ProjectRepository repository;

  CreateTestSuite(this.repository);

  Future<TestSuiteEntity> call({
    required String projectId,
    required String name,
    String? description,
  }) async {
    return await repository.createTestSuite(
      projectId: projectId,
      name: name,
      description: description,
    );
  }
}
