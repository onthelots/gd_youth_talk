// Bloc 이벤트 정의
abstract class EmailVerificationEvent {}

class EmailChanged extends EmailVerificationEvent {
  final String email;

  EmailChanged(this.email);
}

class StartEmailVerification extends EmailVerificationEvent {
  final String email;
  StartEmailVerification(this.email);
}

class CheckEmailVerificationStatus extends EmailVerificationEvent {}

class CancelEmailVerification extends EmailVerificationEvent {}