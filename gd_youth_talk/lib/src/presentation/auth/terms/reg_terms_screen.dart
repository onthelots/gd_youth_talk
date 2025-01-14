import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/terms/bloc/reg_terms_cubit.dart';
import 'package:gd_youth_talk/src/presentation/auth/terms/bloc/reg_terms_state.dart';

class TermsAgreementPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermsCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            '약관 동의',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 35.0),
          child: BlocBuilder<TermsCubit, TermsState>(
            builder: (context, state) {
              final cubit = context.read<TermsCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 0. 타이틀
                  Text(
                    "멤버십 이용을 위해 \n아래 필수 약관에 동의해주세요.",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  // 1. 모든 약관 동의
                  CheckboxListTile(
                    title: Text(
                      "모든 약관에 동의합니다",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.agreeAll,
                    onChanged: (value) => cubit.toggleAgreeAll(value ?? false),
                  ),

                  const Divider(),

                  // 2. 만 14세 이상
                  CheckboxListTile(
                    title: Text(
                      "만 14세 이상입니다",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.ageConfirmed,
                    onChanged: (value) => cubit.updateIndividual('age', value ?? false),
                  ),

                  // 3. 서비스 이용약관 동의
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Text(
                          "서비스 이용약관에 동의합니다",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.termsOfUse),
                          child: Text(
                            "보기",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.termsOfService,
                    onChanged: (value) => cubit.updateIndividual('terms', value ?? false),
                  ),

                  // 4. 개인정보 처리방침 동의
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Text(
                          "개인정보 처리방침에 동의합니다",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.privacyPolicy),
                          child: Text(
                            "보기",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.privacyPolicy,
                    onChanged: (value) => cubit.updateIndividual('privacy', value ?? false),
                  ),
                  Spacer(),

                  //TODO: - 계속 버튼 수정
                  ElevatedButton(
                    onPressed: (state.ageConfirmed && state.termsOfService && state.privacyPolicy)
                        ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("회원가입이 완료되었습니다.")),
                      );
                    }
                        : null, // 모든 체크박스가 체크되지 않았을 경우 비활성화
                    child: Text("회원가입 완료"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
