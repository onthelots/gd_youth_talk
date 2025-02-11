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
    on<ResetButtonPressed>((event, emit) async {
      print('🔹 ResetButtonPressed 이벤트 발생!');
      emit(EmailSendLoading()); // 전송 중
      try {
        await usecase.resetPassword(event.email);
        print('✅ 이메일 전송 성공');
        emit(EmailSendSuccess()); // 전송 성공
      } catch (e) {
        print('이메일 재설정 전송 실패 : $e');
        emit(EmailSendFailed()); // 전송 실패
      }
    });
  }

  // 이메일 유효성 검사 함수
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}