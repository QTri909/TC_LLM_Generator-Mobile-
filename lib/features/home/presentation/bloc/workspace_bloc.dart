import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_project.dart';
import '../../domain/usecases/create_workspace.dart';
import '../../domain/usecases/get_workspaces.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final CreateWorkspace createWorkspace;
  final CreateProject createProject;

  WorkspaceBloc({
    required this.getWorkspaces,
    required this.createWorkspace,
    required this.createProject,
  }) : super(WorkspaceInitial()) {
    on<GetWorkspacesEvent>(_onGetWorkspaces);
    on<SelectWorkspaceEvent>(_onSelectWorkspace);
    on<CreateWorkspaceEvent>(_onCreateWorkspace);
    on<CreateProjectEvent>(_onCreateProject);
  }

  Future<void> _onGetWorkspaces(
    GetWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceLoading());
    try {
      final workspaces = await getWorkspaces(event.accessToken);
      if (workspaces.isNotEmpty) {
        var workspaceToSelect = workspaces.first;
        if (event.selectWorkspaceId != null) {
          try {
            workspaceToSelect = workspaces.firstWhere(
              (w) => w.id == event.selectWorkspaceId,
            );
          } catch (_) {
            workspaceToSelect = workspaces.first;
          }
        }
        emit(
          WorkspaceLoaded(
            workspaces: workspaces,
            selectedWorkspace: workspaceToSelect,
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

  Future<void> _onCreateWorkspace(
    CreateWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceCreateLoading());
    try {
      final newWorkspace = await createWorkspace(
        event.accessToken,
        event.name,
        event.description,
      );

      emit(WorkspaceCreateSuccess(workspace: newWorkspace));

      // After creation success, reload or add to existing
      // For simplicity, trigger a GetWorkspacesEvent to refresh and select the new workspace
      add(
        GetWorkspacesEvent(
          accessToken: event.accessToken,
          selectWorkspaceId: newWorkspace.id,
        ),
      );
    } catch (e) {
      emit(WorkspaceCreateError(message: e.toString()));
    }
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(ProjectCreateLoading());
    try {
      final updatedWorkspace = await createProject(
        event.accessToken,
        event.workspaceId,
        event.name,
        event.description,
        event.businessRules,
      );

      emit(ProjectCreateSuccess(workspace: updatedWorkspace));

      // Refresh workspaces to reflect the new project
      add(
        GetWorkspacesEvent(
          accessToken: event.accessToken,
          selectWorkspaceId: event.workspaceId,
        ),
      );
    } catch (e) {
      emit(ProjectCreateError(message: e.toString()));
    }
  }
}
