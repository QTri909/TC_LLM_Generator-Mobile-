import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../bloc/project_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/story_entity.dart';
import '../models/mock_models.dart';
import 'create_manual_test_case_page.dart';
import 'tabs/story_tab.dart';
import 'tabs/test_cases_tab.dart';
import '../widgets/add_to_suite_dialog.dart';

class StoryDetailPage extends StatefulWidget {
  final StoryEntity story;
  final String projectName;

  const StoryDetailPage({
    super.key,
    required this.story,
    required this.projectName,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  int _selectedTabIndex = 0; // 0: Story, 1: Test Case, 2: Test Plan
  bool _isSelectionMode = false;
  
  final List<TestCaseMock> _mockTestCases = [
    TestCaseMock(id: 'TC-01', title: 'Successful Login', type: 'Positive', description: 'Verifies standard login flow with correct user data'),
    TestCaseMock(id: 'TC-02', title: 'Invalid Password Error', type: 'Negative', description: 'Ensures system rejects incorrect credentials'),
    TestCaseMock(id: 'TC-03', title: 'Character Limit', type: 'Boundary', description: 'Maximum character limit for username field'),
    TestCaseMock(id: 'TC-04', title: 'SQL Injection Test', type: 'Security', description: 'Check input sanitation on username field'),
    TestCaseMock(id: 'TC-05', title: 'Remember Me Toggle', type: 'Positive', description: 'Session persistence across browser restarts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: _buildAppBar(),
      floatingActionButton: (_selectedTabIndex == 1 && !_isSelectionMode)
          ? _buildSpeedDial()
          : null,
      bottomNavigationBar: (_selectedTabIndex == 1 && _isSelectionMode)
          ? _buildSelectionBottomBar()
          : null,
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: SingleChildScrollView(
              child: _selectedTabIndex == 0
                  ? StoryTab(story: widget.story, projectName: widget.projectName)
                  : _selectedTabIndex == 1
                  ? TestCasesTab(
                      testCases: _mockTestCases,
                      isSelectionMode: _isSelectionMode,
                      onSelectionModeActivated: () {
                        setState(() {
                          _isSelectionMode = true;
                        });
                      },
                      onToggleSelection: (tc, isSelected) {
                        setState(() {
                          tc.isSelected = isSelected;
                        });
                      },
                    )
                  : const Center(child: Text("Test Plan Tab WIP")),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    bool isTestCaseTab = _selectedTabIndex == 1;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: !isTestCaseTab,
      leading: (isTestCaseTab && _isSelectionMode)
          ? IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF111418)),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  for (var tc in _mockTestCases) {
                    tc.isSelected = false;
                  }
                });
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111418)),
              onPressed: () => Navigator.of(context).pop(),
            ),
      title: Column(
        crossAxisAlignment: isTestCaseTab ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            'Project: ${widget.projectName}'.toUpperCase(),
            style: TextStyle(
              color: isTestCaseTab ? AppColors.primary : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isTestCaseTab ? 'Test Cases' : 'Story Details',
            style: const TextStyle(
              color: Color(0xFF111418),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (isTestCaseTab && _isSelectionMode)
          TextButton(
            onPressed: () {
              setState(() {
                for (var tc in _mockTestCases) {
                  tc.isSelected = true;
                }
              });
            },
            child: const Text('Select all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          )
        else if (isTestCaseTab && !_isSelectionMode)
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF111418)),
            onPressed: () {},
          )
        else
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF111418)),
            onPressed: () {},
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey[200], height: 1),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            _buildTabItem(0, 'Story'),
            _buildTabItem(1, 'Test Case'),
            _buildTabItem(2, 'Test Plan'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF111418) : Colors.grey[500],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      activeBackgroundColor: AppColors.primary,
      activeForegroundColor: Colors.white,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.auto_awesome, color: AppColors.primary),
          backgroundColor: Colors.white,
          label: 'Generate with AI',
          labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.edit, color: AppColors.primary),
          backgroundColor: Colors.white,
          label: 'Write Manually',
          labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateManualTestCasePage(
                  storyId: widget.story.id,
                  acceptanceCriteria: widget.story.acceptanceCriteria,
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectionBottomBar() {
    int selectedCount = _mockTestCases.where((tc) => tc.isSelected).length;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${selectedCount} items selected',
                  style: const TextStyle(
                    color: Color(0xFF111418),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSelectionMode = false;
                      for (var tc in _mockTestCases) {
                        tc.isSelected = false;
                      }
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: selectedCount == 0 ? null : () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: context.read<ProjectBloc>(),
                    child: AddToSuiteDialog(
                      selectedCount: selectedCount,
                      projectId: widget.story.projectId,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      _isSelectionMode = false;
                      for (var tc in _mockTestCases) {
                        tc.isSelected = false;
                      }
                    });
                  }
                });
              },
              icon: const Icon(Icons.library_add, size: 20),
              label: const Text('Add to Suite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
