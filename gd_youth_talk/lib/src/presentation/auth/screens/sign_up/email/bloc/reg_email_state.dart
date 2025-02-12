// Bloc 상태 정의
abstract class EmailVerificationState {}

// 이메일 유효성 검사
class EmailValidationState extends EmailVerificationState {
  final bool isEmailValid;

  EmailValidationState({required this.isEmailValid});
}

// 인증 이메일 요청
class EmailVerificationRequest extends EmailVerificationState {}

// 인증 이메일 발송 완료
class EmailVerificationSent extends EmailVerificationState {}

// 이메일 인증 완료
class EmailVerificationSuccess extends EmailVerificationState {}

// 이메일 인증 실패
class EmailVerificationFailed extends EmailVerificationState {
  final String error;
  EmailVerificationFailed(this.error);
}

// 회원가입 취소
class EmailVerificationCancelled extends EmailVerificationState {}