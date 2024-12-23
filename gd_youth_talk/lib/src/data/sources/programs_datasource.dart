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
      return _firestore.collection('programs').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => ProgramModel.fromFirebase(doc)).toList();
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