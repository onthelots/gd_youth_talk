import 'package:gd_youth_talk/data/models/program_model.dart';
import 'package:gd_youth_talk/domain/repositories/program_repository.dart';

class ProgramUseCase {
  final ProgramRepository repository;

  ProgramUseCase(this.repository);

  /// UseCase1. 카테고리에 따른 필터링
  Stream<List<ProgramModel>> getProgramsByCategory(String category) {
    return repository.getPrograms().map((programs) {
      return programs.where((program) => program.category == category).toList();
    });
  }

  /// UseCase2. 최근 등록 프로그램 (4개)
  Stream<List<ProgramModel>> getLatestPrograms() {
    return repository.getPrograms().map((programs) {
      programs.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
      return programs.take(4).toList();
    });
  }

  /// UseCase3. 검색 쿼리에 따른 프로그램 리스트 필터링
  Stream<List<ProgramModel>> searchPrograms(String query) {
    return repository.getPrograms().map((programs) {
      return programs.where((program) {
        return (program.title?.contains(query) ?? false) ||
            (program.subtitle?.contains(query) ?? false);
      }).toList();
    });
  }

  /// UseCase4. 특정 날짜에 해당하는 프로그램 필터링
  Stream<List<ProgramModel>> getProgramsByDate(DateTime date) {
    return repository.getPrograms().map((programs) {
      return programs.where((program) {
        // 프로그램의 시작일과 종료일이 날짜 범위에 포함되는지 확인
        final startDate = program.startDate ?? DateTime(0); // 기본값은 아주 과거 날짜
        final endDate = program.endDate ?? DateTime(9999, 12, 31); // 기본값은 아주 미래 날짜

        return date.isAfter(startDate) && date.isBefore(endDate);
      }).toList();
    });
  }
}
