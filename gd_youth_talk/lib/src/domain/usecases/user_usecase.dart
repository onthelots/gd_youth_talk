import 'package:firebase_auth/firebase_auth.dart';
import 'package:gd_youth_talk/src/data/models/user_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/user_repository.dart';

class UserUsecase {
  final UserRepository _userRepository;

  UserUsecase(this._userRepository);

  // 1. 회원가입
  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      return await _userRepository.signUpWithEmailPassword(email, password, nickname); // 회원가입
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // 2. 인증번호 발송
  Future<void> sendEmailVerification(User user) async {
    await _userRepository.sendEmailVerification(user);
  }

  // 3. 이메일 인증 상태를 실시간으로 확인하는 메서드
  Future<bool> verifyEmail(User user) async {
    try {
      // 이메일 인증 상태 확인
      bool isVerified = await _userRepository.verifyEmail(user);

      // 이메일 인증이 완료되었으면 true 반환
      return isVerified;
    } catch (e) {
      // 인증 실패 시 false 반환
      return false;
    }
  }

  // 4. 로그인
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _userRepository.signInWithEmailPassword(email, password);
      return await _userRepository.getUserInfo();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // 5. 로그아웃
  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // 6. 유저정보(나) 조회
  Future<UserModel> getUserInfo() async {
    try {
      return await _userRepository.getUserInfo();
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

  // 7. 닉네임 변경하기
  Future<void> updateNickname(String newNickname) async {
    try {
      await _userRepository.updateNickname(newNickname);
    } catch (e) {
      throw Exception('Failed to update nickname: $e');
    }
  }

  // 8. 탈퇴 (계정 삭제)
  Future<void> deleteUser() async {
    try {
      await _userRepository.deleteUser();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}