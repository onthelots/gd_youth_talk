import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';

/// Programs Data
class Programs {
  final String categoryName; // 카테고리
  final List<Program> items; // 카테고리 내 프로그램들

  Programs({required this.categoryName, required this.items});

  // factory constructor로 변환 -> programs인데, items와
  factory Programs.fromMap(String categoryName, Map<String, dynamic> map) {
    return Programs(
      categoryName: categoryName,
      items: (map['items'] as List)
          .map((item) => Program.fromMap(item as Map<String, dynamic>, categoryName))
          .toList(),
    );
  }
}

// CategoryItem에 새로운 속성 추가
class Program {
  final CategoryType category; // 카테고리 타입 추가
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailUrl;
  final DateTime date;
  final String time;
  final String location;

  Program({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnailUrl,
    required this.date,
    required this.time,
    required this.location,
  });

  // factory : 해당 생성자(Constructor)는 기존 객체나 캐싱된 객체를 반환할 수 있습니다.
  factory Program.fromMap(Map<String, dynamic> map, String categoryName) {
    return Program(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      category: _categoryTypeFromString(categoryName), // 변환된 카테고리 타입
    );
  }

  static CategoryType _categoryTypeFromString(String displayName) {
    return CategoryType.values.firstWhere(
          (type) => type.name == displayName, // displayName과 매칭
      orElse: () => throw ArgumentError('Unknown category display name: $displayName'),
    );
  }

  // 전역적으로 날짜를 포맷하는 메서드
  String formatDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}

enum CategoryType {
  healthAndWellbeing,
  selfDevelopment,
  cultureAndHobbies,
  lecturesAndForums,
}

extension CategoryTypeExtension on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.healthAndWellbeing:
        return '건강&웰빙';
      case CategoryType.selfDevelopment:
        return '자기계발';
      case CategoryType.cultureAndHobbies:
        return '문화&취미';
      case CategoryType.lecturesAndForums:
        return '강연&포럼';
    }
  }

  IconData get icon {
    switch (this) {
      case CategoryType.healthAndWellbeing:
        return Icons.volunteer_activism;
      case CategoryType.selfDevelopment:
        return Icons.psychology;
      case CategoryType.cultureAndHobbies:
        return Icons.palette;
      case CategoryType.lecturesAndForums:
        return Icons.local_library;
      default:
        return Icons.help_outline;
    }
  }
}

/// Dummy Data
final Map<String, dynamic> programData = {
  "healthAndWellbeing": {
    "items": [
      {
        "title": "건강한 습관을 통해 더 나은 삶을 위한 실천 방법",
        "subtitle": "건강을 위한 생활 습관과 이를 지속적으로 유지하는 방법을 배워보세요.",
        "description": "우리의 건강은 일상에서 우리가 선택하는 작은 습관들에 의해 결정됩니다. 이 프로그램은 건강한 식습관, 규칙적인 운동, 정신적인 안정을 위한 다양한 방법을 제시합니다. 특히, 스트레스를 관리하고 면역력을 높이는 방법, 그리고 수면의 중요성에 대해 심층적으로 다루며, 꾸준히 건강한 습관을 유지할 수 있는 실용적인 팁을 제공합니다. 또한, 이를 생활에 적용하기 위한 동기 부여와 지속 가능한 실천 전략도 함께 소개됩니다.",
        "thumbnailUrl": "https://picsum.photos/id/100/200/300",
        "date": "2024-12-06T00:00:00Z",
        "time": "10:00",
        "location": "서울시 강남구",
      },
      {
        "title": "몸과 마음을 단련하는 다양한 피트니스 운동 소개",
        "subtitle": "신체뿐만 아니라 정신도 강화할 수 있는 다양한 운동 루틴을 배워보세요.",
        "description": "몸과 마음을 동시에 단련할 수 있는 다양한 피트니스 운동들을 소개하는 이 프로그램은, 각기 다른 운동의 효과와 이를 일상에 어떻게 통합할 수 있을지에 대해 자세히 설명합니다. 요가, 필라테스, 고강도 인터벌 훈련(HIIT) 등의 운동법을 통해 스트레스 해소와 체력 강화를 동시에 추구할 수 있는 방법을 알려드립니다. 또한, 각 운동의 과학적 근거를 설명하며, 운동 루틴을 유지할 수 있는 실천적 조언도 제공합니다. 마음의 건강을 위한 명상과 호흡법도 함께 배울 수 있는 기회를 제공합니다.",
        "thumbnailUrl": "https://picsum.photos/id/101/200/300",
        "date": "2024-12-07T00:00:00Z",
        "time": "14:00",
        "location": "서울시 마포구",
      },
      {
        "title": "헬스케어를 위한 최신 정보와 꿀팁",
        "subtitle": "헬스케어의 최신 트렌드와 유용한 팁을 얻어보세요.",
        "description": "현대인의 건강을 유지하는 데 필요한 최신 정보와 유용한 헬스케어 팁들을 이 프로그램에서 제공합니다. 영양, 운동, 스트레스 관리, 그리고 최신 헬스케어 기술에 이르기까지 다양한 주제를 다루며, 건강을 지키기 위한 혁신적인 방법들을 소개합니다. 예를 들어, 스마트 디바이스를 활용한 건강 관리법, 최신 연구에 기반한 식단 추천, 그리고 예방적 건강 관리 방법 등을 배우게 됩니다. 또한, 각종 질병을 예방하고, 건강 상태를 실시간으로 모니터링할 수 있는 헬스케어 앱과 서비스도 소개됩니다.",
        "thumbnailUrl": "https://picsum.photos/id/102/200/300",
        "date": "2024-12-08T00:00:00Z",
        "time": "11:00",
        "location": "서울시 종로구",
      },
    ],
  },
  "selfDevelopment": {
    "items": [
      {
        "title": "삶의 질을 높여주는 자기계발서 추천 및 활용법",
        "subtitle": "자기계발서를 통해 성장할 수 있는 방법을 알려드립니다.",
        "description": "자기계발서들은 우리의 삶을 더욱 의미 있게 만드는 지침서 역할을 합니다. 이 프로그램에서는 자기계발서 중에서도 특히 삶의 질을 높이는 데 도움이 되는 필수적인 책들을 추천하고, 각 책에서 다루는 핵심 내용을 심층적으로 분석합니다. 이와 함께, 책을 단순히 읽는 것을 넘어, 실제로 삶에 적용하여 더 나은 변화를 이끌어낼 수 있는 방법을 제시합니다. 또한, 독서 후 실천 계획을 세우는 방법과, 지속적으로 자기계발을 이어나갈 수 있는 동기 부여 방법도 다룹니다.",
        "thumbnailUrl": "https://picsum.photos/id/103/200/300",
        "date": "2024-12-10T00:00:00Z",
        "time": "09:00",
        "location": "서울시 용산구",
      },
      {
        "title": "온라인 강의를 통해 배우는 자기계발의 모든 것",
        "subtitle": "온라인 강의를 통해 시간과 장소에 구애받지 않고 성장할 수 있는 방법을 배워보세요.",
        "description": "자기계발을 위한 온라인 강의는 시간과 장소에 구애받지 않고 누구나 쉽게 접근할 수 있는 교육 자원입니다. 이 프로그램에서는 다양한 자기계발 분야의 온라인 강의를 추천하며, 각 강의가 제공하는 고유의 가치와 학습 방법을 소개합니다. 또한, 온라인 강의를 최대한 활용할 수 있는 팁과 전략을 제공하여, 자기계발의 목표를 더욱 효과적으로 달성할 수 있도록 돕습니다. 강의를 통해 얻은 지식을 실제 삶에 어떻게 적용할 수 있는지에 대해서도 구체적인 예시를 들어 설명합니다.",
        "thumbnailUrl": "https://picsum.photos/id/104/200/300",
        "date": "2024-12-11T00:00:00Z",
        "time": "13:00",
        "location": "서울시 동작구",
      },
    ],
  },
  "cultureAndHobbies": {
    "items": [
      {
        "title": "여가 시간에 즐길 수 있는 다양한 취미 활동",
        "subtitle": "여가 시간을 활용해 새로운 취미를 시작하고 즐겨보세요.",
        "description": "여가 시간에 즐길 수 있는 취미 활동은 삶의 질을 높이는 중요한 요소입니다. 이 프로그램에서는 취미 활동을 시작하는 방법과 이를 즐기는 데 필요한 다양한 팁을 제공합니다. 예술, 음악, DIY, 요리 등 다양한 분야의 취미를 소개하고, 각 취미 활동을 통해 얻을 수 있는 정신적, 신체적 이점도 설명합니다. 또한, 취미를 시작하기 위한 준비물과 시간 관리 방법을 제시하여, 누구나 쉽게 자신의 취미를 생활에 통합할 수 있도록 돕습니다.",
        "thumbnailUrl": "https://picsum.photos/id/107/200/300",
        "date": "2024-12-12T00:00:00Z",
        "time": "08:00",
        "location": "서울시 노원구",
      },
      {
        "title": "영화 애호가들을 위한 최신 추천 영화 리스트",
        "subtitle": "영화 애호가라면 반드시 봐야 할 최신 영화들을 추천합니다.",
        "description": "영화 애호가들을 위해 최신 추천 영화를 소개하는 이 프로그램에서는 각 영화의 줄거리, 주요 배우, 그리고 감상 포인트를 상세히 다룹니다. 최신 영화뿐만 아니라, 영화의 감독이나 작가가 전하는 메시지와 영화가 가진 사회적, 문화적 의미에 대해서도 심도 깊게 분석합니다. 영화 팬들이 놓쳐서는 안 될 필수 영화를 엄선하여, 영화를 감상하는 데 있어 보다 풍성한 경험을 제공하는 것이 이 프로그램의 목표입니다.",
        "thumbnailUrl": "https://picsum.photos/id/106/200/300",
        "date": "2024-12-13T00:00:00Z",
        "time": "19:00",
        "location": "서울시 강서구",
      },
    ],
  },
  "lecturesAndForums": {
    "items": [
      {
        "title": "각 분야 전문가가 전하는 유익한 강연 모음",
        "subtitle": "다양한 분야의 전문가들로부터 실용적인 지식과 통찰을 얻어보세요.",
        "description": "이 프로그램은 다양한 분야에서 활동하는 전문가들이 전하는 유익한 강연을 통해, 참가자들이 전문적인 지식과 경험을 직접 들을 수 있는 기회를 제공합니다. 각 분야의 최신 동향, 혁신적인 아이디어, 그리고 업계에서 중요하게 다루어지는 문제들에 대해 심층적으로 다룹니다. 또한, 강연 후에는 질의응답 시간을 통해 강연자와 직접 소통할 수 있는 기회도 제공되어, 참가자들이 실질적인 조언을 받을 수 있습니다.",
        "thumbnailUrl": "https://picsum.photos/id/107/200/300",
        "date": "2024-12-14T00:00:00Z",
        "time": "10:00",
        "location": "서울시 강남구",
      },
      {
        "title": "지식과 아이디어를 나누는 유익한 포럼 참여",
        "subtitle": "다양한 관점에서 문제를 이해하고 해결 방안을 모색해보세요.",
        "description": "이 포럼은 참가자들이 각기 다른 분야의 전문가와 함께 다양한 사회적, 경제적 문제를 논의하고 해결 방안을 모색하는 자리입니다. 포럼에서는 최신 연구 결과와 실제 사례를 바탕으로 토론을 진행하며, 다양한 관점에서 문제를 바라볼 수 있는 기회를 제공합니다. 참가자들은 서로의 아이디어를 공유하고, 협력하여 새로운 솔루션을 제시할 수 있습니다. 이는 비즈니스, 기술, 사회적 이슈 등 다양한 주제를 다루며, 참가자들에게 깊은 통찰력을 제공합니다.",
        "thumbnailUrl": "https://picsum.photos/id/108/200/300",
        "date": "2024-12-15T00:00:00Z",
        "time": "15:00",
        "location": "서울시 마포구",
      },
    ],
  },
};

