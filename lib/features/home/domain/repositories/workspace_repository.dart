import '../../domain/entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getMyWorkspaces(String accessToken);
}
