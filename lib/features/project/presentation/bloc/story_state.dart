import 'package:equatable/equatable.dart';
import '../../domain/entities/story_entity.dart';

abstract class StoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoriesLoading extends StoryState {}

class StoriesLoaded extends StoryState {
  final List<StoryEntity> stories;

  StoriesLoaded({required this.stories});

  @override
  List<Object?> get props => [stories];
}

class StoriesError extends StoryState {
  final String message;

  StoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StoryCreateLoading extends StoryState {}

class StoryCreateSuccess extends StoryState {
  final StoryEntity story;

  StoryCreateSuccess({required this.story});

  @override
  List<Object?> get props => [story];
}

class StoryCreateError extends StoryState {
  final String message;

  StoryCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}
