import 'package:equatable/equatable.dart';
import '../../domain/entities/test_case_entity.dart';

abstract class TestCaseState extends Equatable {
  const TestCaseState();

  @override
  List<Object?> get props => [];
}

class TestCasesInitial extends TestCaseState {}

class TestCasesLoading extends TestCaseState {}

class TestCasesLoaded extends TestCaseState {
  final List<TestCaseEntity> testCases;

  const TestCasesLoaded({required this.testCases});

  @override
  List<Object?> get props => [testCases];
}

class TestCasesError extends TestCaseState {
  final String message;

  const TestCasesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TestCaseCreateLoading extends TestCaseState {}

class TestCaseCreateSuccess extends TestCaseState {
  final TestCaseEntity testCase;

  const TestCaseCreateSuccess({required this.testCase});

  @override
  List<Object?> get props => [testCase];
}

class TestCaseCreateError extends TestCaseState {
  final String message;

  const TestCaseCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TestCasesGenerating extends TestCaseState {}

class TestCasesGenerateSuccess extends TestCaseState {}

class TestCasesGenerateError extends TestCaseState {
  final String message;

  const TestCasesGenerateError({required this.message});

  @override
  List<Object?> get props => [message];
}
