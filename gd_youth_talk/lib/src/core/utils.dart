import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// From Hex
Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', ''); // #을 제거
  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor; // 앞에 0xFF 추가
  }
  return Color(int.parse('0x$hexColor')); // 16진수로 변환하여 Color로 리턴
}

/// 배경색 기반 텍스트 색상
Color getTextColorBasedOnBackground(String hexColor) {
  Color backgroundColor = getColorFromHex(hexColor);  // String 형식의 hex 색상 값을 Color로 변환
  // 배경 색상의 명도를 계산합니다.
  double luminance = backgroundColor.computeLuminance();

  // 명도가 0.5보다 크면 어두운 배경이므로 흰색 텍스트를, 그 이하면 검정색 텍스트를 반환
  return luminance > 0.5 ? Colors.black : Colors.white;
}

Color getTextColorBasedOnCategory(Color backgroundColor) {
  // 배경 색상의 명도를 계산합니다.
  double luminance = backgroundColor.computeLuminance();

  // 명도가 0.5보다 크면 어두운 배경이므로 흰색 텍스트를, 그 이하면 검정색 텍스트를 반환
  return luminance > 0.5 ? Colors.black : Colors.white;
}


String formatDate(DateTime date) {
  return DateFormat('yyyy.MM.dd').format(date);
}

String formatTimeRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) return "시간 정보 없음";

  final DateFormat formatter = DateFormat('a hh:mm', 'ko_KR'); // 'ko_KR'로 오전/오후 표시
  final String startFormatted = formatter.format(start).replaceFirst('AM', '오전').replaceFirst('PM', '오후');
  final String endFormatted = formatter.format(end).replaceFirst('AM', '오전').replaceFirst('PM', '오후');
  return "$startFormatted - $endFormatted";
}

// (v1.0.2) 프로그램 날짜 변환 (기간)
String formatDateRange(List<DateTime> programDates) {
  if (programDates.isEmpty) return '';

  programDates.sort(); // 날짜 오름차순 정렬

  // 만약 날짜가 한 개이면 그 날짜만 반환
  if (programDates.length == 1) {
    return DateFormat('yyyy.MM.dd').format(programDates.first);
  }

  // 날짜가 두 개 이상이면 범위 표시
  DateTime startDate = programDates.first;
  DateTime endDate = programDates.last;

  if (startDate.isAtSameMomentAs(endDate)) {
    return DateFormat('yyyy.MM.dd').format(startDate);
  }

  return '${DateFormat('yyyy.MM.dd').format(startDate)} ~ ${DateFormat('yyyy.MM.dd').format(endDate)}';
}

