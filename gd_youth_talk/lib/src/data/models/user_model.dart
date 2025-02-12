import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? documentId; // Firestore 문서 ID
  final String? email;
  final String? nickname;
  final int? visitCount;
  final DateTime? lastVisitDate;
  final DateTime? registrationDate;
  final bool? isEmailVerified;
  final bool? isPasswordVerified;

  UserModel({
    this.documentId,
    this.email,
    this.nickname,
    this.visitCount,
    this.lastVisitDate,
    this.registrationDate,
    this.isEmailVerified,
    this.isPasswordVerified,
  });

  factory UserModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      documentId: doc.id,
      email: data['email'] as String?,
      nickname: data['nickname'] as String?,
      visitCount: (data['visitCount'] ?? 0) as int,
      lastVisitDate: (data['lastVisitDate'] as Timestamp?)?.toDate(),
      registrationDate:(data['registrationDate'] as Timestamp?)?.toDate(),
      isEmailVerified: data['isEmailVerified'] as bool?,
      isPasswordVerified: data['isPasswordVerified'] as bool?,
    );
  }

  UserModel copyWith({
    String? documentId,
    String? email,
    String? nickname,
    int? visitCount,
    DateTime? lastVisitDate,
    DateTime? registrationDate,
    bool? isEmailVerified,
    bool? isPasswordVerified,
  }) {
    return UserModel(
      documentId: documentId ?? this.documentId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      visitCount: visitCount ?? this.visitCount,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      registrationDate: registrationDate ?? this.registrationDate,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPasswordVerified: isPasswordVerified ?? this.isPasswordVerified,
    );
  }
}