import '../entities/test_case_entity.dart';
import '../repositories/project_repository.dart';

class CreateTestCaseUseCase {
  final ProjectRepository repository;

  CreateTestCaseUseCase(this.repository);

  Future<TestCaseEntity> call({
    required String title,
    required String type,
    String? preconditions,
    required List<String> steps,
    required String expectedResult,
    String? userStoryId,
    String? acceptanceCriteriaId,
  }) {
    return repository.createTestCase(
      title: title,
      type: type,
      preconditions: preconditions,
      steps: steps,
      expectedResult: expectedResult,
      userStoryId: userStoryId,
      acceptanceCriteriaId: acceptanceCriteriaId,
    );
  }
}
