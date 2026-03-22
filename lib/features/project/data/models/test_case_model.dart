import '../../domain/entities/test_case_entity.dart';

class TestCaseModel extends TestCaseEntity {
  const TestCaseModel({
    required super.id,
    required super.userStoryId,
    required super.title,
    required super.description,
    required super.type,
    super.preconditions,
    required super.steps,
    required super.expectedResult,
    required super.status,
    super.acceptanceCriteriaId,
  });

  factory TestCaseModel.fromJson(Map<String, dynamic> json) {
    // Parse steps: the backend stores stepDetails as a list or a single string.
    // The TestCase entity in Spring Boot has: title, description, type, preconditions,
    // stepDetails (or testSteps), expectedResult, status
    List<String> steps = [];
    final rawSteps = json['stepDetails'] ?? json['testSteps'] ?? json['steps'];
    if (rawSteps is List) {
      steps = rawSteps.map((s) {
        if (s is String) return s;
        if (s is Map)
          return s['description']?.toString() ??
              s['action']?.toString() ??
              s.toString();
        return s.toString();
      }).toList();
    } else if (rawSteps is String && rawSteps.isNotEmpty) {
      steps = [rawSteps];
    }

    return TestCaseModel(
      id: json['testCaseId']?.toString() ?? json['id']?.toString() ?? '',
      userStoryId: json['userStoryId']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? json['testType'] ?? 'FUNCTIONAL',
      preconditions: json['preconditions']?.toString(),
      steps: steps,
      expectedResult: json['expectedResult'] ?? '',
      status: json['status'] ?? 'DRAFT',
      acceptanceCriteriaId: json['acceptanceCriteriaId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      if (preconditions != null) 'preconditions': preconditions,
      'stepDetails': steps,
      'expectedResult': expectedResult,
      'userStoryId': userStoryId,
      if (acceptanceCriteriaId != null)
        'acceptanceCriteriaId': acceptanceCriteriaId,
    };
  }
}
