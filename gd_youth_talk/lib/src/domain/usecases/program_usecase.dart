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
      DateTime onlyDate(DateTime date) => DateTime(date.year, date.month, date.day);

      final selectedDate = onlyDate(date);

      return programs
          .where((program) {
        final startDate = onlyDate(program.programStartDate ?? DateTime(0));
        final endDate = onlyDate(program.programEndDate ?? DateTime(9999, 12, 31));

        return !selectedDate.isBefore(startDate) && !selectedDate.isAfter(endDate);
      })
          .toList()
        ..sort((a, b) {
          final aStart = a.programStartDate ?? DateTime(9999, 12, 31);
          final bStart = b.programStartDate ?? DateTime(9999, 12, 31);

          // '종일' 조건 체크
          final isADayDifferent = a.programStartDate?.day != a.programEndDate?.day;
          final isBDayDifferent = b.programStartDate?.day != b.programEndDate?.day;

          if (isADayDifferent && !isBDayDifferent) return 1; // a는 종일, b는 아님
          if (!isADayDifferent && isBDayDifferent) return -1; // b는 종일, a는 아님
          if (isADayDifferent && isBDayDifferent) return 0; // 둘 다 종일

          // 둘 다 종일이 아니면 시작 시간을 기준으로 정렬
          return aStart.compareTo(bStart);
        });
    });
  }

  /// UseCase5. 특정 날짜에 해당하는 모든 프로그램을 Map 형식으로 변환
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
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
          groupedPrograms.putIfAbsent(date, () => []);
          groupedPrograms[date]!.add(program);
        }
      }
      return groupedPrograms;
    });
  }

  /// UseCase6. 등록 종료일이 임박한 프로그램 필터링 (오늘 날짜와 가까운 순으로 정렬)
  Stream<List<ProgramModel>> getCTAPrograms() {
    return repository.getPrograms().map((programs) {
      // 오늘 날짜와 일주일 후 날짜를 계산
      final today = DateTime.now();
      final oneWeekLater = today.add(Duration(days: 7));

      // 등록 마감일이 오늘로부터 일주일 이내인 프로그램들만 필터링
      final filteredPrograms = programs.where((program) {
        final registrationEndDate = program.registrationEndDate;
        // registrationEndDate가 null인 경우를 처리하기 위해 null 체크
        if (registrationEndDate == null) {
          return false; // null이면 제외
        }
        // 등록 마감일이 오늘부터 일주일 이내인지를 체크
        return registrationEndDate.isAfter(today) && registrationEndDate.isBefore(oneWeekLater);
      }).toList();

      // 일주일 이내 마감일을 가진 프로그램들 정렬
      filteredPrograms.sort((a, b) => a.registrationEndDate!.compareTo(b.registrationEndDate!));

      return filteredPrograms;
    });
  }

  /// UseCase7. 프로그램의 hits 수에 따른 정렬
  Stream<List<ProgramModel>> getProgramsSortedByHits() {
    return repository.getPrograms().map((programs) {
      // hits 값을 기준으로 내림차순 정렬
      programs.sort((a, b) => b.hits.compareTo(a.hits));
      return programs;
    });
  }

  /// update1. program hits increment
  Future<void> incrementProgramHits(ProgramModel program) {
    return repository.updateHits(program.documentId!, program.hits);
  }
}