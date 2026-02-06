import '../../domain/entities/workspace_entity.dart';
import 'project_model.dart';

class WorkspaceModel extends WorkspaceEntity {
  const WorkspaceModel({
    required super.id,
    required super.ownerId,
    required super.name,
    super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.projects,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? 'Unnamed Workspace',
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      projects: json['projects'] != null
          ? (json['projects'] as List)
                .map((e) => ProjectModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
