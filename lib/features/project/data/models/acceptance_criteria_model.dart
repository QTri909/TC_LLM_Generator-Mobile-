import '../../domain/entities/acceptance_criteria_entity.dart';

class AcceptanceCriteriaModel extends AcceptanceCriteriaEntity {
  const AcceptanceCriteriaModel({
    required super.id,
    required super.userStoryId,
    required super.content,
    required super.orderNo,
    required super.completed,
    super.createdAt,
  });

  factory AcceptanceCriteriaModel.fromJson(Map<String, dynamic> json) {
    return AcceptanceCriteriaModel(
      id: json['acceptanceCriteriaId'] ?? '',
      userStoryId: json['userStoryId'] ?? '',
      content: json['content'] ?? '',
      orderNo: json['orderNo'] ?? 0,
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acceptanceCriteriaId': id,
      'userStoryId': userStoryId,
      'content': content,
      'orderNo': orderNo,
      'completed': completed,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
