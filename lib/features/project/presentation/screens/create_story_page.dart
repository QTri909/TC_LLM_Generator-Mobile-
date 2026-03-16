import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';

class CreateStoryPage extends StatefulWidget {
  final String projectId;
  const CreateStoryPage({super.key, required this.projectId});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _acControllers = [TextEditingController()];
  final _titleController = TextEditingController();
  final _roleController = TextEditingController();
  final _actionController = TextEditingController();
  final _reasonController = TextEditingController();
  String _priority = 'Medium';
  final _pointsController = TextEditingController(text: '3');

  @override
  void dispose() {
    for (var controller in _acControllers) {
      controller.dispose();
    }
    _titleController.dispose();
    _roleController.dispose();
    _actionController.dispose();
    _reasonController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _addAcceptanceCriteria() {
    setState(() {
      _acControllers.add(TextEditingController());
    });
  }

  void _removeAcceptanceCriteria(int index) {
    if (_acControllers.length > 1) {
      setState(() {
        _acControllers[index].dispose();
        _acControllers.removeAt(index);
      });
    }
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      context.read<StoryBloc>().add(
        CreateStoryEvent(
          projectId: widget.projectId,
          title: _titleController.text,
          role: _roleController.text,
          action: _actionController.text,
          reason: _reasonController.text,
          priority: _priority,
          points: int.tryParse(_pointsController.text) ?? 3,
          acceptanceCriteria: _acControllers
              .map((e) => e.text)
              .where((e) => e.isNotEmpty)
              .toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New User Story',
          style: TextStyle(
            color: Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onCreate,
            child: const Text(
              'Create',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryCreateSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Story created successfully!')),
            );
          } else if (state is StoryCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoryTitleSection(),
                const SizedBox(height: 24),
                _buildBDDSection(),
                const SizedBox(height: 24),
                _buildAcceptanceCriteriaSection(),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF3F4F6), thickness: 1),
                const SizedBox(height: 16),
                _buildMetadataSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Story Title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          style: const TextStyle(fontSize: 16),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Title is required';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'e.g., Calendar Synchronization',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBDDSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildBDDRow('AS A', 'Enter the user role...', _roleController),
          const SizedBox(height: 16),
          _buildBDDRow('I WANT TO', 'Enter the desired action...', _actionController),
          const SizedBox(height: 16),
          _buildBDDRow('SO THAT', 'Enter the business benefit...', _reasonController),
        ],
      ),
    );
  }

  Widget _buildBDDRow(String prefix, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prefix,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptanceCriteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCEPTANCE CRITERIA',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _acControllers.length,
          itemBuilder: (context, index) {
            return _buildACItem(index);
          },
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _addAcceptanceCriteria,
          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
          label: const Text(
            'Add Acceptance Criteria',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildACItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_box_outline_blank, color: Colors.grey[400], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _acControllers[index],
              style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
              decoration: InputDecoration(
                hintText: index == 0
                    ? 'The user can see the sync status'
                    : 'Add criteria details...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
            ),
          ),
          if (_acControllers.length > 1) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _removeAcceptanceCriteria(index),
              splashRadius: 24,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PRIORITY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _priority,
                    isExpanded: true,
                    icon: const Icon(Icons.expand_more, color: Colors.grey),
                    items: ['High', 'Medium', 'Low']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _priority = val;
                        });
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
              const Text(
                'POINTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
