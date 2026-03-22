import '../../domain/entities/project_member_entity.dart';

class ProjectMemberModel extends ProjectMemberEntity {
  const ProjectMemberModel({
    required super.id,
    required super.projectId,
    required super.projectName,
    required super.userId,
    required super.fullName,
    required super.email,
    required super.role,
    required super.joinedAt,
  });

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) {
    return ProjectMemberModel(
      id: json['projectMemberId'] ?? '',
      projectId: json['projectId'] ?? '',
      projectName: json['projectName'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['userFullName'] ?? '',
      email: json['userEmail'] ?? '',
      role: json['role'] ?? '',
      joinedAt: json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectMemberId': id,
      'projectId': projectId,
      'projectName': projectName,
      'userId': userId,
      'userFullName': fullName,
      'userEmail': email,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
