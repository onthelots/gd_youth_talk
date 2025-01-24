import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_event.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 35.0),
        child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerificationCancelled) {
              Navigator.popUntil(context, (route) => route.isFirst);
            } else if (state is EmailVerificationSent) {
              print("임시 회원가입 이후, 인증 이메일 발송이 완료되었습니다.");
              context
                  .read<EmailVerificationBloc>()
                  .add(CheckEmailVerificationStatus());
            } else if (state is EmailVerificationChecking) {
              print("이메일 인증을 기다리는 중입니다..");
            } else if (state is EmailVerificationSuccess) {
              print("이메일 인증이 완료되었습니다!");
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 0. 타이틀
                const AuthTitleColumn(
                  title: '이메일과 비밀번호를 입력해주세요',
                  subtitle: '작성하신 이메일을 통한 추가 인증 절차가 필요해요',
                ),

                // 1. 이메일 입력창
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: "이메일 입력"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),

      // 상태값에 따라서, CustomButtonNav의 상태를 변경할 것
      bottomNavigationBar:
          BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
        builder: (context, state) {
          if (state is EmailVerificationInitial) {
            return CustomButtomNavBar(
              title: '이메일 인증하기',
              isLoading: false,
              onPressed: () {
                emailController.text.isEmpty
                    ? null
                    : context
                        .read<EmailVerificationBloc>()
                        .add(StartEmailVerification(emailController.text));
              },
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
                print("다음 화면으로 이동");
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Verification"),
        content: Text(
            "Are you sure you want to cancel verification? All progress will be lost."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<EmailVerificationBloc>()
                  .add(CancelEmailVerification());
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
}
