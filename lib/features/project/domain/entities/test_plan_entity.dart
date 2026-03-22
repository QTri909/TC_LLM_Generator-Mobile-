import 'package:equatable/equatable.dart';

class TestPlanEntity extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String status;
  final DateTime createdAt;
  final List<String> suiteIds;

  const TestPlanEntity({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
    required this.suiteIds,
  });

  @override
  List<Object?> get props => [
    id,
    projectId,
    name,
    description,
    status,
    createdAt,
    suiteIds,
  ];
}
