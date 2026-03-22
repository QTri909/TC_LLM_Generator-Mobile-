import 'package:equatable/equatable.dart';

class TestCaseEntity extends Equatable {
  final String id;
  final String userStoryId;
  final String title;
  final String description;
  final String type; // e.g., POSITIVE, NEGATIVE, BOUNDARY, SECURITY
  final String? preconditions;
  final List<String> steps;
  final String expectedResult;
  final String status; // e.g., DRAFT, ACTIVE
  final String? acceptanceCriteriaId;

  const TestCaseEntity({
    required this.id,
    required this.userStoryId,
    required this.title,
    required this.description,
    required this.type,
    this.preconditions,
    required this.steps,
    required this.expectedResult,
    required this.status,
    this.acceptanceCriteriaId,
  });

  @override
  List<Object?> get props => [
    id,
    userStoryId,
    title,
    description,
    type,
    preconditions,
    steps,
    expectedResult,
    status,
    acceptanceCriteriaId,
  ];
}
