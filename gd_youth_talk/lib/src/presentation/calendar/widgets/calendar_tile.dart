import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:intl/intl.dart';
import 'package:gd_youth_talk/src/core/utils.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile({
    super.key,
    required this.program,
    required this.onTap,
    required this.isExpired,
    required this.targetDate,
  });

  final ProgramModel program;
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final bool isExpired;
  final DateTime targetDate; // 📅 선택된 날짜

  @override
  Widget build(BuildContext context) {

    // 카테고리 to rawvalue
    final CategoryType? category =
    program.category != null ? CategoryTypeExtension.fromName(program.category!) : null;

    // 기본 색상 설정: 카테고리 값이 없을 때 사용할 기본 색상
    final Color backgroundColor = isExpired ? Colors.black12 : category?.color ?? Colors.grey;

    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5), // 코너 레디우스 설정
        ),
        child: ListTile(
          title: Text(
            program.title ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: getTextColorBasedOnCategory(backgroundColor),
            )
          ),

          subtitle: Text(
            _getFormattedTimeForDate(program.programDates, targetDate),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: getTextColorBasedOnCategory(backgroundColor),
            ),
          ),
          trailing: isExpired
              ? const Text(
                  '종료',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          onTap: () {
           onTap?.call(program);
          },
        ),
      ),
    );
  }

  String _getFormattedTimeForDate(List<DateTime>? programDates, DateTime targetDate) {
    if (programDates == null || programDates.isEmpty) return '';

    // 현재 날짜와 일치하는 programDate 리스트 추출
    List<DateTime> filteredDates = programDates.where((date) =>
    date.year == targetDate.year &&
        date.month == targetDate.month &&
        date.day == targetDate.day).toList();

    if (filteredDates.isEmpty) return '';

    // 가장 이른 시간 선택 후 HH:mm 형식으로 변환
    filteredDates.sort((a, b) => a.compareTo(b));
    return DateFormat('HH:mm').format(filteredDates.first);
  }

}
