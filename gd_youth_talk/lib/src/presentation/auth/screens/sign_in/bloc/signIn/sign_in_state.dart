import 'package:gd_youth_talk/src/data/models/user_model.dart';

abstract class SignInState {}

// 이메일 유효성 검사
class EmailValidationState extends SignInState {
  final bool isEmailValid;

  EmailValidationState({required this.isEmailValid});
}

// 패스워드 유효성 검사
class PasswordValidationState extends SignInState {
  final bool isPasswordValid;
  PasswordValidationState({required this.isPasswordValid});
}

// 이메일, 패스워드 유효성 검사
class SignInReadyState extends SignInState {
  final bool isReady;
  SignInReadyState({required this.isReady});
}

// 로그인 성공 상태
class SignInSuccess extends SignInState {
  final UserModel user;
  SignInSuccess({required this.user});
}

// 로그인 로딩 상태
class SignInLoading extends SignInState {}

// 로그인 실패
class SignInFailed extends SignInState {}