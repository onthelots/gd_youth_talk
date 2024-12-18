import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramModel {
  final String? category;
  final String? title;
  final String? subtitle;
  final String? location;
  final String? blogUrl;
  final String? detail;
  final DateTime? programStartDate;
  final DateTime? programEndDate;
  final DateTime? registrationStartDate;
  final DateTime? registrationEndDate;
  final DateTime? lastModified;
  final String? thumbnail;
  final String? primaryColor;

  ProgramModel({
    this.category,
    this.title,
    this.subtitle,
    this.location,
    this.blogUrl,
    this.detail,
    this.programStartDate,
    this.programEndDate,
    this.registrationStartDate,
    this.registrationEndDate,
    this.lastModified,
    this.thumbnail,
    this.primaryColor,
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
      programStartDate: (data['programStartDate'] as Timestamp?)?.toDate(),
      programEndDate: (data['programEndDate'] as Timestamp?)?.toDate(),
      registrationStartDate: (data['RegistrationStartDate'] as Timestamp?)?.toDate(),
      registrationEndDate: (data['RegistrationEndDate'] as Timestamp?)?.toDate(),
      lastModified: (data['lastModified'] as Timestamp?)?.toDate(),
      thumbnail: data['thumbnail'] as String?,
      primaryColor: data['primaryColor'] as String?,
    );
  }
}