import 'package:flutter_bloc/flutter_bloc.dart';
import 'project_event.dart';
import 'project_state.dart';
import '../../domain/usecases/get_test_suites.dart';
import '../../domain/usecases/create_test_suite.dart';
import '../../domain/usecases/get_test_plans.dart';
import '../../domain/usecases/create_test_plan.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetTestSuites getTestSuites;
  final CreateTestSuite createTestSuite;
  final GetTestPlans getTestPlans;
  final CreateTestPlan createTestPlan;

  ProjectBloc({
    required this.getTestSuites,
    required this.createTestSuite,
    required this.getTestPlans,
    required this.createTestPlan,
  }) : super(ProjectInitial()) {
    on<GetTestSuitesEvent>((event, emit) async {
      emit(ProjectLoading());
      try {
        final suites = await getTestSuites(event.projectId);
        emit(TestSuitesLoaded(suites));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<CreateTestSuiteEvent>((event, emit) async {
      emit(ProjectLoading());
      try {
        final suite = await createTestSuite(
          projectId: event.projectId,
          name: event.name,
          description: event.description,
        );
        emit(TestSuiteCreated(suite));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<GetTestPlansEvent>((event, emit) async {
      emit(ProjectLoading());
      try {
        final plans = await getTestPlans(event.projectId);
        emit(TestPlansLoaded(plans));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<CreateTestPlanEvent>((event, emit) async {
      emit(ProjectLoading());
      try {
        final plan = await createTestPlan(
          projectId: event.projectId,
          name: event.name,
          description: event.description,
          suiteIds: event.suiteIds,
        );
        emit(TestPlanCreated(plan));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });
  }
}
