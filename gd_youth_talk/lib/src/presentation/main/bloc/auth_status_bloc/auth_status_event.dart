abstract class UserEvent {}

// 앱 시작 시 자동로그인 시도
class AppStarted extends UserEvent {}

// 이메일/비밀번호 로그인 시도
class LoginRequested extends UserEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// 로그아웃 시도
class LogoutRequested extends UserEvent {}