import 'package:flutter/material.dart';
import 'package:gd_youth_talk/core/constants.dart';

/// AppTheme
class AppTheme {

  // Light_Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary, // 주요색상
    scaffoldBackgroundColor: AppColors.lightBackground, // 백그라운드 색상

    // - text
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.lightText, fontSize: 32),
      bodyLarge: TextStyle(color: AppColors.lightText, fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.lightText, fontSize: 10),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground, // 탭바 배경색
      selectedItemColor: AppColors.lightActiveButton, // 선택된 아이콘 색
      unselectedItemColor: AppColors.lightInactiveButton, // 선택되지 않은 아이콘 색
      showUnselectedLabels: true, // 비선택된 아이템에 텍스트도 보이게

      selectedLabelStyle: TextStyle(
        color: AppColors.lightActiveButtonText, // 선택된 텍스트 색상
      ),

      unselectedLabelStyle: TextStyle(
        color: AppColors.lightInactiveButtonText, // 비선택된 텍스트 색상
      ),
    ),
  );


  // Dark_Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,

    // - text
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkText, fontSize: 32),
      bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.darkText, fontSize: 10),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground, // 탭바 배경색
      selectedItemColor: AppColors.darkActiveButton, // 선택된 아이콘 색
      unselectedItemColor: AppColors.darkInactiveButton, // 선택되지 않은 아이콘 색
      showUnselectedLabels: true, // 비선택된 아이템에 텍스트도 보이게
      selectedLabelStyle: TextStyle(
        color: AppColors.darkActiveButtonText, // 선택된 텍스트 색상
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColors.darkInactiveButtonText, // 비선택된 텍스트 색상
      ),
    ),
  );
}
