import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramDataSource {
  final FirebaseFirestore _firestore;

  ProgramDataSource(this._firestore);

  /// 1. Programs data (Read)
  Stream<List<ProgramModel>> getProgramsStream() {
    return _firestore.collection('programs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProgramModel.fromFirebase(doc.data());
      }).toList();
    });
  }
}