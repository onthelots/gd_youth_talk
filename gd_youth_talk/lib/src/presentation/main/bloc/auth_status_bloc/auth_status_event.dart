import 'package:gd_youth_talk/src/data/models/user_model.dart';

abstract class UserEvent {}

// 앱 시작 시 자동로그인 시도
class AppStarted extends UserEvent {}

// 이메일/비밀번호 로그인 시도
class LoginRequested extends UserEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// 직접 로그인을 실시한 후, 유저 정보 저장
class UserLoggedInEvent extends UserEvent {
  final UserModel user;
  UserLoggedInEvent({required this.user});
}

// 로그아웃 시도
class LogoutRequested extends UserEvent {}

// 회원탈퇴 시도
class DeleteUserRequested extends UserEvent {}