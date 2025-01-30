// Bloc 상태 정의
abstract class EmailVerificationState {}

class EmailValidationState extends EmailVerificationState {
  final bool isEmailValid;

  EmailValidationState({required this.isEmailValid});
}

class EmailVerificationSent extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationFailed extends EmailVerificationState {
  final String error;
  EmailVerificationFailed(this.error);
}

class EmailVerificationCancelled extends EmailVerificationState {}