// Bloc 구현
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_state.dart';
import '../../../../../domain/usecases/user_usecase.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final UserUsecase usecase;
  User? _tempUser;
  bool isTextFieldEnabled = true;

  EmailVerificationBloc({required this.usecase}) : super(EmailValidationState(isEmailValid: false)) {

    // 이메일 기입 및 적합성 여부에 따른 상태값
    on<EmailChanged>((event, emit) {
      final isValid = _isValidEmail(event.email); // 유효성 검사

      // ⭐️ State 초기화 (해당 화면이 초기화 되었을 때)
      emit(EmailValidationState(
        isEmailValid: isValid,
      ));
    });

    // 인증 시작
    on<StartEmailVerification>(_onStartEmailVerification);

    // 인증 여부 확인
    on<CheckEmailVerificationStatus>(_onCheckEmailVerificationStatus);

    // 인증 취소
    on<CancelEmailVerification>(_onCancelEmailVerification);
  }

  // 이메일 유효성 검사 함수
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // 임시 회원가입 및 이메일 인증 보내기
  Future<void> _onStartEmailVerification(
      StartEmailVerification event,
      Emitter<EmailVerificationState> emit) async {

    emit(EmailVerificationRequest()); // sent 상태변환
    isTextFieldEnabled = false; // 버튼 비 활성화
    try {
      // 1. 임시 회원가입
      final randomPassword = _generateRandomPassword();
      final randomNickname = _generateRandomNickname();  // 랜덤 닉네임 생성

      // 회원가입 실시
      await usecase.signUp(
        email: event.email,
        password: randomPassword,
        nickname: randomNickname,
      );

      // 유저 정보 가져오기
      _tempUser = FirebaseAuth.instance.currentUser;

      // 2. 인증 이메일 발송
      if (_tempUser != null) {
        await usecase.sendEmailVerification(_tempUser!);
        emit(EmailVerificationSent()); // sent 상태변환
      } else {
        throw Exception("Temporary user creation failed.");
      }
    } catch (e) {
      emit(EmailVerificationFailed(e.toString()));
    }
  }

  // 이메일 인증정보 확인
  Future<void> _onCheckEmailVerificationStatus(
      CheckEmailVerificationStatus event,
      Emitter<EmailVerificationState> emit,
      ) async {

    if (_tempUser == null) return;

    try {
      final isVerified = await usecase.verifyEmail(_tempUser!);
      if (isVerified) {
        emit(EmailVerificationSuccess()); // 성공
      } else {
        emit(EmailVerificationFailed("Email verification failed.")); // 실패 (이메일 인증 전까지는 계속 실패로 유지될 것)
      }
    } catch (e) {
      emit(EmailVerificationFailed(e.toString()));
    }
  }

  // 회원가입 취소 (탈퇴)
  Future<void> _onCancelEmailVerification(
      CancelEmailVerification event,
      Emitter<EmailVerificationState> emit,
      ) async {
    try {
      if (_tempUser != null) {
        await usecase.deleteUser(); // 삭제
      }
      emit(EmailVerificationCancelled());
    } catch (e) {
      emit(EmailVerificationFailed("Failed to cancel verification: $e"));
    }
  }

  // 랜덤 비밀번호
  String _generateRandomPassword() {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  String _generateRandomNickname() {
    final random = Random();
    final randomNumber = random.nextInt(90000) + 10000; // 5자리 랜덤 숫자 생성 (10000 ~ 99999)
    return '#$randomNumber님';
  }
}