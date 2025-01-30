import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_exit_dialog.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_textField.dart';

class EmailAuthenticationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  EmailAuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 35.0),
        child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(

          /// Listener
          listener: (context, state) {
            if (state is EmailVerificationCancelled) {
              Navigator.popUntil(context, (route) => route.isFirst);

              // 인증 이메일 발송 이후 -> 인증여부 파악을 위한 이벤트 실행
            } else if (state is EmailVerificationSent) {
              print("임시 회원가입 이후, 인증 이메일 발송이 완료되었습니다.");
              context
                  .read<EmailVerificationBloc>()
                  .add(CheckEmailVerificationStatus());
            } else if (state is EmailVerificationSuccess) {
              print("이메일 인증이 완료되었습니다!");
            }
          },

          /// Builder
          builder: (context, state) {
            if (state is EmailVerificationCancelled) {
              context.read<EmailVerificationBloc>().add(
                  EmailChanged("")); // 빈 이메일로 상태를 초기화
            }

            return Column(
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
                  onChanged: (value) {
                    context
                        .read<EmailVerificationBloc>()
                        .add(EmailChanged(value));
                  },
                ),
              ],
            );
          },
        ),
      ),

      // 상태값에 따라서, CustomButtonNav의 상태를 변경할 것
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
          builder: (context, state) {
            bool isButtonEnabled = false;
            if (state is EmailValidationState) {
              isButtonEnabled = state.isEmailValid;

              print('IsButtonEnabled : ${isButtonEnabled}');

              return CustomButtomNavBar(
                title: '이메일 인증하기',
                isLoading: false,
                onPressed: isButtonEnabled
                    ? () {
                        context.read<EmailVerificationBloc>().add(
                            StartEmailVerification(emailController.text));
                      }
                    : null, // 버튼이 비활성화될 때 onPressed를 null로 설정
              );
            } else if (state is EmailVerificationSent) {
              return CustomButtomNavBar(
                title: '인증 대기중...',
                isLoading: true,
                onPressed: () {
                  null;
                },
              );
            } else if (state is EmailVerificationSuccess) {
              return CustomButtomNavBar(
                title: '다음',
                isLoading: false,
                onPressed: () {
                  // PW Scrren으로 이동
                  Navigator.pushNamed(context, Routes.regPassword);
                },
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  void showCustomExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomExitDialog(
        title: "멤버십 가입 취소",
        content: "현재까지 저장된 정보는 모두 삭제됩니다. 취소하시겠습니까?",
        cancelButtonText: "취소하기",
        continueButtonText: "계속하기",
        onCancel: () {
          context.read<EmailVerificationBloc>().add(CancelEmailVerification());
          Navigator.pop(context);
        },
        onContinue: () {
          // 계속하기 버튼 동작
          Navigator.pop(context);
        },
      ),
    );
  }
}
