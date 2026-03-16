import 'package:equatable/equatable.dart';
import '../../domain/entities/test_suite_entity.dart';
import '../../domain/entities/test_plan_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class TestSuitesLoaded extends ProjectState {
  final List<TestSuiteEntity> suites;
  const TestSuitesLoaded(this.suites);

  @override
  List<Object?> get props => [suites];
}

class TestPlansLoaded extends ProjectState {
  final List<TestPlanEntity> plans;
  const TestPlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class TestSuiteCreated extends ProjectState {
  final TestSuiteEntity suite;
  const TestSuiteCreated(this.suite);

  @override
  List<Object?> get props => [suite];
}

class TestPlanCreated extends ProjectState {
  final TestPlanEntity plan;
  const TestPlanCreated(this.plan);

  @override
  List<Object?> get props => [plan];
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
