import '../entities/test_plan_entity.dart';
import '../repositories/project_repository.dart';

class GetTestPlans {
  final ProjectRepository repository;

  GetTestPlans(this.repository);

  Future<List<TestPlanEntity>> call(String projectId) async {
    return await repository.getTestPlans(projectId);
  }
}
