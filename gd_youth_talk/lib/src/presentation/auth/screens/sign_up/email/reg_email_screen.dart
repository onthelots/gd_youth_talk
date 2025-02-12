import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/email/bloc/reg_email_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/email/bloc/reg_email_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/email/bloc/reg_email_state.dart';
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

          // 인증 메일 발송 요청 (상태 변화)
          if (state is EmailVerificationRequest) {
            showCustomRequestDialog(context);

            // 인증 메일 발송 성공
          } else if (state is EmailVerificationSent) {
            context
                .read<EmailVerificationBloc>()
                .add(CheckEmailVerificationStatus());

            // 회원가입 취소
          } else if (state is EmailVerificationCancelled) {
            Navigator.popUntil(context, (route) => route.isFirst);

            // 메일 인증 실패 (중복 등)
          } else if (state is EmailVerificationFailed) {
            if (state.error.contains("already in use")) {
              showDuplicateEmailDialog(context);
            } else {
              showErrorDialog(context);
            }
          }
        },

        builder: (context, state) {
          bool isLoading = state is EmailVerificationSent;
          String buttonText = '이메일 인증하기';
          bool isButtonEnabled = false;

          // 유효한 이메일 형식 기입 여부
          if (state is EmailValidationState) {
            isButtonEnabled = state.isEmailValid;

            // 인증 이메일 발송 완료
          } else if (state is EmailVerificationSent) {
            buttonText = '인증 대기중';
            isLoading = true;

            // 이메일 인증 완료
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
                        } else if (state is EmailVerificationFailed) {
                          null;
                        } else {
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

  // 인증 메일 발송 완료
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

  // 기 가입된 이메일
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

  // 이메일 인증 실패
  void showDuplicateEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "이메일 인증 실패",
        content: "이미 가입되어 있는 이메일입니다. 확인 후 다시 시도해주세요",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomRequestDialog(
        title: "이메일 인증 실패",
        content: "올바른 요청이 아닙니다. 잠시 후 다시 시도해주세요",
        continueButtonText: "확인",
        onContinue: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }
}
