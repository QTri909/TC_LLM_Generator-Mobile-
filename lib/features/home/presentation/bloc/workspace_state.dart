import 'package:equatable/equatable.dart';
import '../../domain/entities/workspace_entity.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<WorkspaceEntity> workspaces;
  final WorkspaceEntity? selectedWorkspace;

  const WorkspaceLoaded({required this.workspaces, this.selectedWorkspace});

  @override
  List<Object> get props => [
    workspaces,
    if (selectedWorkspace != null) selectedWorkspace!,
  ];
}

class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError({required this.message});

  @override
  List<Object> get props => [message];
}

class WorkspaceCreateLoading extends WorkspaceState {}

class WorkspaceCreateSuccess extends WorkspaceState {
  final WorkspaceEntity workspace;

  const WorkspaceCreateSuccess({required this.workspace});

  @override
  List<Object> get props => [workspace];
}

class WorkspaceCreateError extends WorkspaceState {
  final String message;

  const WorkspaceCreateError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProjectCreateLoading extends WorkspaceState {}

class ProjectCreateSuccess extends WorkspaceState {
  final WorkspaceEntity workspace;

  const ProjectCreateSuccess({required this.workspace});

  @override
  List<Object> get props => [workspace];
}

class ProjectCreateError extends WorkspaceState {
  final String message;

  const ProjectCreateError({required this.message});

  @override
  List<Object> get props => [message];
}

