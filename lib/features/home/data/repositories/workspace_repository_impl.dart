import '../../domain/entities/workspace_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_remote_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WorkspaceEntity>> getMyWorkspaces(String accessToken) async {
    return await remoteDataSource.getMyWorkspaces(accessToken);
  }

  @override
  Future<WorkspaceEntity> createWorkspace(
    String accessToken,
    String name,
    String? description,
  ) async {
    return await remoteDataSource.createWorkspace(
      accessToken,
      name,
      description,
    );
  }

  @override
  Future<WorkspaceEntity> createProject(
    String accessToken,
    String workspaceId,
    String name,
    String? description,
    List<Map<String, dynamic>>? businessRules,
  ) async {
    return await remoteDataSource.createProject(
      accessToken,
      workspaceId,
      name,
      description,
      businessRules,
    );
  }
}
