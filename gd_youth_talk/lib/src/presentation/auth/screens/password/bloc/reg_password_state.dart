// Bloc 상태 정의
abstract class RegPasswordState {}

class RegPasswordInitial extends RegPasswordState {}

// 패스워드 유효성 여부
class PasswordValidationState extends RegPasswordState {
  final bool isPasswordValid;
  PasswordValidationState({required this.isPasswordValid});
}

// 패스워드 확인 일치여부
class PasswordConfirmState extends RegPasswordState {
  final bool isMatched;
  PasswordConfirmState({required this.isMatched});
}

// 유효성, 일치여부 모두 확인
class PasswordReadyState extends RegPasswordState {
  final bool isReady;
  PasswordReadyState({required this.isReady});
}

// 패스워드 업데이트 성공
class RegPasswordSuccess extends RegPasswordState {}

// 패스워드 변경 오류
class RegPasswordFailed extends RegPasswordState {
  final String error;
  RegPasswordFailed(this.error);
}

// 회원가입 취소
class RegistrationCancelled extends RegPasswordState {}