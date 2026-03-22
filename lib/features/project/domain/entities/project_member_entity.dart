import 'package:equatable/equatable.dart';

class ProjectMemberEntity extends Equatable {
  final String id;
  final String projectId;
  final String projectName;
  final String userId;
  final String fullName;
  final String email;
  final String role;
  final DateTime joinedAt;

  const ProjectMemberEntity({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [id, projectId, projectName, userId, fullName, email, role, joinedAt];
}
