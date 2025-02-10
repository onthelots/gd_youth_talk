import 'package:firebase_auth/firebase_auth.dart';
import 'package:gd_youth_talk/src/data/models/user_model.dart';

// State 정의
abstract class UserState {}

// 초기 상태
class UserInitial extends UserState {}

// 로그인 진행 중
class UserLoading extends UserState {}

// 로그인 성공 (유저 정보 저장)
class UserLoggedIn extends UserState {
  final UserModel user;
  UserLoggedIn({required this.user});
}

// 로그아웃 혹은 로그인 실패
class UserNotLoggedIn extends UserState {}
