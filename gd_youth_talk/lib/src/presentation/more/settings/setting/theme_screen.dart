import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_state.dart';

class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text(
          '기본 테마 설정',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final currentThemeMode = (state is ThemeInitial) ? state.themeMode : ThemeMode.system;

          return ListView(
            children: [
              ListTile(
                title: Text(
                  '시스템 모드',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: currentThemeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(ThemeChanged(themeMode: value));
                    }
                  },
                  activeColor: Theme.of(context).primaryColor, // 선택된 라디오 버튼 색상
                ),
                onTap: () {
                  context.read<ThemeBloc>().add(ThemeChanged(themeMode: ThemeMode.system));
                },
              ),
              ListTile(
                title: Text(
                  '라이트 모드',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: currentThemeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(ThemeChanged(themeMode: value));
                    }
                  },
                  activeColor: Theme.of(context).primaryColor, // 선택된 라디오 버튼 색상
                ),
                onTap: () {
                  context.read<ThemeBloc>().add(ThemeChanged(themeMode: ThemeMode.light));
                },
              ),
              ListTile(
                title: Text(
                  '다크 모드',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: currentThemeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(ThemeChanged(themeMode: value));
                    }
                  },
                  activeColor: Theme.of(context).primaryColor, // 선택된 라디오 버튼 색상
                ),
                onTap: () {
                  context.read<ThemeBloc>().add(ThemeChanged(themeMode: ThemeMode.dark));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
