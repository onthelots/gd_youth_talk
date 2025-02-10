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
    on<DeleteUserRequested>(_onDeleteUserRequest);

    on<UserLoggedInEvent>((event, emit) {
      emit(UserLoggedIn(user: event.user));
    });
  }

  // 1. 앱 실행 시 자동 로그인 시도
  Future<void> _onAppStarted(AppStarted event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final credentials =
        await SecureStorageHelper.getUserCredentials(); // 이메일, 비밀번호 가져오기 시작
    final email = credentials['email']; // 존재할 경우 이메일
    final password = credentials['password']; // 존재할 경우 비밀번호

    // 모두 존재할 경우
    if (email != null && password != null) {
      try {
        final user = await usecase.signIn(email: email, password: password);
        if (user != null) {
          print("불러온 유저의 정보에요 : ${user.email}");
          emit(UserLoggedIn(user: user));
        }
      } catch (e) {
        print("앱 시작 시 자동로그인 실패 $e");
        emit(UserNotLoggedIn());
      }
    } else {
      print("---- 왜 로딩에서 멈춤..?");
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

  // 4. 회원 탈퇴 시
  Future<void> _onDeleteUserRequest(
      DeleteUserRequested event, Emitter<UserState> emit) async {
    await usecase.deleteUser();
    emit(UserNotLoggedIn());
  }
}
