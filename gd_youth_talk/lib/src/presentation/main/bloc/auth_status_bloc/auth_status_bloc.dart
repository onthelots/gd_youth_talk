import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/secure_storage_helper.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_event.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserUsecase usecase;

  UserBloc({required this.usecase}) : super(UserInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // 1. 앱 실행 시 자동 로그인 시도
  Future<void> _onAppStarted(AppStarted event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final credentials =
        await SecureStorageHelper.getUserCredentials(); // 이메일, 비밀번호 가져오기 시도
    final email = credentials['email']; // 존재할 경우 이메일
    final password = credentials['password']; // 존재할 경우 비밀번호

    // 모두 존재할 경우
    if (email != null && password != null) {
      try {
        final user = await usecase.signIn(email: email, password: password);
        if (user != null) {
          emit(UserLoggedIn(user: user));
        }
      } catch (_) {
        emit(UserNotLoggedIn());
      }
    } else {
      emit(UserNotLoggedIn());
    }
  }

  // 2. 로그인 요청 시
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final user = await usecase.signIn(
          email: event.email, password: event.password); // 로그인 실시
      if (user != null) {
        emit(UserLoggedIn(user: user));
      }
    } catch (e) {
      emit(UserNotLoggedIn());
    }
  }

  // 3. 로그아웃 요청 시
  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<UserState> emit) async {
    await usecase.signOut();
    emit(UserNotLoggedIn());
  }
}
