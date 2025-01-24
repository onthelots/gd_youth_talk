import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsersDataSource(this._firestore, this._auth);

  /// 회원가입
  Future<void> signUpWithEmailPassword(String email, String password, String nickname) async {
    try {
      // 1. 회원가입
      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // 2. 내 정보 받아오기 (auth)
      final user = authResult.user;

      // 3. Firestore에 사용자 정보 저장
      if (user != null) {

        // 3.1. Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(user.uid).set({
          'documentId' : user.uid,
          'email': email,
          'nickname': nickname,
          'visitCount': 0,
          'lastVisitDate': null,
          'registrationDate': DateTime.now(),
          'isEmailVerified': false,
        });

      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// 인증메일 보내기
  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  /// 메일 인증 확인 후 업데이트
  Future<bool> verifyEmail(User user) async {
    try {
      // 이메일 인증 상태가 완료되었는지 확인

      print('인증상태 확인중 ... ${user.emailVerified}');

      while (!user.emailVerified) {
        // 인증이 완료될 때까지 대기 (3초마다 확인)
        await Future.delayed(Duration(seconds: 3));

        // 사용자 정보를 새로 고침하여 인증 상태를 업데이트
        await user.reload();
        user = FirebaseAuth.instance.currentUser!;  // 혹은 필요한 방법으로 user 객체를 갱신
      }

      // 이메일 인증이 완료되면 Firestore에 isEmailVerified 값을 true로 업데이트
      await _firestore.collection('users').doc(user.uid).update({
        'isEmailVerified': true,
      });

      print('Email verified, sign up complete!');
      return true;
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  /// 로그인
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;
      if (user != null) {
        return await getUserInfo(user.uid);
      } else {
        throw Exception('Authentication failed');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  /// 탈퇴
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// 내 정보 받아오기
  Future<UserModel> getUserInfo(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromFirebase(userDoc);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  /// 닉네임 변경
  Future<void> updateNickname(String userId, String newNickname) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'nickname': newNickname,
      });
    } catch (e) {
      throw Exception('Failed to update nickname: $e');
    }
  }
}