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
