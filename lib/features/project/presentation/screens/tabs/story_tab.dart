import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/story_entity.dart';
import '../../widgets/acceptance_criteria_item.dart';

class StoryTab extends StatelessWidget {
  final StoryEntity story;
  final String projectName;

  const StoryTab({
    super.key,
    required this.story,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'READY FOR TESTING',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.folder_open, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    projectName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCTXOKDLk9wP19cOHQ05LcOPayOY0gxkoXYlgAzy6UZxRxNSeOmxDdjN3o5wLRpeVVCnDeioEfSfEfs9YTyM_W5jr7Fu0Wz2Arp7LKuwIOi3F50de1FsGhGMt7edMtYeP65J-DXJd4b4LjGP0-TbyKw_1eSNU4qAeckILsqmJfFDUFHXiaJSsW8lctncDILjzR69LeiXSeUfC1EZ9hgaEXhIUk9Ofi6ygXNKq5Jied6-ifEgSA6meCO8pXoYJbBTrUEHt-ahTqQIBw1',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.id,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.title,
                        style: const TextStyle(
                          color: Color(0xFF111418),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStoryClause('As a', story.role.isNotEmpty ? story.role : '...'),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF9FAFB)),
                      const SizedBox(height: 12),
                      _buildStoryClause('I want to', story.action.isNotEmpty ? story.action : '...'),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF9FAFB)),
                      const SizedBox(height: 12),
                      _buildStoryClause('So that', story.reason.isNotEmpty ? story.reason : '...'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Acceptance Criteria (${story.acceptanceCriteria.length})',
                style: const TextStyle(
                  color: Color(0xFF111418),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.playlist_add_check, color: Colors.grey[400]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ...story.acceptanceCriteria.map((ac) => Column(
                  children: [
                    AcceptanceCriteriaItem(
                      criteriaText: ac,
                      testCaseCount: 0,
                    ),
                    const Divider(height: 1, color: Color(0xFFF9FAFB)),
                  ],
                )),
                Container(
                  color: Colors.grey[50], // Very light gray background
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.grey[400], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Add Acceptance Criteria...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryClause(String prefix, String suffix) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            prefix,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            suffix,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      ],
    );
  }
}
