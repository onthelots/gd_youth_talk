import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';

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
      if (query.isEmpty) {
        return []; // 쿼리가 비어있을 때 빈 리스트 반환
      }
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
        DateTime onlyDate(DateTime date) => DateTime(date.year, date.month, date.day);

        final selectedDate = onlyDate(date);
        final startDate = onlyDate(program.programStartDate ?? DateTime(0));
        final endDate = onlyDate(program.programEndDate ?? DateTime(9999, 12, 31));

        return !selectedDate.isBefore(startDate) && !selectedDate.isAfter(endDate);

      }).toList();
    });
  }

  Stream<Map<DateTime, List<ProgramModel>>> getProgramsGroupedByDate() {
    return repository.getPrograms().map((programs) {
      final groupedPrograms = <DateTime, List<ProgramModel>>{};
      for (var program in programs) {
        final startDate = DateTime(
          program.programStartDate!.year,
          program.programStartDate!.month,
          program.programStartDate!.day,
        );

        final endDate = DateTime(
          program.programEndDate!.year,
          program.programEndDate!.month,
          program.programEndDate!.day,
        );

        for (var date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
          groupedPrograms.putIfAbsent(date, () => []);
          groupedPrograms[date]!.add(program);
        }
      }
      return groupedPrograms;
    });
  }
}