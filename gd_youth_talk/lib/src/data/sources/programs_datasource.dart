import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramDataSource {
  final FirebaseFirestore _firestore;

  ProgramDataSource(this._firestore);

  /// firebase data read - Future!
  // Future<List<ProgramModel>> fetchPrograms() async {
  //   final snapshot = await _firestore.collection('programs').get();
  //   return snapshot.docs.map((doc) => ProgramModel.fromFirebase(doc)).toList();
  // }

  /// firebase data read - Stream!
  Stream<List<ProgramModel>> fetchPrograms() {
    final today = DateTime.now();
    return _firestore.collection('programs').snapshots().map((snapshot) {
      // 필터링: programEndDate가 오늘보다 이전인 프로그램을 제외
      return snapshot.docs
          .map((doc) => ProgramModel.fromFirebase(doc))
          .where((program) => program.programEndDate == null || program.programEndDate!.isAfter(today))
          .toList();
    });
  }

  /// hits update
  Future<void> updateHits(String documentId, int currentHits) async {
    await _firestore
        .collection('programs')
        .doc(documentId)
        .update({'hits': currentHits + 1});
  }
}