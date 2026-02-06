import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../presentation/bloc/workspace_bloc.dart';
import '../../presentation/bloc/workspace_event.dart';
import '../../presentation/bloc/workspace_state.dart';

class WorkspacePage extends StatefulWidget {
  final String accessToken;

  const WorkspacePage({super.key, required this.accessToken});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkspaceError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is WorkspaceLoaded) {
            return _buildBody(state);
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(WorkspaceLoaded state) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopAppBar(),
          const Divider(height: 1, color: AppColors.border),
          _buildWorkspaceSelector(state.workspaces, state.selectedWorkspace),
          _buildSearchBar(),
          _buildSectionHeader(),
          _buildChips(),
          Expanded(child: _buildProjectList(state.selectedWorkspace)),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBLE_bKQm3gk-wnx_Jt1yPox_-yumwdsgljHkOh4dn5TGZ7CL8_d_MN1By-9uCLYV5k97xWv_f-DNArxj8snnV7cEx96psGeCOXEj90dnxseSEJIxJEW6fC-6vqPheSHtl22BUWgS72mDpQ1IXLv9EpYOJUY6z_giljThTCo_KvAajlBt4WvaIOapYy-PnquvpUgSLomw4gtATfDPZNvZLOTudXx0GwVrfghfKBjfslZ0n-a93yJuyhqRpwCwAvsNwZAuxzt1w_nY_2',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Workspaces',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceSelector(
    List<WorkspaceEntity> workspaces,
    WorkspaceEntity? selectedWorkspace,
  ) {
    if (workspaces.isEmpty) return const SizedBox();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE WORKSPACE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<WorkspaceEntity>(
                value: selectedWorkspace,
                isExpanded: true,
                icon: const Icon(Icons.unfold_more, color: Colors.grey),
                items: workspaces.map((WorkspaceEntity workspace) {
                  return DropdownMenuItem<WorkspaceEntity>(
                    value: workspace,
                    child: Text(
                      workspace.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (WorkspaceEntity? newValue) {
                  if (newValue != null) {
                    context.read<WorkspaceBloc>().add(
                      SelectWorkspaceEvent(workspaceId: newValue.id),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: AppColors.textGrey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search projects...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textGrey),
                ),
                style: const TextStyle(color: AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Projects',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'View All',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChip('All', isSelected: true),
          const SizedBox(width: 8),
          _buildChip('AI Active', icon: Icons.bolt),
          const SizedBox(width: 8),
          _buildChip('Completed'),
          const SizedBox(width: 8),
          _buildChip('Testing'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false, IconData? icon}) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isSelected ? null : Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList(WorkspaceEntity? selectedWorkspace) {
    final projects = selectedWorkspace?.projects ?? [];

    if (projects.isEmpty) {
      return const Center(child: Text("No projects found"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildProjectCard(projects[index]);
      },
    );
  }

  Widget _buildProjectCard(ProjectEntity project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smartphone, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Updated ${project.updatedAt.toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (project.status == 'ACTIVE')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        project.status,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Fake stats since we assume default project structure
              _StatItem(value: "12", label: "Stories"),
              _StatItem(value: "88", label: "Tests"),
              _StatItem(value: "AI", label: "Generating", isPrimary: true),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 24,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: project.members.length > 3
                      ? 4
                      : project.members.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      // Placeholder for avatar
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.grid_view, 'Dashboard', isActive: true),
          _buildNavItem(Icons.play_circle_outline, 'Runs'),
          _buildNavItem(Icons.analytics_outlined, 'Reports'),
          _buildNavItem(Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.primary : AppColors.textGrey),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.primary : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isPrimary;

  const _StatItem({
    required this.value,
    required this.label,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPrimary ? AppColors.primary : AppColors.textDark,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
