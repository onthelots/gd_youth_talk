import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/recent_program/recent_program_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../presentation/more/bloc/recent_program/recent_program_event.dart';

class SharedPreferencesHelper {
  static const _themeKey = 'themeMode';

  // 테마 모드 저장
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeKey, mode.index);  // ThemeMode의 enum 값은 int로 저장됩니다.
  }

  static Future<void> saveRecentProgram(BuildContext context, String documentId) async {
    final prefs = await SharedPreferences.getInstance();
    final recentProgramIds = prefs.getStringList('recent_program_ids') ?? [];

    // 중복된 프로그램 ID가 없다면 저장
    if (!recentProgramIds.contains(documentId)) {
      recentProgramIds.add(documentId);
      await prefs.setStringList('recent_program_ids', recentProgramIds);
      // SharedPreferences 갱신 후 RecentProgramBloc에 이벤트 발행하여 화면 갱신
      context.read<RecentProgramBloc>().add(LoadRecentProgramsEvent());
    }
  }

  // 최근 본 프로그램 삭제
  static Future<void> deleteRecentProgram(BuildContext context, String documentId) async {
    final prefs = await SharedPreferences.getInstance();
    final recentProgramIds = prefs.getStringList('recent_program_ids') ?? [];

    // 삭제할 프로그램 ID가 존재하면 제거
    if (recentProgramIds.contains(documentId)) {
      recentProgramIds.remove(documentId);
      await prefs.setStringList('recent_program_ids', recentProgramIds);
      // SharedPreferences 갱신 후 RecentProgramBloc에 이벤트 발행하여 화면 갱신
      context.read<RecentProgramBloc>().add(LoadRecentProgramsEvent());
    }
  }

  // 저장된 최근 본 프로그램 ID들 가져오기
  Future<List<String>> getRecentProgramIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recent_program_ids') ?? [];
  }
}
