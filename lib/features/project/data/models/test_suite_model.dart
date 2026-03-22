import '../../domain/entities/test_suite_entity.dart';

class TestSuiteModel extends TestSuiteEntity {
  const TestSuiteModel({
    required super.id,
    required super.projectId,
    required super.name,
    super.description,
    required super.count,
    required super.testCaseIds,
    required super.createdAt,
  });

  factory TestSuiteModel.fromJson(Map<String, dynamic> json) {
    return TestSuiteModel(
      id: json['testSuiteId'] ?? '',
      projectId: json['projectId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      count: (json['testCaseCount'] as num?)?.toInt() ?? 0,
      testCaseIds: [], // Backend doesn't return IDs in the suite list
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'count': count,
      'testCaseIds': testCaseIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
