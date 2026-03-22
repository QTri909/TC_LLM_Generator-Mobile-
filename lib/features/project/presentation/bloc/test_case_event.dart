import 'package:equatable/equatable.dart';

abstract class TestCaseEvent extends Equatable {
  const TestCaseEvent();

  @override
  List<Object?> get props => [];
}

class GetTestCasesEvent extends TestCaseEvent {
  final String userStoryId;

  const GetTestCasesEvent({required this.userStoryId});

  @override
  List<Object?> get props => [userStoryId];
}

class CreateTestCaseEvent extends TestCaseEvent {
  final String title;
  final String type;
  final String? preconditions;
  final List<String> steps;
  final String expectedResult;
  final String? userStoryId;
  final String? acceptanceCriteriaId;

  const CreateTestCaseEvent({
    required this.title,
    required this.type,
    this.preconditions,
    required this.steps,
    required this.expectedResult,
    this.userStoryId,
    this.acceptanceCriteriaId,
  });

  @override
  List<Object?> get props => [
    title,
    type,
    preconditions,
    steps,
    expectedResult,
    userStoryId,
    acceptanceCriteriaId,
  ];
}
