import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';

class CreateProjectPage extends StatefulWidget {
  final String accessToken;
  final String workspaceId;

  const CreateProjectPage({
    super.key,
    required this.accessToken,
    required this.workspaceId,
  });

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _projectKey = '';

  // Business Rules
  final List<Map<String, dynamic>> _businessRules = [];
  final _ruleFormKey = GlobalKey<FormState>();
  final _ruleTitleController = TextEditingController();
  final _ruleDescController = TextEditingController();
  int _rulePriority = 1;
  String _ruleSource = '';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();

    _nameController.addListener(_generateProjectKey);
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _descController.dispose();
    _ruleTitleController.dispose();
    _ruleDescController.dispose();
    super.dispose();
  }

  void _generateProjectKey() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _projectKey = '');
      return;
    }

    // Generate project key: uppercase words first letters + random number
    final words = name.split(RegExp(r'\s+'));
    String key;
    if (words.length >= 2) {
      key = words
          .where((w) => w.isNotEmpty)
          .take(3)
          .map((w) => w[0].toUpperCase())
          .join();
    } else {
      key = name.substring(0, min(4, name.length)).toUpperCase();
    }
    final random = Random().nextInt(900) + 100;
    setState(() => _projectKey = '$key-$random');
  }

  void _addBusinessRule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int localPriority = _rulePriority;
        String localSource = _ruleSource;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: bottomInset + 24,
              ),
              child: Form(
                key: _ruleFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.rule,
                              color: Color(0xFFF59E0B),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Add Business Rule',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          'Define rules and constraints for this project.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Rule Title
                      _buildFieldLabel('Rule Title', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ruleTitleController,
                        decoration: _buildInputDecoration(
                          'e.g. Password must be 8+ characters',
                          prefixIcon: Icons.title,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Rule title is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rule Description
                      _buildFieldLabel('Description', isRequired: false),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ruleDescController,
                        maxLines: 3,
                        decoration: _buildInputDecoration(
                          'Describe the business rule in detail...',
                          prefixIcon: Icons.description_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Priority & Source Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Priority', isRequired: true),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: localPriority,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.unfold_more,
                                        color: AppColors.textGrey,
                                      ),
                                      items: [1, 2, 3, 4, 5]
                                          .map(
                                            (p) => DropdownMenuItem<int>(
                                              value: p,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    p <= 2
                                                        ? Icons
                                                              .keyboard_double_arrow_up
                                                        : p == 3
                                                        ? Icons.drag_handle
                                                        : Icons
                                                              .keyboard_double_arrow_down,
                                                    size: 16,
                                                    color: p <= 2
                                                        ? Colors.red
                                                        : p == 3
                                                        ? Colors.orange
                                                        : Colors.green,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'P$p',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setSheetState(
                                            () => localPriority = val,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Source', isRequired: false),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: localSource.isEmpty
                                          ? null
                                          : localSource,
                                      isExpanded: true,
                                      hint: const Text(
                                        'Select',
                                        style: TextStyle(
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.unfold_more,
                                        color: AppColors.textGrey,
                                      ),
                                      items:
                                          [
                                                'Stakeholder',
                                                'Regulation',
                                                'UX Research',
                                                'Technical',
                                                'Other',
                                              ]
                                              .map(
                                                (s) => DropdownMenuItem<String>(
                                                  value: s,
                                                  child: Text(
                                                    s,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setSheetState(
                                            () => localSource = val,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Add Rule Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_ruleFormKey.currentState?.validate() ??
                                false) {
                              setState(() {
                                _businessRules.add({
                                  'title': _ruleTitleController.text.trim(),
                                  'description':
                                      _ruleDescController.text.trim().isEmpty
                                      ? null
                                      : _ruleDescController.text.trim(),
                                  'priority': localPriority,
                                  'source': localSource.isEmpty
                                      ? null
                                      : localSource,
                                });
                              });
                              _ruleTitleController.clear();
                              _ruleDescController.clear();
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text(
                            'Add Rule',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<WorkspaceBloc>().add(
        CreateProjectEvent(
          accessToken: widget.accessToken,
          workspaceId: widget.workspaceId,
          name: _nameController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          businessRules: _businessRules.isEmpty ? null : _businessRules,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          if (state is ProjectCreateSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Project created successfully!'),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is ProjectCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProjectCreateLoading;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Premium App Bar
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 140,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.textDark,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: const Text(
                      'New Project',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.primary.withOpacity(0.05),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Form Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // --- Section: Project Info ---
                          _buildSectionCard(
                            icon: Icons.info_outline,
                            iconColor: AppColors.primary,
                            title: 'Project Information',
                            children: [
                              _buildFieldLabel(
                                'Project Name',
                                isRequired: true,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                enabled: !isLoading,
                                decoration: _buildInputDecoration(
                                  'e.g. E-Commerce Platform',
                                  prefixIcon: Icons.folder_open,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Project name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Project Key (auto-generated, read-only)
                              _buildFieldLabel(
                                'Project Key',
                                isRequired: false,
                                suffix: 'Auto-generated',
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.key,
                                      size: 18,
                                      color: AppColors.textGrey,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _projectKey.isEmpty
                                          ? 'Enter name to generate key'
                                          : _projectKey,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: _projectKey.isEmpty
                                            ? FontWeight.normal
                                            : FontWeight.w700,
                                        color: _projectKey.isEmpty
                                            ? AppColors.textGrey
                                            : AppColors.primary,
                                        letterSpacing: _projectKey.isEmpty
                                            ? 0
                                            : 1.2,
                                      ),
                                    ),
                                    if (_projectKey.isNotEmpty) ...[
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          'AUTO',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Description
                              _buildFieldLabel(
                                'Description',
                                isRequired: false,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _descController,
                                enabled: !isLoading,
                                maxLines: 4,
                                decoration: _buildInputDecoration(
                                  'Briefly describe what this project is about...',
                                  prefixIcon: Icons.description_outlined,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // --- Section: Business Rules ---
                          _buildSectionCard(
                            icon: Icons.rule,
                            iconColor: const Color(0xFFF59E0B),
                            title: 'Business Rules',
                            trailing: TextButton.icon(
                              onPressed: isLoading ? null : _addBusinessRule,
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 18,
                              ),
                              label: const Text(
                                'Add Rule',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFF59E0B),
                              ),
                            ),
                            children: [
                              if (_businessRules.isEmpty)
                                _buildEmptyRulesState()
                              else
                                ..._businessRules.asMap().entries.map(
                                  (entry) => _buildBusinessRuleCard(
                                    entry.key,
                                    entry.value,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Create Project Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.rocket_launch, size: 20),
                                        SizedBox(width: 10),
                                        Text(
                                          'Create Project',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Cancel Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Builders ──────────────────────────────────────────────

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(
    String text, {
    bool isRequired = false,
    String? suffix,
  }) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              fontFamily: 'Inter',
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        if (suffix != null) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              suffix,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint, {IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(prefixIcon, size: 18, color: AppColors.textGrey),
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildEmptyRulesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rule_folder_outlined,
              size: 36,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No business rules yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add rules to define project constraints\nand requirements.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessRuleCard(int index, Map<String, dynamic> rule) {
    final priorityColor = (rule['priority'] as int) <= 2
        ? Colors.red
        : (rule['priority'] as int) == 3
        ? Colors.orange
        : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'P${rule['priority']}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: priorityColor,
                  ),
                ),
              ),
              if (rule['source'] != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    rule['source'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() => _businessRules.removeAt(index));
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            rule['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          if (rule['description'] != null &&
              (rule['description'] as String).isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              rule['description'],
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
