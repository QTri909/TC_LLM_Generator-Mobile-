import '../repositories/project_repository.dart';

class GenerateTestCasesUseCase {
  final ProjectRepository repository;

  GenerateTestCasesUseCase(this.repository);

  Future<void> call(String userStoryId) {
    return repository.generateTestCases(userStoryId);
  }
}
