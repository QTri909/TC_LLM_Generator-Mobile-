import '../../domain/entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getMyWorkspaces(String accessToken);
  Future<WorkspaceEntity> createWorkspace(
    String accessToken,
    String name,
    String? description,
  );

  Future<WorkspaceEntity> createProject(
    String accessToken,
    String workspaceId,
    String name,
    String? description,
    List<Map<String, dynamic>>? businessRules,
  );
}
