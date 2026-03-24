import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/generate_test_cases_usecase.dart';
import '../../domain/usecases/get_test_cases_usecase.dart';
import '../../domain/usecases/create_test_case_usecase.dart';
import 'test_case_event.dart';
import 'test_case_state.dart';

class TestCaseBloc extends Bloc<TestCaseEvent, TestCaseState> {
  final GetTestCasesUseCase getTestCasesUseCase;
  final CreateTestCaseUseCase createTestCaseUseCase;
  final GenerateTestCasesUseCase generateTestCasesUseCase;

  TestCaseBloc({
    required this.getTestCasesUseCase,
    required this.createTestCaseUseCase,
    required this.generateTestCasesUseCase,
  }) : super(TestCasesInitial()) {
    on<GetTestCasesEvent>(_onGetTestCases);
    on<CreateTestCaseEvent>(_onCreateTestCase);
    on<GenerateTestCasesEvent>(_onGenerateTestCases);
  }

  Future<void> _onGenerateTestCases(
    GenerateTestCasesEvent event,
    Emitter<TestCaseState> emit,
  ) async {
    emit(TestCasesGenerating());
    try {
      await generateTestCasesUseCase(event.userStoryId);
      emit(TestCasesGenerateSuccess());
      // Re-fetch test cases after successful generation
      add(GetTestCasesEvent(userStoryId: event.userStoryId));
    } catch (e) {
      emit(TestCasesGenerateError(message: e.toString()));
    }
  }

  Future<void> _onGetTestCases(
    GetTestCasesEvent event,
    Emitter<TestCaseState> emit,
  ) async {
    emit(TestCasesLoading());
    try {
      final testCases = await getTestCasesUseCase(event.userStoryId);
      emit(TestCasesLoaded(testCases: testCases));
    } catch (e) {
      emit(TestCasesError(message: e.toString()));
    }
  }

  Future<void> _onCreateTestCase(
    CreateTestCaseEvent event,
    Emitter<TestCaseState> emit,
  ) async {
    emit(TestCaseCreateLoading());
    try {
      final testCase = await createTestCaseUseCase(
        title: event.title,
        type: event.type,
        preconditions: event.preconditions,
        steps: event.steps,
        expectedResult: event.expectedResult,
        userStoryId: event.userStoryId,
        acceptanceCriteriaId: event.acceptanceCriteriaId,
      );
      emit(TestCaseCreateSuccess(testCase: testCase));
    } catch (e) {
      emit(TestCaseCreateError(message: e.toString()));
    }
  }
}
