import 'package:equatable/equatable.dart';

class TestSuiteEntity extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final int count;
  final List<String> testCaseIds;
  final DateTime createdAt;

  const TestSuiteEntity({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.count,
    required this.testCaseIds,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, projectId, name, description, count, testCaseIds, createdAt];
}
