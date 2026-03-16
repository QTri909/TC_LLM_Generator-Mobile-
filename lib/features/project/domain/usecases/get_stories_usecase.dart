import '../entities/story_entity.dart';
import '../repositories/project_repository.dart';

class GetStoriesUseCase {
  final ProjectRepository repository;

  GetStoriesUseCase(this.repository);

  Future<List<StoryEntity>> call(String projectId) async {
    return repository.getStories(projectId);
  }
}
