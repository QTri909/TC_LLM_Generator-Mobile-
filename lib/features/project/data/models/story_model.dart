import '../../domain/entities/story_entity.dart';
import 'acceptance_criteria_model.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.role,
    required super.action,
    required super.reason,
    required super.status,
    required super.acceptanceCriteria,
    super.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['userStoryId']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      title: json['title'] ?? '',
      role: json['asA'] ?? '',
      action: json['iWantTo'] ?? '',
      reason: json['soThat'] ?? '',
      status: json['status'] ?? 'DRAFT',
      acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>?)
              ?.map((e) => AcceptanceCriteriaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userStoryId': id,
      'projectId': projectId,
      'title': title,
      'asA': role,
      'iWantTo': action,
      'soThat': reason,
      'status': status,
      'acceptanceCriteria': (acceptanceCriteria as List<AcceptanceCriteriaModel>).map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
