abstract class ResetPwState {}

// 이메일 유효성 검사
class ResetEmailValidationState extends ResetPwState {
  final bool isEmailValid;

  ResetEmailValidationState({required this.isEmailValid});
}

// 이메일 발송 중
class EmailSendLoading extends ResetPwState {}

// 이메일 발송 완료
class EmailSendSuccess extends ResetPwState {}

// 이메일 발송 실패
class EmailSendFailed extends ResetPwState {}