import '../../domain/entities/project_entity.dart';
import 'project_member_model.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.workspaceId,
    required super.createdByUserId,
    required super.projectKey,
    required super.name,
    super.description,
    super.jiraSiteId,
    super.jiraProjectKey,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.members,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['projectId'] ?? '',
      workspaceId: json['workspaceId'] ?? '',
      createdByUserId: json['createdByUserId'] ?? '',
      projectKey: json['projectKey'] ?? '',
      name: json['name'] ?? 'Unnamed Project',
      description: json['description'],
      jiraSiteId: json['jiraSiteId'],
      jiraProjectKey: json['jiraProjectKey'],
      status: json['status'] ?? 'UNKNOWN',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (DateTime.now()),
      members: json['members'] != null
          ? (json['members'] as List)
                .map((e) => ProjectMemberModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
