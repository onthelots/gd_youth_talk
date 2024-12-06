import 'package:flutter/material.dart';
import 'dart:math';

// 더미 아이템

// CategoryItem에 새로운 속성 추가
class CategoryItem {
  final String title;
  final String description;
  final String thumbnailUrl;
  final DateTime date;
  final String time;
  final String location;

  CategoryItem({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.date,
    required this.time,
    required this.location,
  });

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'] ?? '',
      location: map['location'] ?? '',
    );
  }
}

class Category {
  final String name;
  final List<CategoryItem> items;

  Category({required this.name, required this.items});

  factory Category.fromMap(String name, Map<String, dynamic> map) {
    return Category(
      name: name,
      items: (map['items'] as List)
          .map((item) => CategoryItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}


// 더미 아이템 데이터에 추가된 속성 반영
final Map<String, dynamic> categoryData = {
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

List<Category> parseCategoryData(Map<String, dynamic> data) {
  return data.entries
      .map((entry) => Category.fromMap(entry.key, entry.value))
      .toList();
}

