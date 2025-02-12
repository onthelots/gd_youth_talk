import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramModel {
  final String? documentId;
  final String? category;
  final String? title;
  final String? subtitle;
  final String? location;
  final String? blogUrl;
  final String? detail;
  final List<DateTime>? programDates;
  final DateTime? registrationEndDate;
  final DateTime? lastModified;
  final String? thumbnail;
  final String? primaryColor;
  final int hits;

  ProgramModel({
    this.documentId,
    this.category,
    this.title,
    this.subtitle,
    this.location,
    this.blogUrl,
    this.detail,
    this.programDates,
    this.registrationEndDate,
    this.lastModified,
    this.thumbnail,
    this.primaryColor,
    this.hits = 0,
  });

  factory ProgramModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgramModel(
      documentId: doc.id,
      category: data['category'] as String?,
      title: data['title'] as String?,
      subtitle: data['subtitle'] as String?,
      location: data['location'] as String?,
      blogUrl: data['blogUrl'] as String?,
      detail: data['detail'] as String?,
      programDates: (data['programDates'] as List<dynamic>?)?.map((timestamp) => (timestamp as Timestamp).toDate()).toList(), // 변경된 부분
      registrationEndDate: (data['registrationEndDate'] as Timestamp?)?.toDate(),
      lastModified: (data['lastModified'] as Timestamp?)?.toDate(),
      thumbnail: data['thumbnail'] as String?,
      primaryColor: data['primaryColor'] as String?,
      hits: (data['hits'] ?? 0) as int,
    );
  }
}