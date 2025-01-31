import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? documentId; // Firestore 문서 ID
  final String? email;
  final String? nickname;
  final int? visitCount;
  final DateTime? lastVisitDate;
  final DateTime? registrationDate;
  final bool? isEmailVerified;

  UserModel({
    this.documentId,
    this.email,
    this.nickname,
    this.visitCount,
    this.lastVisitDate,
    this.registrationDate,
    this.isEmailVerified
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
    );
  }
}