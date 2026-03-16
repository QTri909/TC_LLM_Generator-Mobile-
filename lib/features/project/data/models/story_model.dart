import '../../domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.role,
    required super.action,
    required super.reason,
    required super.priority,
    required super.points,
    required super.acceptanceCriteria,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      projectId: json['projectId'],
      title: json['title'],
      role: json['role'] ?? '',
      action: json['action'] ?? '',
      reason: json['reason'] ?? '',
      priority: json['priority'] ?? 'Medium',
      points: json['points'] is String ? int.tryParse(json['points']) ?? 3 : json['points'] ?? 3,
      acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>?)?.map((e) {
        if (e is String) return e;
        if (e is Map<String, dynamic>) return e['text']?.toString() ?? '';
        return e.toString();
      }).toList() ?? [],
    );
  }
}
