import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramDataSource {
  final FirebaseFirestore _firestore;

  ProgramDataSource(this._firestore);

  /// 1. Programs data 받아오기
  Stream<List<ProgramModel>> getProgramsStream() {
    return _firestore.collection('programs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProgramModel.fromFirebase(doc.data());
      }).toList();
    });
  }
}