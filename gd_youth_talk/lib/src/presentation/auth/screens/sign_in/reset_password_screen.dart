import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/reset_password/reset_pw_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/reset_password/reset_pw_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/bloc/reset_password/reset_pw_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/widgets/loading_indicator.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_request_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_textField.dart';
import '../../../../domain/usecases/user_usecase.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPWBloc(
        usecase: locator<UserUsecase>(),
      ),
      child: BlocConsumer<ResetPWBloc, ResetPwState>(
        /// Listener
        listener: (context, state) {
          print('🎯 BlocConsumer - 현재 상태: $state'); // 상태 감지 로그 추가
          if (state is EmailSendFailed) {
            print('❌ 이메일 발송 실패 감지됨');
            showCustomPWResetErrorDialog(context);
            emailController.text = "";
            // 이메일 인증 완료
          } else if (state is EmailSendSuccess) {
            print('✅ 이메일 발송 성공 감지됨');
            showCustomPWResetSuccessDialog(context);
          }
        },

        builder: (context, state) {
          bool isButtonEnabled = false;
          bool isLoading = false;

          // 유효한 이메일 형식 기입 여부
          if (state is ResetEmailValidationState) {
            isButtonEnabled = state.isEmailValid;
          } else if (state is EmailSendLoading) {
            isLoading = true;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Text(
                '비밀번호 재 설정',
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
                        title: '찾고자 하는 이메일을 입력해주세요',
                        subtitle: '전송된 링크를 통한 비밀번호 재 설정',
                      ),

                      // 1. 이메일 입력창
                      CustomTextField(
                        controller: emailController,
                        hintText: "이메일 입력",
                        keyboardType: TextInputType.emailAddress,
                        errorText: null,
                        isEnabled: true,
                        onChanged: (value) {
                          context.read<ResetPWBloc>().add(ResetEmailChanged(value));
                        },
                      ),
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
                title: "메일 전송",
                isLoading: false,
                onPressed: isButtonEnabled
                    ? () {
                        context.read<ResetPWBloc>().add(ResetButtonPressed(
                              email: emailController.text,
                            ));
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
  void showCustomPWResetSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "재 발급 메일 발송 완료",
        content: "입력한 이메일로 전송된 비밀번호 재 발급 과정을 진행해주세요. 이후 로그인을 진행할 수 있습니다.",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
      ),
    );
  }

  // 인증 메일 발송 실패
  void showCustomPWResetErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "발송 실패",
        content: "존재하지 않거나, 올바른 이메일이 아닙니다. 확인 후 다시 시도해주세요.",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
      ),
    );
  }
}
