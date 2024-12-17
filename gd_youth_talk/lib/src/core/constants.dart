import 'package:flutter/material.dart';

/// App Colors
class AppColors {
  // Light Mode Colors
  static const Color lightPrimary = Color(0xff009B80);
  static const Color lightAccent = Color(0xffF4C542);
  static const Color lightBackground = Color(0xffF7F7F7);
  static const Color lightText = Color(0xff333333);
  static const Color lightIcon = Color(0xff606060);
  static const Color lightActiveButton = Color(0xff009B80);
  static const Color lightInactiveButton = Color(0xffB0B0B0);
  static const Color lightActiveButtonText = Color(0xffffffff);
  static const Color lightInactiveButtonText = Color(0xffB0B0B0);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xff007B63);
  static const Color darkAccent = Color(0xffD9A62A);
  static const Color darkBackground = Color(0xff1A1A1A);
  static const Color darkText = Color(0xffe0e0e0);
  static const Color darkIcon = Color(0xffe0e0e0);
  static const Color darkActiveButton = Color(0xff007B63);
  static const Color darkInactiveButton = Color(0xff3A3A3A);
  static const Color darkActiveButtonText = Color(0xffffffff);
  static const Color darkInactiveButtonText = Color(0xffB0B0B0);
}

/// BottomNavigationBar
class CustomBottomNavigationBar {
  static List<BottomNavigationBarItem> bottomNavigationBarItem = const [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
  BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
  ];
}

/// WebView Routes
class WebRoutes {
  static const String introduce = 'https://youth.seoul.go.kr/orang/cntr/intro.do?key=2309210001&cntrId=CT00001';
  static const String instagram = 'https://www.instagram.com/syc_gangdong/#';
  static const String customerService  = 'https://pf.kakao.com/_GQxjUxb';
  static const String blog  = 'https://blog.naver.com/syc_gangdong';
  static const String coronation = 'https://yeyak.seoul.go.kr/web/reservation/selectReservView.do?rsv_svc_id=S231102155211165423';
  static const String location = 'https://map.naver.com/p/entry/place/1133065835?placePath=%2Fhome&c=15.00,0,0,0,dh';
  static const String termsOfUse = 'https://iosdevlime.tistory.com/';
  static const String openSource = 'https://iosdevlime.tistory.com/';
}

class MenuItem {
  final String menuTitle;
  final String route;
  final Widget? trailing;

  MenuItem({required this.menuTitle, required this.route, this.trailing});
}

enum CategoryType {
  cultureArt, // 문화예술
  selfDevelopment, // 자기개발
  educationLecture, // 교육강연
  event, // 이벤트
}

extension CategoryTypeExtension on CategoryType {
  // 카테고리의 이름을 표시할 때 사용할 displayName
  String get displayName {
    switch (this) {
      case CategoryType.cultureArt:
        return '문화예술';
      case CategoryType.selfDevelopment:
        return '자기계발';
      case CategoryType.educationLecture:
        return '교육강연';
      case CategoryType.event:
        return '이벤트';
    }
  }

  // 각 카테고리에 맞는 아이콘을 설정
  IconData get icon {
    switch (this) {
      case CategoryType.cultureArt:
        return Icons.theaters; // 예시로 연극 아이콘
      case CategoryType.selfDevelopment:
        return Icons.self_improvement; // 자기개발 아이콘
      case CategoryType.educationLecture:
        return Icons.school; // 교육 아이콘
      case CategoryType.event:
        return Icons.event; // 이벤트 아이콘
    }
  }
}

class FirebaseOption {
  static const String programCollection = 'programs';
}