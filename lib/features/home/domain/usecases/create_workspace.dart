import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspace {
  final WorkspaceRepository repository;

  CreateWorkspace(this.repository);

  Future<WorkspaceEntity> call(
    String accessToken,
    String name,
    String? description,
  ) async {
    return await repository.createWorkspace(accessToken, name, description);
  }
}
