import 'package:flutter/material.dart';
import 'dart:math';

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
  final String description;
  final String thumbnailUrl;
  final DateTime date;
  final String time;
  final String location;

  Program({
    required this.category,
    required this.title,
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
        "title": "건강한 습관",
        "description": "건강을 위한 습관들",
        "thumbnailUrl": "https://picsum.photos/id/100/200/300", // 랜덤 ID
        "date": "2024-12-06T00:00:00Z",
        "time": "10:00",
        "location": "서울시 강남구",
      },
      {
        "title": "피트니스",
        "description": "몸을 단련하는 다양한 운동",
        "thumbnailUrl": "https://picsum.photos/id/101/200/300", // 랜덤 ID
        "date": "2024-12-07T00:00:00Z",
        "time": "14:00",
        "location": "서울시 마포구",
      },
      {
        "title": "헬스케어",
        "description": "헬스케어와 관련된 유용한 정보",
        "thumbnailUrl": "https://picsum.photos/id/102/200/300", // 랜덤 ID
        "date": "2024-12-08T00:00:00Z",
        "time": "11:00",
        "location": "서울시 종로구",
      },
    ],
  },
  "selfDevelopment": {
    "items": [
      {
        "title": "자기계발서",
        "description": "자기계발을 위한 책 추천",
        "thumbnailUrl": "https://picsum.photos/id/103/200/300", // 랜덤 ID
        "date": "2024-12-10T00:00:00Z",
        "time": "09:00",
        "location": "서울시 용산구",
      },
      {
        "title": "온라인 강의",
        "description": "자기계발을 위한 강의",
        "thumbnailUrl": "https://picsum.photos/id/104/200/300", // 랜덤 ID
        "date": "2024-12-11T00:00:00Z",
        "time": "13:00",
        "location": "서울시 동작구",
      },
    ],
  },
  "cultureAndHobbies": {
    "items": [
      {
        "title": "취미 활동",
        "description": "여가 시간에 즐길 수 있는 취미",
        "thumbnailUrl": "https://picsum.photos/id/107/200/300", // 랜덤 ID
        "date": "2024-12-12T00:00:00Z",
        "time": "08:00",
        "location": "서울시 노원구",
      },
      {
        "title": "영화",
        "description": "추천 영화 리스트",
        "thumbnailUrl": "https://picsum.photos/id/106/200/300", // 랜덤 ID
        "date": "2024-12-13T00:00:00Z",
        "time": "19:00",
        "location": "서울시 강서구",
      },
    ],
  },
  "lecturesAndForums": {
    "items": [
      {
        "title": "강연",
        "description": "다양한 분야의 강연",
        "thumbnailUrl": "https://picsum.photos/id/107/200/300", // 랜덤 ID
        "date": "2024-12-14T00:00:00Z",
        "time": "10:00",
        "location": "서울시 강남구",
      },
      {
        "title": "포럼",
        "description": "유익한 포럼 모음",
        "thumbnailUrl": "https://picsum.photos/id/108/200/300", // 랜덤 ID
        "date": "2024-12-15T00:00:00Z",
        "time": "15:00",
        "location": "서울시 마포구",
      },
    ],
  },
};