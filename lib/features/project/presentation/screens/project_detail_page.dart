import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/create_story_usecase.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import '../../data/datasources/project_remote_data_source.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';
import 'story_detail_page.dart';
import 'create_story_page.dart';
import 'test_suite_list_view.dart';
import 'test_plan_list_view.dart';
import '../bloc/project_bloc.dart';
import '../../domain/usecases/get_test_suites.dart';
import '../../domain/usecases/create_test_suite.dart';
import '../../domain/usecases/get_test_plans.dart';
import '../../domain/usecases/create_test_plan.dart';

class ProjectDetailPage extends StatefulWidget {
  final ProjectEntity project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  int _bottomNavIndex = 0;
  bool _isRepositoryActive = true;
  late StoryBloc _storyBloc;
  late ProjectBloc _projectBloc;
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    final client = http.Client();
    final remoteDataSource = ProjectRemoteDataSource(client: client);
    final repository = ProjectRepositoryImpl(remoteDataSource: remoteDataSource);
    final getStoriesUseCase = GetStoriesUseCase(repository);
    final createStoryUseCase = CreateStoryUseCase(repository);

    _storyBloc = StoryBloc(
      createStoryUseCase: createStoryUseCase,
      getStoriesUseCase: getStoriesUseCase,
    )..add(GetStoriesEvent(projectId: widget.project.id));

    _projectBloc = ProjectBloc(
      getTestSuites: GetTestSuites(repository),
      createTestSuite: CreateTestSuite(repository),
      getTestPlans: GetTestPlans(repository),
      createTestPlan: CreateTestPlan(repository),
    );
  }

  @override
  void dispose() {
    _storyBloc.close();
    _projectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _storyBloc),
        BlocProvider.value(value: _projectBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFAB(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    if (_bottomNavIndex == 1) {
      return TestPlanListView(projectId: widget.project.id);
    }
    
    // Project Tab (index 0)
    return Column(
      children: [
        _buildToggles(),
        if (_isRepositoryActive) ...[
          _buildSearchAndFilter(),
          Expanded(
            child: BlocBuilder<StoryBloc, StoryState>(
              builder: (context, state) {
                if (state is StoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StoriesError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is StoriesLoaded || state is StoryCreateSuccess) {
                  List<StoryEntity> stories = [];
                  if (state is StoriesLoaded) {
                    stories = state.stories;
                  } else if (state is StoryCreateSuccess) {
                    _storyBloc.add(GetStoriesEvent(projectId: widget.project.id));
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (stories.isEmpty) {
                    return const Center(child: Text('No stories found. Create one!'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildStoryCard(stories[index]),
                      );
                    },
                  );
                }
                
                return const SizedBox();
              },
            ),
          ),
        ] else ...[
          Expanded(
            child: TestSuiteListView(
              projectName: widget.project.name,
              projectId: widget.project.id,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildFAB() {
    if (_bottomNavIndex != 0 || !_isRepositoryActive) return null;
    
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider.value(
                value: _storyBloc,
                child: CreateStoryPage(projectId: widget.project.id),
              );
            },
            fullscreenDialog: true,
          ),
        ).then((_) {
          _storyBloc.add(GetStoriesEvent(projectId: widget.project.id));
        });
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white, size: 32),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: [
          Text(
            widget.project.name,
            style: const TextStyle(
              color: Color(0xFF111418),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'ACTIVE SPRINT',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildToggles() {
    return Container(
      color: Colors.white.withOpacity(0.9),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRepositoryActive = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _isRepositoryActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: _isRepositoryActive
                      ? null
                      : Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder,
                      color: _isRepositoryActive
                          ? AppColors.primary
                          : Colors.grey[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Repository',
                      style: TextStyle(
                        color: _isRepositoryActive
                            ? AppColors.primary
                            : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRepositoryActive = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_isRepositoryActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: !_isRepositoryActive
                      ? null
                      : Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books,
                      color: !_isRepositoryActive
                          ? AppColors.primary
                          : Colors.grey[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Test Suite',
                      style: TextStyle(
                        color: !_isRepositoryActive
                            ? AppColors.primary
                            : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search user stories...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(StoryEntity story) {
    bool isExpanded = _expandedStates[story.id] ?? false;
    MaterialColor color = Colors.blue;
    if (story.priority == 'High') color = Colors.orange;
    if (story.priority == 'Medium') color = Colors.blue;
    if (story.priority == 'Low') color = Colors.grey;

    bool isAiReady = story.acceptanceCriteria.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (innerContext) => BlocProvider.value(
              value: _projectBloc,
              child: StoryDetailPage(
                story: story,
                projectName: widget.project.name,
              ),
            ),
          ),
        );
      },
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedStates[story.id] = !isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      story.id,
                      style: TextStyle(
                        color: color[600],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              story.title,
              style: const TextStyle(
                color: Color(0xFF111418),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF111418),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'AS A ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(text: '${story.role}\n'),
                    const TextSpan(
                      text: 'I WANT TO ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(text: '${story.action}\n'),
                    const TextSpan(
                      text: 'SO THAT ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(text: story.reason),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF3F4F6)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ACCEPTANCE CRITERIA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${story.acceptanceCriteria.length} ACs',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...story.acceptanceCriteria.map((text) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildChecklistItem(text, false),
                );
              }).toList(),
            ] else ...[
              const SizedBox(height: 8),
              if (story.role.isNotEmpty && story.action.isNotEmpty) 
                Text(
                  'As a ${story.role}, I want to ${story.action}...',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.checklist, size: 14, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    '${story.acceptanceCriteria.length} ACs',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (isAiReady) ...[
                    const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'AI Ready',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ] else ...[
                    Icon(Icons.science, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    const Text(
                      'Draft',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: 20,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: isChecked ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isChecked ? AppColors.primary : Colors.grey[400]!,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: isChecked
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _bottomNavIndex,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: 'PROJECT',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'TEST PLAN',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'SETTINGS',
        ),
      ],
    );
  }
}
