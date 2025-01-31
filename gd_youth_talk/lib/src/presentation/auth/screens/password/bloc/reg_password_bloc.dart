import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/password/bloc/reg_password_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/password/bloc/reg_password_state.dart';

class RegPasswordBloc extends Bloc<RegPasswordEvent, RegPasswordState> {
  final UserUsecase usecase;
  User? _tempUser;

  RegPasswordBloc({required this.usecase}) : super(RegPasswordInitial()) {
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordConfirmChanged>(_onPasswordConfirmChanged);
    on<SubmitPassword>(_onSubmitPassword);
    on<CancelRegistration>(_onCancelEmailVerification);
  }

  String? _password;
  String? _confirmPassword;

  /// 비밀번호 유효성 검사
  void _onPasswordChanged(PasswordChanged event,
      Emitter<RegPasswordState> emit) {
    _password = event.password;
    final isValid = _validatePassword(event.password);
    print('isValid : ${isValid}');
    emit(PasswordValidationState(isPasswordValid: isValid));
    _emitPasswordReadyState(emit); // 변경준비 확인
  }

  /// 비밀번호 확인 입력 처리
  void _onPasswordConfirmChanged(PasswordConfirmChanged event,
      Emitter<RegPasswordState> emit) {
    _confirmPassword = event.password;
    final isMatch = _password == event.password;
    emit(PasswordConfirmState(isMatched: isMatch));
    _emitPasswordReadyState(emit); // 변경준비 확인
  }

  /// 비밀번호 변경 준비 상태 확인
  void _emitPasswordReadyState(Emitter<RegPasswordState> emit) {
    if (_password != null &&
        _confirmPassword != null &&
        _password == _confirmPassword &&
        _validatePassword(_password!)) {
      emit(PasswordReadyState(isReady: true));
    } else {
      emit(PasswordReadyState(isReady: false));
    }
  }

  /// 비밀번호 설정 제출
  Future<void> _onSubmitPassword(SubmitPassword event,
      Emitter<RegPasswordState> emit) async {
    if (_password == null || _confirmPassword == null ||
        _password != _confirmPassword) {
      emit(RegPasswordFailed("비밀번호가 일치하지 않습니다."));
      return;
    }

    if (!_validatePassword(_password!)) {
      emit(RegPasswordFailed("비밀번호는 8~16자의 영문, 숫자, 특수문자를 조합해야 합니다."));
      return;
    }

    try {
      await usecase.updatePasswordAfterSignUp(_password!);
      emit(RegPasswordSuccess());
    } catch (e) {
      emit(RegPasswordFailed("비밀번호 설정 실패: $e"));
    }
  }

  /// 비밀번호 형식 검증
  bool _validatePassword(String password) {
    final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$');
    return regex.hasMatch(password);
  }

  // 회원가입 취소 (탈퇴)
  Future<void> _onCancelEmailVerification(CancelRegistration event,
      Emitter<RegPasswordState> emit,) async {
    try {
      if (_tempUser != null) {
        await usecase.deleteUser(); // 삭제
      }
      emit(PasswordReadyState(isReady: false)); // 회원가입 준비 X
      emit(RegistrationCancelled()); // 상태변경

    } catch (e) {
      emit(RegPasswordFailed("Failed to cancel verification: $e"));
    }
  }
}
