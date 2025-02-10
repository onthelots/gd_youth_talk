import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/reset_password/reset_pw_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/reset_password/reset_pw_state.dart';

class ResetPWBloc extends Bloc<ResetPwEvent, ResetPwState> {
  final UserUsecase usecase;

  bool _isEmailValid = false;   // 이메일 유효성 상태 저장
  ResetPWBloc({required this.usecase}) : super(ResetEmailValidationState(isEmailValid: false)) {

    // 이메일 유효성 검사
    on<ResetEmailChanged>((event, emit) {
      _isEmailValid = _isValidEmail(event.email); // 유효성 검사
      emit(ResetEmailValidationState(isEmailValid: _isEmailValid));
    });

    // 비밀번호 재 설정
    // TODO: - 비밀번호 재 설정 전송 후, 반응이 없음 -> 결과값에 대한 부분을 전달받아야 함 (datasource에서 부터)
    on<ResetButtonPressed>((event, emit) async {
      try {
        await usecase.resetPassword(event.email);
        emit(EmailSendSuccess()); // 로그인 실패
      } catch (e) {
        print('이메일 재설정 전송 실패 : $e');
        emit(EmailSendFailed()); // 로그인 실패
      }
    });
  }

  // 이메일 유효성 검사 함수
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}