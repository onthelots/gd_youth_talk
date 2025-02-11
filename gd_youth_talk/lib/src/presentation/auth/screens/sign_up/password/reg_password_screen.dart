import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/password/bloc/reg_password_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/password/bloc/reg_password_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/password/bloc/reg_password_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_exit_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_textField.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_event.dart';

class PasswordAuthenticationPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isPasswordValid = false;
    bool isPasswordMatched = false;
    bool isPasswordReadyState = false;

    return BlocProvider(
      create: (context) => RegPasswordBloc(
        usecase: locator<UserUsecase>(),
      ),
      child: BlocConsumer<RegPasswordBloc, RegPasswordState>(
        /// listener
        listener: (context, state) {
          if (state is RegistrationCancelled) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is PasswordValidationState) {
            isPasswordValid = state.isPasswordValid;
          } else if (state is PasswordConfirmState) {
            isPasswordMatched = state.isMatched;
          } else if (state is PasswordReadyState) {
            isPasswordReadyState = state.isReady;
          }
        },

        /// builder
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Text(
                '비밀번호 입력',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              leading: TextButton(
                child: Text(
                  '취소',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                onPressed: () => showCustomExitDialog(context),
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 0. 타이틀
                  const AuthTitleColumn(
                    title: '비밀번호를 입력해주세요',
                    subtitle: '숫자, 영문 포함 8자 이상 16자 이하입니다',
                  ),

                  // 1. 비밀번호
                  CustomTextField(
                    controller: passwordController,
                    hintText: "비밀번호 입력",
                    keyboardType: TextInputType.text,
                    errorText: isPasswordValid || passwordController.text.isEmpty ? null : '올바른 비밀번호 형식이 아닙니다',
                    obscureText: true,
                    onChanged: (value) {
                      context
                          .read<RegPasswordBloc>()
                          .add(PasswordChanged(value));
                    },
                  ),

                  // 2. 비밀번호 확인
                  CustomTextField(
                    controller: passwordConfirmController,
                    hintText: "비밀번호 확인",
                    keyboardType: TextInputType.text,
                    errorText: isPasswordMatched || passwordConfirmController.text.isEmpty ? null : '비밀번호가 일치하지 않습니다.',
                    obscureText: true,
                    onChanged: (value) {
                      context
                          .read<RegPasswordBloc>()
                          .add(PasswordConfirmChanged(value));
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: CustomButtomNavBar(
                title: '다음',
                isLoading: false,
                onPressed: isPasswordReadyState
                    ? () {
                        context.read<RegPasswordBloc>().add(SubmitPassword());
                        Navigator.pushNamed(context, Routes.regWelcome);
                      }
                    : null, // 버튼이 비활성화될 때 onPressed를 null로 설정
              ),
            ),
          );
        },
      ),
    );
  }

  void showCustomExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomExitDialog(
        title: "멤버십 가입 취소",
        content: "현재까지 저장된 정보는 모두 삭제됩니다. 취소하시겠습니까?",
        cancelButtonText: "취소하기",
        continueButtonText: "계속하기",
        onCancel: () {
          context.read<RegPasswordBloc>().add(CancelRegistration());
          Navigator.pop(dialogContext);
        },
        onContinue: () {
          // 계속하기 버튼 동작
          Navigator.pop(dialogContext);
        },
      ),
    );
  }
}
