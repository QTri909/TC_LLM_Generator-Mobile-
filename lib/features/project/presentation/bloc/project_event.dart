import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class GetTestSuitesEvent extends ProjectEvent {
  final String projectId;
  const GetTestSuitesEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class CreateTestSuiteEvent extends ProjectEvent {
  final String projectId;
  final String name;
  final String? description;

  const CreateTestSuiteEvent({
    required this.projectId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [projectId, name, description];
}

class GetTestPlansEvent extends ProjectEvent {
  final String projectId;
  const GetTestPlansEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class CreateTestPlanEvent extends ProjectEvent {
  final String projectId;
  final String name;
  final String? description;
  final List<String> suiteIds;

  const CreateTestPlanEvent({
    required this.projectId,
    required this.name,
    this.description,
    required this.suiteIds,
  });

  @override
  List<Object?> get props => [projectId, name, description, suiteIds];
}
