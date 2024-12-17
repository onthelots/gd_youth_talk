import 'package:gd_youth_talk/src/data/models/youth_policy_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/youth_policy_repository.dart';

class GetYouthPolicyUseCase {
  final YouthPolicyRepository repository;

  GetYouthPolicyUseCase(this.repository);

  Future<List<YouthPolicy>> execute(int display, int pageIndex) {
    return repository.getYouthPolicies(display, pageIndex);
  }
}
