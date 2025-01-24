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

  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    return await _userDatasource.signInWithEmailPassword(email, password);
  }

  Future<void> signOut() async {
    return await _userDatasource.signOut();
  }

  Future<void> deleteUser() async {
    return await _userDatasource.deleteUser();
  }

  Future<UserModel> getUserInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await _userDatasource.getUserInfo(user.uid);
    } else {
      throw Exception('User is not authenticated');
    }
  }

  Future<void> updateNickname(String newNickname) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _userDatasource.updateNickname(user.uid, newNickname);
    } else {
      throw Exception('User is not authenticated');
    }
  }
}