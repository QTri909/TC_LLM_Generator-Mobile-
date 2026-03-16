import '../entities/story_entity.dart';
import '../repositories/project_repository.dart';

class CreateStoryUseCase {
  final ProjectRepository repository;

  CreateStoryUseCase(this.repository);

  Future<StoryEntity> call({
    required String projectId,
    required String title,
    required String role,
    required String action,
    required String reason,
    required String priority,
    required int points,
    required List<String> acceptanceCriteria,
  }) async {
    return repository.createStory(
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
}
