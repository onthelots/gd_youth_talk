// Bloc 상태 정의
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationInProgress extends EmailVerificationState {}

class EmailVerificationSent extends EmailVerificationState {}

class EmailVerificationChecking extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationFailed extends EmailVerificationState {
  final String error;
  EmailVerificationFailed(this.error);
}

class EmailVerificationCancelled extends EmailVerificationState {}