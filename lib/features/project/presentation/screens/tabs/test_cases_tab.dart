import 'package:flutter/material.dart';
import 'package:automation_generate_tc/core/constants/app_colors.dart';
import 'package:automation_generate_tc/features/project/domain/entities/test_case_entity.dart';
import '../test_case_detail_page.dart';

class TestCasesTab extends StatelessWidget {
  final List<TestCaseEntity> testCases;
  final bool isSelectionMode;
  final Set<String> selectedTestCaseIds;
  final VoidCallback onSelectionModeActivated;
  final Function(TestCaseEntity, bool) onToggleSelection;

  const TestCasesTab({
    super.key,
    required this.testCases,
    required this.isSelectionMode,
    required this.selectedTestCaseIds,
    required this.onSelectionModeActivated,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI-Generated Test Cases',
                    style: TextStyle(
                      color: Color(0xFF111418),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${testCases.length} Drafts',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: testCases.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: Color(0xFFDBE0E6)),
          itemBuilder: (context, index) {
            final tc = testCases[index];
            return InkWell(
              onLongPress: () {
                if (!isSelectionMode) {
                  onSelectionModeActivated();
                  onToggleSelection(tc, true);
                }
              },
              onTap: () {
                if (isSelectionMode) {
                  onToggleSelection(tc, !selectedTestCaseIds.contains(tc.id));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TestCaseDetailPage(testCase: tc),
                    ),
                  );
                }
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                constraints: const BoxConstraints(minHeight: 88),
                child: Row(
                  children: [
                    if (isSelectionMode)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: selectedTestCaseIds.contains(tc.id),
                            onChanged: (val) {
                              onToggleSelection(tc, val ?? false);
                            },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${tc.id}: ${tc.title}',
                                  style: const TextStyle(
                                    color: Color(0xFF111418),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusTag(tc.type),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tc.description,
                            style: const TextStyle(
                              color: Color(0xFF617289),
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusTag(String type) {
    Color bgColor;
    Color textColor;
    switch (type.toLowerCase()) {
      case 'positive':
        bgColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        break;
      case 'negative':
        bgColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        break;
      case 'boundary':
        bgColor = Colors.amber[100]!;
        textColor = Colors.amber[700]!;
        break;
      case 'security':
        bgColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        break;
      default:
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
