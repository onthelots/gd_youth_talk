import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_exit_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_request_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_textField.dart';

class EmailAuthenticationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  EmailAuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerificationBloc(
        usecase: locator<UserUsecase>(),
      ),
      child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        /// Listener
        listener: (context, state) {
          if (state is EmailVerificationRequest) {
            showCustomRequestDialog(context);
          } else if (state is EmailVerificationSent) {
            context
                .read<EmailVerificationBloc>()
                .add(CheckEmailVerificationStatus());
          } else if (state is EmailVerificationCancelled) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },

        builder: (context, state) {
          bool isLoading = state is EmailVerificationSent;
          String buttonText = '이메일 인증하기';
          bool isButtonEnabled = false;

          if (state is EmailValidationState) {
            isButtonEnabled = state.isEmailValid;
          } else if (state is EmailVerificationSent) {
            buttonText = '인증 대기중';
            isLoading = true;
          } else if (state is EmailVerificationSuccess) {
            buttonText = '다음';
            isLoading = false;
            isButtonEnabled = true;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Text(
                '이메일 인증',
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
                    title: '유효한 이메일을 입력해주세요',
                    subtitle: '작성하신 이메일을 통한 추가 인증 절차가 필요해요',
                  ),

                  // 1. 이메일 입력창
                  CustomTextField(
                    controller: emailController,
                    hintText: "이메일 입력",
                    keyboardType: TextInputType.emailAddress,
                    errorText: null,
                    isEnabled: context.read<EmailVerificationBloc>().isTextFieldEnabled,
                    // 요청 중이면 비활성화
                    onChanged: (value) {
                      context
                          .read<EmailVerificationBloc>()
                          .add(EmailChanged(value));
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: CustomButtomNavBar(
                title: buttonText,
                isLoading: isLoading,
                onPressed: isButtonEnabled
                    ? () {
                        if (state is EmailVerificationSuccess) {
                          Navigator.pushNamed(context, Routes.regPassword);
                        } else {
                          // 이메일 인증 시작
                          context.read<EmailVerificationBloc>().add(
                              StartEmailVerification(emailController.text));
                        }
                      }
                    : null, // 버튼이 비활성화될 때 onPressed를 null로 설정
              ),
            ),
          );
        },
      ),
    );
  }

  void showCustomRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "인증메일 발송",
        content: "작성하신 이메일로 인증 메일이 발송되었습니다. 확인 후 링크를 눌러 회원가입을 계속 진행해주세요.",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  void showCustomExitDialog(BuildContext context) {
    final bloc = context.read<EmailVerificationBloc>(); // Bloc을 먼저 읽음
    showDialog(
      context: context,
      builder: (dialogContext) => CustomExitDialog(
        title: "멤버십 가입 취소",
        content: "현재까지 저장된 정보는 모두 삭제됩니다. 취소하시겠습니까?",
        cancelButtonText: "취소하기",
        continueButtonText: "계속하기",
        onCancel: () {
          bloc.add(CancelEmailVerification());
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
