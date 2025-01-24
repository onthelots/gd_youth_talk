// Bloc 이벤트 정의
abstract class EmailVerificationEvent {}

class StartEmailVerification extends EmailVerificationEvent {
  final String email;
  StartEmailVerification(this.email);
}

class CheckEmailVerificationStatus extends EmailVerificationEvent {}

class CancelEmailVerification extends EmailVerificationEvent {}