import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AcceptanceCriteriaItem extends StatefulWidget {
  final String criteriaText;
  final int testCaseCount;

  const AcceptanceCriteriaItem({
    super.key,
    required this.criteriaText,
    required this.testCaseCount,
  });

  @override
  State<AcceptanceCriteriaItem> createState() => _AcceptanceCriteriaItemState();
}

class _AcceptanceCriteriaItemState extends State<AcceptanceCriteriaItem> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: isDone,
              onChanged: (bool? value) {
                setState(() {
                  isDone = value ?? false;
                });
              },
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(color: Colors.grey[300]!, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.criteriaText,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDone ? Colors.grey[400] : const Color(0xFF111418),
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (widget.testCaseCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.assignment,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.testCaseCount} Test Cases',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_late,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'No tests yet',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
