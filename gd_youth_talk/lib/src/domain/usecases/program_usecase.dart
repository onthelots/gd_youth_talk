import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';

class ProgramUseCase {
  final ProgramRepository repository;

  ProgramUseCase(this.repository);

  // usecase0. 전체 프로그램 가져오기
  Stream<List<ProgramModel>> getAllPrograms() {
    return repository.getPrograms();
  }

  // usecase1. 카테고리 필터링
  List<ProgramModel> filterByCategory(List<ProgramModel> programs, String category) {
    return programs.where((program) => program.category == category).toList();
  }

  // usecase2. 최근 수정(등록)된 프로그램
  List<ProgramModel> getLatestPrograms(List<ProgramModel> programs) {
    final sortedPrograms = List<ProgramModel>.from(programs); // 원본 복제 (무결성 유지)
    sortedPrograms.sort((a, b) => (b.lastModified ?? DateTime(0)).compareTo(a.lastModified ?? DateTime(0)));
    print("Sorted latest programs: ${sortedPrograms.map((p) => p.title).join(', ')}");
    return sortedPrograms;
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

  // usecase4. 날짜별 프로그램
  List<ProgramModel> dateFilterPrograms(
      List<ProgramModel> programs, DateTime targetDate) {
    return programs
        .where((program) =>
            program.programDates?.any((date) =>
                date.year == targetDate.year &&
                date.month == targetDate.month &&
                date.day == targetDate.day) ??
            false)
        .toList()
      ..sort((a, b) {
        DateTime? earliestA = a.programDates
            ?.where((date) =>
                date.year == targetDate.year &&
                date.month == targetDate.month &&
                date.day == targetDate.day)
            .reduce((d1, d2) => d1.isBefore(d2) ? d1 : d2);
        DateTime? earliestB = b.programDates
            ?.where((date) =>
                date.year == targetDate.year &&
                date.month == targetDate.month &&
                date.day == targetDate.day)
            .reduce((d1, d2) => d1.isBefore(d2) ? d1 : d2);

        if (earliestA == null) return 1;
        if (earliestB == null) return -1;
        return earliestA.compareTo(earliestB);
      });
  }

  // usecase6. 등록 마감순 정렬
  List<ProgramModel> getUpcomingPrograms(List<ProgramModel> programs) {
    final upcomingPrograms = List<ProgramModel>.from(programs); // 원본 복제
    upcomingPrograms.retainWhere((program) {
      final today = DateTime.now();
      final oneWeekLater = today.add(const Duration(days: 7));
      final registrationEndDate = program.registrationEndDate;
      return registrationEndDate != null && registrationEndDate.isAfter(today) && registrationEndDate.isBefore(oneWeekLater);
    });
    upcomingPrograms.sort((a, b) => a.registrationEndDate!.compareTo(b.registrationEndDate!));
    return upcomingPrograms;
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

  // usecase10. 최근 본 프로그램 가져오기
  List<ProgramModel> getRecentPrograms(List<ProgramModel> programs, List<String> programIds) {
    if (programIds.isNotEmpty) {
      return programs.where((program) => programIds.contains(program.documentId)).toList();
    } else {
      return [];
    }
  }
}

