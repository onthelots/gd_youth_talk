// Bloc 이벤트 정의
abstract class RegPasswordEvent {}

// 패스워드 TextField 이벤트
class PasswordChanged extends RegPasswordEvent {
  final String password;
  PasswordChanged(this.password);
}

// 패스워드 확인 TextField 이벤트
class PasswordConfirmChanged extends RegPasswordEvent {
  final String password;
  PasswordConfirmChanged(this.password);
}

// 패스워드 변경 이벤트
class SubmitPassword extends RegPasswordEvent {}

// 패스워드 (회원가입) 변경 취소 > 회원가입 취소
class CancelRegistration extends RegPasswordEvent {}