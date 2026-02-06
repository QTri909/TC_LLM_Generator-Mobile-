import 'package:equatable/equatable.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object> get props => [];
}

class GetWorkspacesEvent extends WorkspaceEvent {
  final String accessToken;

  const GetWorkspacesEvent({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}

class SelectWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;

  const SelectWorkspaceEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}
