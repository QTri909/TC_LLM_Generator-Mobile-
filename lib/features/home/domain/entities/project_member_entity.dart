class ProjectMemberEntity {
  final String id;
  final String userId;
  final String role;
  final DateTime joinedAt;

  const ProjectMemberEntity({
    required this.id,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });
}
