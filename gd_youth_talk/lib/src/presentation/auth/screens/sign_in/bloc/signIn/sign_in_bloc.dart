import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/signIn/sign_in_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/signIn/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserUsecase usecase;

  bool _isEmailValid = false;   // 이메일 유효성 상태 저장
  bool _isPasswordValid = false; // 비밀번호 유효성 상태 저장

  SignInBloc({required this.usecase}) : super(EmailValidationState(isEmailValid: false)) {

    // 이메일 유효성 검사
    on<EmailChanged>((event, emit) {
      _isEmailValid = _isValidEmail(event.email); // 유효성 검사
      emit(EmailValidationState(isEmailValid: _isEmailValid));
      _checkReadyState(emit);
    });

    // 비밀번호 유효성 검사
    on<PasswordChanged>((event, emit) {
      _isPasswordValid = _validatePassword(event.password);
      emit(PasswordValidationState(isPasswordValid: _isPasswordValid));
      _checkReadyState(emit);
    });

    // 로그인 이벤트 처리
    on<SignInButtonPressed>((event, emit) async {
      emit(SignInLoading()); // 로딩 상태

      try {
        final user = await usecase.signIn(email: event.email, password: event.password);
        if (user != null) {
          emit(SignInSuccess(user: user)); // 로그인 성공
        } else {
          emit(SignInFailed()); // 로그인 실패
        }
      } catch (e) {
        print('로그인 실패 : $e');
        emit(SignInFailed()); // 로그인 실패
      }
    });
  }

  // 이메일 유효성 검사 함수
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // 비밀번호 형식 검증
  bool _validatePassword(String password) {
    final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$');
    return regex.hasMatch(password);
  }

  // 이메일 & 비밀번호가 유효하면 로그인 버튼 활성화
  void _checkReadyState(Emitter<SignInState> emit) {
    final isReady = _isEmailValid && _isPasswordValid;
    print("준비되었나요?: $isReady");
    emit(SignInReadyState(isReady: isReady));
  }
}