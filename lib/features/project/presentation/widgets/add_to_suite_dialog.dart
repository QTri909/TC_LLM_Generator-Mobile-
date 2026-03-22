import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';
import '../../domain/entities/test_suite_entity.dart';

class AddToSuiteDialog extends StatefulWidget {
  final int selectedCount;
  final String projectId;

  const AddToSuiteDialog({
    super.key,
    required this.selectedCount,
    required this.projectId,
  });

  @override
  State<AddToSuiteDialog> createState() => _AddToSuiteDialogState();
}

class _AddToSuiteDialogState extends State<AddToSuiteDialog> {
  final Map<String, bool> _selectionMap = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(GetTestSuitesEvent(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TestSuitesLoaded) {
          final suites = state.suites
              .where(
                (s) =>
                    s.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          int selectedSuitesCount = _selectionMap.values.where((v) => v).length;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildSearch(),
                  Expanded(child: _buildSuitesList(suites)),
                  _buildFooter(selectedSuitesCount),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("Error loading suites"));
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add to Test Suites',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Select suites for ${widget.selectedCount} cases',
            style: const TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search suites...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSuitesList(List<TestSuiteEntity> suites) {
    if (suites.isEmpty) return const Center(child: Text("No suites found"));
    return ListView.builder(
      itemCount: suites.length,
      itemBuilder: (context, index) {
        final suite = suites[index];
        final isSelected = _selectionMap[suite.id] ?? false;
        return CheckboxListTile(
          value: isSelected,
          onChanged: (val) =>
              setState(() => _selectionMap[suite.id] = val ?? false),
          title: Text(suite.name),
          subtitle: Text('${suite.count} test cases'),
          activeColor: AppColors.primary,
        );
      },
    );
  }

  Widget _buildFooter(int selectedCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: selectedCount == 0
                  ? null
                  : () {
                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.selectedCount} test case(s) added to $selectedCount suite(s)',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'Add ($selectedCount)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
