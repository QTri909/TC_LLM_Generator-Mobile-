import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';
import '../../domain/entities/test_plan_entity.dart';

class TestPlanListView extends StatefulWidget {
  final String projectId;

  const TestPlanListView({super.key, required this.projectId});

  @override
  State<TestPlanListView> createState() => _TestPlanListViewState();
}

class _TestPlanListViewState extends State<TestPlanListView> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(GetTestPlansEvent(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProjectError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is TestPlansLoaded) {
          final plans = state.plans;
          if (plans.isEmpty) {
            return _buildEmptyState();
          }
          return Column(
            children: [
              _buildHeader(plans.length),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return _buildPlanCard(plans[index]);
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count Test Plans',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Show Create Plan Sheet
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(TestPlanEntity plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Created on ${_formatDate(plan.createdAt)}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(plan.status),
              ],
            ),
            if (plan.description != null) ...[
              const SizedBox(height: 12),
              Text(
                plan.description!,
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.library_books, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 8),
                Text(
                  '${plan.suiteIds.length} Test Suites included',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                const Text(
                  'View Detail',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.green;
    if (status == 'ACTIVE') color = Colors.green;
    if (status == 'DRAFT') color = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No test plans found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first test plan to start testing.',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
