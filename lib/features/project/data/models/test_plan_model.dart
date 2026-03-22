import '../../domain/entities/test_plan_entity.dart';

class TestPlanModel extends TestPlanEntity {
  const TestPlanModel({
    required super.id,
    required super.projectId,
    required super.name,
    super.description,
    required super.status,
    required super.createdAt,
    required super.suiteIds,
  });

  factory TestPlanModel.fromJson(Map<String, dynamic> json) {
    return TestPlanModel(
      id: json['testPlanId'] ?? '',
      projectId: json['projectId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'DRAFT',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      suiteIds:
          (json['suiteIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'suites': suiteIds,
    };
  }
}
