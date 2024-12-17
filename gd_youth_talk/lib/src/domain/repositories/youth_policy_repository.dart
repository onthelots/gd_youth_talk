import 'package:gd_youth_talk/src/data/models/youth_policy_model.dart';
import 'package:gd_youth_talk/src/data/sources/youth_policy_datasource.dart';

class YouthPolicyRepository {
  final YouthPolicyDataSource dataSource;

  YouthPolicyRepository(this.dataSource);

  Future<List<YouthPolicy>> getYouthPolicies(int display, int pageIndex) async {
    return await dataSource.fetchYouthPolicies(
      display: display,
      pageIndex: pageIndex,
    );
  }
}
