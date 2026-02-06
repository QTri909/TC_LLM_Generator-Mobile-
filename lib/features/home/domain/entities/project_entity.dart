import 'project_member_entity.dart';

class ProjectEntity {
  final String id;
  final String workspaceId;
  final String createdByUserId;
  final String projectKey;
  final String name;
  final String? description;
  final String? jiraSiteId;
  final String? jiraProjectKey;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProjectMemberEntity> members;

  const ProjectEntity({
    required this.id,
    required this.workspaceId,
    required this.createdByUserId,
    required this.projectKey,
    required this.name,
    this.description,
    this.jiraSiteId,
    this.jiraProjectKey,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
  });
}
