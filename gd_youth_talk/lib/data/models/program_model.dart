import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramModel {
  final String? category;
  final String? title;
  final String? subtitle;
  final String? location;
  final String? blogUrl;
  final String? detail;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? lastModified;
  final String? thumbnail;

  ProgramModel({
    this.category,
    this.title,
    this.subtitle,
    this.location,
    this.blogUrl,
    this.detail,
    this.startDate,
    this.endDate,
    this.lastModified,
    this.thumbnail,
  });

  // Firebase의 json 형식을 Model 객체로 변환
  factory ProgramModel.fromFirebase(Map<String, dynamic> data) {
    return ProgramModel(
      category: data['category'] as String?,
      title: data['title'] as String?,
      subtitle: data['subtitle'] as String?,
      location: data['location'] as String?,
      blogUrl: data['blogUrl'] as String?,
      detail: data['detail'] as String?,
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      lastModified: (data['lastModified'] as Timestamp?)?.toDate(),
      thumbnail: data['thumbnail'] as String?,
    );
  }
}