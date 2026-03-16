import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String role;
  final String action;
  final String reason;
  final String priority;
  final int points;
  final List<String> acceptanceCriteria;

  const StoryEntity({
    required this.id,
    required this.projectId,
    required this.title,
    required this.role,
    required this.action,
    required this.reason,
    required this.priority,
    required this.points,
    required this.acceptanceCriteria,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        role,
        action,
        reason,
        priority,
        points,
        acceptanceCriteria,
      ];
}
