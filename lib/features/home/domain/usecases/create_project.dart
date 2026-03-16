import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class CreateProject {
  final WorkspaceRepository repository;

  CreateProject(this.repository);

  Future<WorkspaceEntity> call(
    String accessToken,
    String workspaceId,
    String name,
    String? description,
    List<Map<String, dynamic>>? businessRules,
  ) async {
    return await repository.createProject(
      accessToken,
      workspaceId,
      name,
      description,
      businessRules,
    );
  }
}
