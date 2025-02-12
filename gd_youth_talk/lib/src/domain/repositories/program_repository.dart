import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/data/sources/programs_datasource.dart';

class ProgramRepository {
  final ProgramDataSource _dataSource;

  ProgramRepository(this._dataSource);

  Stream<List<ProgramModel>> getPrograms() {
    return _dataSource.fetchPrograms();
  }

  Future<void> updateHits(String documentId, int currentHits) {
    return _dataSource.updateHits(documentId, currentHits);
  }
}
