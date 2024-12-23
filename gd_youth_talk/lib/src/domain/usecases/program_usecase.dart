import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';

class ProgramUseCase {
  final ProgramRepository repository;

  ProgramUseCase(this.repository);

  // usecase1. 카테고리 필터링
  List<ProgramModel> filterByCategory(List<ProgramModel> programs, String category) {
    return programs.where((program) => program.category == category).toList();
  }

  // usecase2. 최근 수정(등록)된 프로그램
  List<ProgramModel> getLatestPrograms(List<ProgramModel> programs) {
    programs.sort((a, b) => (b.lastModified ?? DateTime(0)).compareTo(a.lastModified ?? DateTime(0)));
    return programs;
  }

  // usecase3. 프로그램 검색쿼리
  List<ProgramModel> searchPrograms(List<ProgramModel> programs, String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return programs.where((program) {
      return (program.title?.toLowerCase().contains(lowerQuery) ?? false) ||
          (program.subtitle?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  // usecase4. 날짜에 따른 프로그램 필터링
  List<ProgramModel> filterByDate(List<ProgramModel> programs, DateTime date) {
    DateTime onlyDate(DateTime date) => DateTime(date.year, date.month, date.day);
    final selectedDate = onlyDate(date);

    return programs.where((program) {
      final startDate = onlyDate(program.programStartDate ?? DateTime(0));
      final endDate = onlyDate(program.programEndDate ?? DateTime(9999, 12, 31));
      return !selectedDate.isBefore(startDate) && !selectedDate.isAfter(endDate);
    }).toList()
      ..sort((a, b) {
        final aStart = a.programStartDate ?? DateTime(9999, 12, 31);
        final bStart = b.programStartDate ?? DateTime(9999, 12, 31);
        final isADayDifferent = a.programStartDate?.day != a.programEndDate?.day;
        final isBDayDifferent = b.programStartDate?.day != b.programEndDate?.day;

        if (isADayDifferent && !isBDayDifferent) return 1;
        if (!isADayDifferent && isBDayDifferent) return -1;
        return aStart.compareTo(bStart);
      });
  }

  // usecase5. 특정 날짜에 따른 프로그램 리스트 Mapping
  Map<DateTime, List<ProgramModel>> groupByDate(List<ProgramModel> programs) {
    final groupedPrograms = <DateTime, List<ProgramModel>>{};
    for (var program in programs) {
      final startDate = DateTime(program.programStartDate!.year, program.programStartDate!.month, program.programStartDate!.day);
      final endDate = DateTime(program.programEndDate!.year, program.programEndDate!.month, program.programEndDate!.day);

      for (var date = startDate;
      date.isBefore(endDate.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))) {
        groupedPrograms.putIfAbsent(date, () => []);
        groupedPrograms[date]!.add(program);
      }
    }
    return groupedPrograms;
  }

  // usecase6. 등록 마감순 정렬
  List<ProgramModel> getUpcomingPrograms(List<ProgramModel> programs) {
    final today = DateTime.now();
    final oneWeekLater = today.add(const Duration(days: 7));

    return programs.where((program) {
      final registrationEndDate = program.registrationEndDate;
      if (registrationEndDate == null) return false;
      return registrationEndDate.isAfter(today) && registrationEndDate.isBefore(oneWeekLater);
    }).toList()
      ..sort((a, b) => a.registrationEndDate!.compareTo(b.registrationEndDate!));
  }

  // usecase7. Hits 순 정렬
  List<ProgramModel> sortByHits(List<ProgramModel> programs) {
    programs.sort((a, b) => b.hits.compareTo(a.hits));
    return programs;
  }

  // usecase8. program 상세내용 불러오기
  ProgramModel getProgramDetail(List<ProgramModel> programs, String docId) {
    return programs.firstWhere((program) => program.documentId == docId);
  }

  // usecase9. Hits + 1
  Future<void> incrementProgramHits(ProgramModel program) {
    return repository.updateHits(program.documentId!, program.hits);
  }
}
