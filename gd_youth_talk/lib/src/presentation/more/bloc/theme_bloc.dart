import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/SharedPreferencesHelper.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial(themeMode: ThemeMode.system)) {
    on<ThemeChanged>((event, emit) {
      emit(ThemeInitial(themeMode: event.themeMode));
      // 테마 변경 시 SharedPreferences에 저장
      SharedPreferencesHelper.saveThemeMode(event.themeMode);
    });
  }
}
