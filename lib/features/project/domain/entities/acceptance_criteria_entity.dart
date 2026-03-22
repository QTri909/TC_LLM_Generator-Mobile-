import 'package:equatable/equatable.dart';

class AcceptanceCriteriaEntity extends Equatable {
  final String id;
  final String userStoryId;
  final String content;
  final int orderNo;
  final bool completed;
  final DateTime? createdAt;

  const AcceptanceCriteriaEntity({
    required this.id,
    required this.userStoryId,
    required this.content,
    required this.orderNo,
    required this.completed,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, userStoryId, content, orderNo, completed, createdAt];
}
