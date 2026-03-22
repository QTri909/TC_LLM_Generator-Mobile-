import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetStoriesEvent extends StoryEvent {
  final String projectId;

  GetStoriesEvent({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class CreateStoryEvent extends StoryEvent {
  final String projectId;
  final String title;
  final String role;
  final String action;
  final String reason;
  final List<String> acceptanceCriteria;

  CreateStoryEvent({
    required this.projectId,
    required this.title,
    required this.role,
    required this.action,
    required this.reason,
    required this.acceptanceCriteria,
  });

  @override
  List<Object?> get props => [
    projectId,
    title,
    role,
    action,
    reason,
    acceptanceCriteria,
  ];
}
