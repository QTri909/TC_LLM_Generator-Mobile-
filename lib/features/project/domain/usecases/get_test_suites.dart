import '../entities/test_suite_entity.dart';
import '../repositories/project_repository.dart';

class GetTestSuites {
  final ProjectRepository repository;

  GetTestSuites(this.repository);

  Future<List<TestSuiteEntity>> call(String projectId) async {
    return await repository.getTestSuites(projectId);
  }
}
