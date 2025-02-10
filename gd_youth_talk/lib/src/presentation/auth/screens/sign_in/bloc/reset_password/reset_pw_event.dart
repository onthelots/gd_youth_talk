abstract class ResetPwEvent {}

class ResetEmailChanged extends ResetPwEvent {
  final String email;
  ResetEmailChanged(this.email);
}

// 이메일 발송
class ResetButtonPressed extends ResetPwEvent {
  final String email;

  ResetButtonPressed({required this.email});
}