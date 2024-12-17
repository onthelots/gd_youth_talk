import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/data/sources/programs_datasource.dart';

/// Repostiory (programdataSource > program Model)
class ProgramRepository {
  final ProgramDataSource _dataSource;

  ProgramRepository(this._dataSource);

  Stream<List<ProgramModel>> getPrograms() {
    return _dataSource.getProgramsStream();
  }
}
