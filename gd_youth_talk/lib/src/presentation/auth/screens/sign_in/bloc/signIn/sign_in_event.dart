abstract class SignInEvent {}

class EmailChanged extends SignInEvent {
  final String email;
  EmailChanged(this.email);
}

// 패스워드 TextField 이벤트
class PasswordChanged extends SignInEvent {
  final String password;
  PasswordChanged(this.password);
}

// 로그인 버튼 이벤트
class SignInButtonPressed extends SignInEvent {
  final String email;
  final String password;

  SignInButtonPressed({required this.email, required this.password});
}