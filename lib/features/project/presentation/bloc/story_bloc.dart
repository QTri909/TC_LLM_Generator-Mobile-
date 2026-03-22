import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_story_usecase.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final CreateStoryUseCase createStoryUseCase;
  final GetStoriesUseCase getStoriesUseCase;

  StoryBloc({required this.createStoryUseCase, required this.getStoriesUseCase})
    : super(StoryInitial()) {
    on<GetStoriesEvent>(_onGetStories);
    on<CreateStoryEvent>(_onCreateStory);
  }

  Future<void> _onGetStories(
    GetStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoriesLoading());
    try {
      final stories = await getStoriesUseCase(event.projectId);
      emit(
        StoriesLoaded(stories: stories.reversed.toList()),
      ); // Reversed to show new at the top (head asc)
    } catch (e) {
      emit(StoriesError(message: e.toString()));
    }
  }

  Future<void> _onCreateStory(
    CreateStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryCreateLoading());
    try {
      final story = await createStoryUseCase(
        projectId: event.projectId,
        title: event.title,
        role: event.role,
        action: event.action,
        reason: event.reason,
        acceptanceCriteria: event.acceptanceCriteria,
      );
      emit(StoryCreateSuccess(story: story));
    } catch (e) {
      emit(StoryCreateError(message: e.toString()));
    }
  }
}
