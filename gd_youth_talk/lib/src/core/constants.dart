import 'package:flutter/material.dart';

/// App Colors
class AppColors {
  // Light Mode Colors
  static const Color lightPrimary = Color(0xff2B9A87);
  static const Color lightAccent = Color(0xffF4C542);
  static const Color lightBackground = Color(0xffF5F5F5);
  static const Color lightText = Color(0xff333333);
  static const Color lightIcon = Color(0xff606060);
  static const Color lightActiveButton = Color(0xff009B80);
  static const Color lightInactiveButton = Color(0xffB0B0B0);
  static const Color lightActiveButtonText = Color(0xffffffff);
  static const Color lightInactiveButtonText = Color(0xffB0B0B0);
  static const Color lightCategoryButton = Color(0xffefefef);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xff1F716A);
  static const Color darkAccent = Color(0xffD9A62A);
  static const Color darkBackground = Color(0xff1A1A1A);
  static const Color darkText = Color(0xffe0e0e0);
  static const Color darkIcon = Color(0xffe0e0e0);
  static const Color darkActiveButton = Color(0xff007B63);
  static const Color darkInactiveButton = Color(0xff3A3A3A);
  static const Color darkActiveButtonText = Color(0xffffffff);
  static const Color darkInactiveButtonText = Color(0xffB0B0B0);
  static const Color darkCategoryButton = Color(0xff3A3A3A);

// Category Colors
  static const Color cultureArt = Color(0xff4CA399); //
  static const Color selfDevelopment = Color(0xff007D63); //
  static const Color educationLecture = Color(0xffF4C542); //
  static const Color event = Color(0xffD96724); //
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

  // displayName을 기반으로, 역으로 타입이름 반환
  static CategoryType fromName(String name) {
    switch (name) {
      case '문화예술':
        return CategoryType.cultureArt;
      case '자기계발':
        return CategoryType.selfDevelopment;
      case '교육강연':
        return CategoryType.educationLecture;
      case '이벤트':
        return CategoryType.event;
      default:
        throw ArgumentError('Invalid category name: $name');
    }
  }

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

  // 각 카테고리에 맞는 아이콘 설정
  IconData get icon {
    switch (this) {
      case CategoryType.cultureArt:
        return Icons.theaters;
      case CategoryType.selfDevelopment:
        return Icons.self_improvement;
      case CategoryType.educationLecture:
        return Icons.school;
      case CategoryType.event:
        return Icons.event;
    }
  }

  // 카테고리별 메인 색상
  Color get color {
    switch (this) {
      case CategoryType.cultureArt:
        return AppColors.cultureArt;
      case CategoryType.selfDevelopment:
        return  AppColors.selfDevelopment;
      case CategoryType.educationLecture:
        return  AppColors.educationLecture;
      case CategoryType.event:
        return  AppColors.event;
    }
  }
}

/// Firebase Collection 명칭
class FirebaseOption {
  static const String programCollection = 'programs';
}

/// HomeScreen 섹션 타이틀
String sectionTitle1 = "지금, 청년들이 눈여겨 본 활동은?";
String sectionTitle2 = "참여 신청 마감 임박!";