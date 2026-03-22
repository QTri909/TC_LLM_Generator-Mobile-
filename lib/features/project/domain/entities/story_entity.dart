import 'package:equatable/equatable.dart';
import 'acceptance_criteria_entity.dart';

class StoryEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String role;
  final String action;
  final String reason;
  final String status;
  final List<AcceptanceCriteriaEntity> acceptanceCriteria;
  final DateTime? createdAt;

  const StoryEntity({
    required this.id,
    required this.projectId,
    required this.title,
    required this.role,
    required this.action,
    required this.reason,
    required this.status,
    required this.acceptanceCriteria,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        role,
        action,
        reason,
        status,
        acceptanceCriteria,
        createdAt,
      ];
}
