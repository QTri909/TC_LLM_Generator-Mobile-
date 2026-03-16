import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CreateManualTestCasePage extends StatefulWidget {
  final String storyId;
  final List<String> acceptanceCriteria;

  const CreateManualTestCasePage({
    super.key,
    required this.storyId,
    required this.acceptanceCriteria,
  });

  @override
  State<CreateManualTestCasePage> createState() => _CreateManualTestCasePageState();
}

class _CreateManualTestCasePageState extends State<CreateManualTestCasePage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedAC;
  String? _selectedType = 'Functional';
  List<String> _testSteps = [''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection1BasicInfo(),
              _buildSection2Setup(),
              _buildSection3TestSteps(),
              _buildSection4ExpectedResult(),
              const SizedBox(height: 100), // Padding for bottom bar
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomCreateAction(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'New Test Case',
        style: TextStyle(
          color: Color(0xFF111418),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Save logic
          },
          child: const Text(
            'Save',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey[200], height: 1),
      ),
    );
  }

  Widget _buildSection1BasicInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AC Dropdown
          Text(
            'LINKED AC',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedAC,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 2),
              ),
              hintText: 'Select linked Acceptance Criteria',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Select Requirement', style: TextStyle(color: Colors.grey))),
              ...widget.acceptanceCriteria.map((ac) {
                return DropdownMenuItem(
                  value: ac,
                  child: Text(
                    ac.length > 40 ? '${ac.substring(0, 40)}...' : ac,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }),
            ],
            onChanged: (val) {
              setState(() => _selectedAC = val);
            },
            icon: const Icon(Icons.expand_more, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Title
          TextFormField(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111418),
            ),
            decoration: const InputDecoration(
              hintText: 'e.g., Verify successful login',
              hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCBD5E1),
              ),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF1F5F9), width: 2)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF1F5F9), width: 2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const SizedBox(height: 24),

          // Test Type Dropdown
          Text(
            'TEST TYPE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 4.0),
                  child: Icon(Icons.category, color: Colors.grey, size: 20),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: InputBorder.none,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Functional', child: Text('Functional', style: TextStyle(fontSize: 14))),
                      DropdownMenuItem(value: 'UI/UX', child: Text('UI/UX', style: TextStyle(fontSize: 14))),
                      DropdownMenuItem(value: 'Performance', child: Text('Performance', style: TextStyle(fontSize: 14))),
                      DropdownMenuItem(value: 'Security', child: Text('Security', style: TextStyle(fontSize: 14))),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedType = val);
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.expand_more, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection2Setup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Row(
              children: [
                Icon(Icons.settings, color: Colors.grey[500], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Setup & Data (Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            iconColor: Colors.grey[400],
            collapsedIconColor: Colors.grey[400],
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              _buildSetupField('Preconditions', 'Enter preconditions...'),
              const SizedBox(height: 16),
              _buildSetupField('Test Data', 'Define test datasets...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLines: 2,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection3TestSteps() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TEST STEPS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_testSteps.length} STEPS',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _testSteps.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                          child: Text(
                            '${index + 1}.',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: 2,
                            minLines: 1,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
                            decoration: InputDecoration(
                              hintText: 'Describe the action...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_testSteps.length > 1)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _testSteps.removeAt(index);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _testSteps.add('');
              });
            },
            icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 20),
            label: const Text(
              'Add Test Step',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection4ExpectedResult() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXPECTED RESULT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                  ),
                  child: Row(
                    children: [
                      _buildToolbarIcon(Icons.format_bold),
                      _buildToolbarIcon(Icons.format_italic),
                      _buildToolbarIcon(Icons.format_list_bulleted),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      _buildToolbarIcon(Icons.link),
                    ],
                  ),
                ),
                // Input
                TextFormField(
                  maxLines: 4,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe the expected outcome...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 20, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _buildBottomCreateAction() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // Create test case action
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.4),
          ),
          child: const Text(
            'Create Test Case',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
