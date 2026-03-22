import '../entities/test_case_entity.dart';
import '../repositories/project_repository.dart';

class GetTestCasesUseCase {
  final ProjectRepository repository;

  GetTestCasesUseCase(this.repository);

  Future<List<TestCaseEntity>> call(String userStoryId) {
    return repository.getTestCases(userStoryId);
  }
}
