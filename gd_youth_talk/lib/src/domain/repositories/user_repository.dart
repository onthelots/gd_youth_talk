import 'package:firebase_auth/firebase_auth.dart';
import 'package:gd_youth_talk/src/data/models/user_model.dart';
import 'package:gd_youth_talk/src/data/sources/user_datasource.dart';

class UserRepository {
  final UsersDataSource _userDatasource;
  final FirebaseAuth _auth;

  UserRepository(this._userDatasource, this._auth);

  Future<void> signUpWithEmailPassword(String email, String password, String nickname) async {
    return await _userDatasource.signUpWithEmailPassword(email, password, nickname);
  }

  Future<void> sendEmailVerification(User user) async {
    return await _userDatasource.sendEmailVerification(user);
  }

  Future<bool> verifyEmail(User user) async {
    return await _userDatasource.verifyEmail(user);
  }

  // 4. 비밀번호 변경
  Future<void> updatePasswordAfterSignUp(String newPassword) async {
    await _userDatasource.updatePasswordAfterSignUp(newPassword);
  }

  // 5. 로그인
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    return await _userDatasource.signInWithEmailPassword(email, password);
  }

  // 6. 로그아웃
  Future<void> signOut() async {
    return await _userDatasource.signOut();
  }

  // 7. 회원탈퇴
  Future<void> deleteUser() async {
    return await _userDatasource.deleteUser();
  }

   //8. 유저 정보 불러오기
  Future<UserModel> getUserInfo({required User currentUser}) async {
    return await _userDatasource.getCurrentUserInfo(currentUser: currentUser);
  }

  // 9. 닉네임 수정
  Future<void> updateNickname(String newNickname) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _userDatasource.updateNickname(user.uid, newNickname);
    } else {
      throw Exception('User is not authenticated');
    }
  }
}