import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/signIn/sign_in_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/signIn/sign_in_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/signIn/sign_in_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/widgets/loading_indicator.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_request_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_textField.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_event.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        usecase: locator<UserUsecase>(),
      ),
      child: BlocConsumer<SignInBloc, SignInState>(
        /// Listener
        listener: (context, state) {
          if (state is SignInFailed) {
            showCustomSignInErrorDialog(context);
            passwordController.text = "";
            // 이메일 인증 완료
          } else if (state is SignInSuccess) {
            context.read<UserBloc>().add(UserLoggedInEvent(user: state.user));
            Navigator.popUntil(context, (route) => route.isFirst);
            // 메일 인증 실패 (중복 등)
          }
        },

        builder: (context, state) {
          bool isButtonEnabled = false;
          bool isTextFieldEnabled = true;
          bool isLoading = false;

          // 유효한 이메일 형식 기입 여부
          if (state is SignInReadyState) {
            isButtonEnabled = state.isReady;

            // 로딩 중
          } else if (state is SignInLoading) {
            isLoading = true;
            isTextFieldEnabled = false;
            passwordController.text = '';
          } else if (state is SignInFailed) {
            isTextFieldEnabled = true;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Text(
                '로그인',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 35.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 0. 타이틀
                      const AuthTitleColumn(
                        title: '강동청년톡톡에 오신걸 환영합니다',
                        subtitle: '이메일과 비밀번호로 로그인하기',
                      ),

                      // 1. 이메일 입력창
                      CustomTextField(
                        controller: emailController,
                        hintText: "이메일 입력",
                        keyboardType: TextInputType.emailAddress,
                        errorText: null,
                        isEnabled: isTextFieldEnabled,
                        onChanged: (value) {
                          context.read<SignInBloc>().add(EmailChanged(value));
                        },
                      ),

                      // 2. 비밀번호 입력창
                      CustomTextField(
                        controller: passwordController,
                        hintText: "비밀번호 입력",
                        keyboardType: TextInputType.text,
                        errorText: isButtonEnabled || passwordController.text.isEmpty ? null : '특수문자, 숫자, 영문 포함 8자 이상 16자 이하로 입력해주세요',
                        obscureText: true,
                        isEnabled: isTextFieldEnabled,
                        onChanged: (value) {
                          context
                              .read<SignInBloc>()
                              .add(PasswordChanged(value));
                        },
                      ),

                      // 3. 비밀번호 재 설정
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.resetPw);
                            },
                            child: Text(
                              "비밀번호를 잊어버리셨나요?",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Loading Indicator
                Container(
                  child: isLoading ? Loader() : Container(),
                )
              ],
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: CustomButtomNavBar(
                title: "로그인",
                isLoading: false,
                onPressed: isButtonEnabled
                    ? () {
                        context.read<SignInBloc>().add(
                              SignInButtonPressed(
                                  email: emailController.text,
                                  password: passwordController.text),
                            );
                      }
                    : null, // 버튼이 비활성화될 때 onPressed를 null로 설정
              ),
            ),
          );
        },
      ),
    );
  }

  // 인증 메일 발송 완료
  void showCustomSignInErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "로그인 실패",
        content: "입력하신 이메일 및 비밀번호가 올바르지 않습니다. 다시 시도해주세요",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }
}
