import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_workspaces.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;

  WorkspaceBloc({required this.getWorkspaces}) : super(WorkspaceInitial()) {
    on<GetWorkspacesEvent>(_onGetWorkspaces);
    on<SelectWorkspaceEvent>(_onSelectWorkspace);
  }

  Future<void> _onGetWorkspaces(
    GetWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceLoading());
    try {
      final workspaces = await getWorkspaces(event.accessToken);
      if (workspaces.isNotEmpty) {
        emit(
          WorkspaceLoaded(
            workspaces: workspaces,
            selectedWorkspace: workspaces.first,
          ),
        );
      } else {
        emit(WorkspaceLoaded(workspaces: workspaces));
      }
    } catch (e) {
      emit(WorkspaceError(message: e.toString()));
    }
  }

  void _onSelectWorkspace(
    SelectWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      try {
        final newSelectedWorkspace = currentState.workspaces.firstWhere(
          (w) => w.id == event.workspaceId,
        );
        emit(
          WorkspaceLoaded(
            workspaces: currentState.workspaces,
            selectedWorkspace: newSelectedWorkspace,
          ),
        );
      } catch (_) {
        // Keeps current state if ID not found, or maybe emit logic error
      }
    }
  }
}
