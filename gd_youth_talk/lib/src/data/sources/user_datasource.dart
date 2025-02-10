import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_youth_talk/src/core/secure_storage_helper.dart';
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
          'isPasswordVerified': false, // 비밀번호 기입 여부 파악 (초기값 false)
          'isEmailVerified': false, // 이메일 인증여부 파악 (초기값 false)
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

  /// 비밀번호 변경
  Future<void> updatePasswordAfterSignUp(String newPassword) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);

        // 비밀번호 변경 완료 후, firstore 내 isPasswordVerified 값을 true로 변경
        await _firestore.collection('users').doc(user.uid).update({
          'isPasswordVerified': true,
        });
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  /// 로그인
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;

      if (user != null) {
        await SecureStorageHelper.saveUserCredentials(email, password); // secure_storage 저장
        final userDocRef = _firestore.collection('users').doc(user.uid);
        final userDoc = await userDocRef.get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data()!;
          bool isPasswordVerified = userData['isPasswordVerified'] ?? false;
          bool isEmailVerified = userData['isEmailVerified'] ?? false;

          // 이메일 인증 및 비밀번호 설정 여부 확인 후 업데이트
          if (!isPasswordVerified || !isEmailVerified) {
            await userDocRef.update({
              'isPasswordVerified': true,
              'isEmailVerified': true,
            });
          }
        }
        return await getCurrentUserInfo(currentUser: user); // 내 정보 불러오기
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
      await SecureStorageHelper.clearUserCredentials(); // secure_storage 삭제
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
        await SecureStorageHelper.clearUserCredentials(); // secure_storage 삭제
        await _firestore.collection('users').doc(user.uid).delete(); // firestore 내 삭제
        await user.delete(); // auth 내 삭제
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// 내 정보 받아오기
  Future<UserModel> getCurrentUserInfo({required User currentUser}) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirebase(userDoc);
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Failed to load user info: $e');
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

  // 비밀번호 찾기
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to reset pw: $e');
    }
  }
}