import 'project_entity.dart';

class WorkspaceEntity {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProjectEntity> projects;

  const WorkspaceEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.projects,
  });
}
