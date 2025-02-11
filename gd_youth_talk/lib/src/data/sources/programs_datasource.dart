import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramDataSource {
  final FirebaseFirestore _firestore;

  ProgramDataSource(this._firestore);

  /// firebase data read - Stream!
  Stream<List<ProgramModel>> fetchPrograms() {
    final now = DateTime.now();

    return _firestore.collection('programs').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProgramModel.fromFirebase(doc))
          .where((program) {
        // 프로그램의 마지막 날짜를 찾기 전에 날짜를 정렬
        final sortedDates = program.programDates?..sort();

        // 정렬된 후 가장 마지막 날짜를 가져오기 (가장 늦은 날짜)
        final lastProgramDate = sortedDates?.last;

        // 마지막 날짜가 null이 아니고, 현재 날짜와 시간을 기준으로 아직 진행 중인 프로그램만 필터링
        return lastProgramDate != null && lastProgramDate.isAfter(now);
      })
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