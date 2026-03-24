import 'package:flutter/material.dart';
import 'package:automation_generate_tc/core/constants/app_colors.dart';
import 'package:automation_generate_tc/features/project/domain/entities/test_case_entity.dart';

class TestCaseDetailPage extends StatelessWidget {
  final TestCaseEntity testCase;

  const TestCaseDetailPage({super.key, required this.testCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF111418)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Test Case Detail',
          style: TextStyle(
            color: Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeAndStatus(),
            const SizedBox(height: 16),
            Text(
              testCase.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111418),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              testCase.description,
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 32),
            if (testCase.preconditions != null &&
                testCase.preconditions!.isNotEmpty) ...[
              _buildSectionHeader(Icons.settings, 'Preconditions'),
              const SizedBox(height: 12),
              _buildContentCard(testCase.preconditions!),
              const SizedBox(height: 32),
            ],
            _buildSectionHeader(Icons.format_list_numbered, 'Test Steps'),
            const SizedBox(height: 12),
            _buildStepsList(),
            const SizedBox(height: 32),
            _buildSectionHeader(Icons.check_circle_outline, 'Expected Result'),
            const SizedBox(height: 12),
            _buildContentCard(testCase.expectedResult),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeAndStatus() {
    return Row(
      children: [
        _buildTag(testCase.type, _getTypeColor(testCase.type)),
        const SizedBox(width: 8),
        _buildTag(testCase.status, Colors.grey[600]!),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'boundary':
        return Colors.orange;
      case 'security':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF334155),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildStepsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: testCase.steps.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                testCase.steps[index],
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
