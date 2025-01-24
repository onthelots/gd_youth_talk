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

  EmailVerificationBloc({required this.usecase}) : super(EmailVerificationInitial()) {
    on<StartEmailVerification>(_onStartEmailVerification);
    on<CheckEmailVerificationStatus>(_onCheckEmailVerificationStatus);
    on<CancelEmailVerification>(_onCancelEmailVerification);
  }

  // 임시 회원가입 및 이메일 인증 보내기
  Future<void> _onStartEmailVerification(StartEmailVerification event,
      Emitter<EmailVerificationState> emit) async {
    emit(EmailVerificationInProgress());
    try {
      // 1. 임시 회원가입
      final randomPassword = _generateRandomPassword();

      // 회원가입 실시
      await usecase.signUp(
        email: event.email,
        password: randomPassword,
        nickname: "TempUser",
      );

      // 유저 정보 가져오기
      _tempUser = FirebaseAuth.instance.currentUser;

      // 2. 인증 이메일 발송
      if (_tempUser != null) {
        await usecase.sendEmailVerification(_tempUser!);
        emit(EmailVerificationSent());
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
    emit(EmailVerificationChecking());
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
}