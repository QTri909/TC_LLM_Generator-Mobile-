class TestCaseMock {
  final String id;
  final String title;
  final String type;
  final String description;
  bool isSelected;

  TestCaseMock({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    this.isSelected = false,
  });
}

class TestSuiteMock {
  final String id;
  final String name;
  final String? description;
  final int count;
  final List<String> testCaseIds;
  final DateTime createdAt;
  bool isSelected;

  TestSuiteMock({
    required this.id,
    required this.name,
    this.description,
    required this.count,
    this.testCaseIds = const [],
    DateTime? createdAt,
    this.isSelected = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
