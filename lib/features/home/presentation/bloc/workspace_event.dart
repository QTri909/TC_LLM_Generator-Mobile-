import 'package:equatable/equatable.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object> get props => [];
}

class GetWorkspacesEvent extends WorkspaceEvent {
  final String accessToken;
  final String? selectWorkspaceId;

  const GetWorkspacesEvent({required this.accessToken, this.selectWorkspaceId});

  @override
  List<Object> get props => [
    accessToken,
    if (selectWorkspaceId != null) selectWorkspaceId!,
  ];
}

class SelectWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;

  const SelectWorkspaceEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

class CreateWorkspaceEvent extends WorkspaceEvent {
  final String accessToken;
  final String name;
  final String? description;

  const CreateWorkspaceEvent({
    required this.accessToken,
    required this.name,
    this.description,
  });

  @override
  List<Object> get props => [
    accessToken,
    name,
    if (description != null) description!,
  ];
}

class CreateProjectEvent extends WorkspaceEvent {
  final String accessToken;
  final String workspaceId;
  final String name;
  final String? description;
  final List<Map<String, dynamic>>? businessRules;

  const CreateProjectEvent({
    required this.accessToken,
    required this.workspaceId,
    required this.name,
    this.description,
    this.businessRules,
  });

  @override
  List<Object> get props => [
    accessToken,
    workspaceId,
    name,
    if (description != null) description!,
  ];
}

