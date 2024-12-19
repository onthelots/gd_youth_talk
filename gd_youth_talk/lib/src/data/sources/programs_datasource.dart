import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramDataSource {
  final FirebaseFirestore _firestore;

  ProgramDataSource(this._firestore);

  /// Programs data (Read)
  Stream<List<ProgramModel>> getProgramsStream() {
    final now = DateTime.now();
    return _firestore
        .collection('programs')
        .where('programEndDate', isGreaterThanOrEqualTo: now) // 프로그램 종료 시점이 경과했을 경우, 필터링을 실시함
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProgramModel.fromFirebase(doc.id, doc.data());
      }).toList();
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