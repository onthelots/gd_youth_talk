import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/terms/bloc/reg_terms_cubit.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/terms/bloc/reg_terms_state.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';

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
                  const AuthTitleColumn(
                    title: '필수 약관에 동의해주세요',
                    subtitle: '모든 약관에 동의해야 멤버십 자격을 얻을 수 있어요',
                  ),

                  // 1. 모든 약관 동의
                  CheckboxListTile(
                    title: Text(
                      "모든 약관에 동의합니다",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.agreeAll,
                    controlAffinity: ListTileControlAffinity.leading,
                    // 체크박스 왼쪽 배치
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
                    controlAffinity: ListTileControlAffinity.leading,
                    // 체크박스 왼쪽 배치
                    onChanged: (value) =>
                        cubit.updateIndividual('age', value ?? false),
                  ),

                  // 3. 서비스 이용약관 동의
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Text(
                          "서비스 이용약관에 동의합니다",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.webView,
                              arguments: WebRoutes.termsOfUse),
                          child: Text(
                            "보기",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.termsOfService,
                    controlAffinity: ListTileControlAffinity.leading,
                    // 체크박스 왼쪽 배치
                    onChanged: (value) =>
                        cubit.updateIndividual('terms', value ?? false),
                  ),

                  // 4. 개인정보 처리방침 동의
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Text(
                          "개인정보 처리방침에 동의합니다",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.webView,
                              arguments: WebRoutes.privacyPolicy),
                          child: Text(
                            "보기",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.zero,
                    value: state.privacyPolicy,
                    controlAffinity: ListTileControlAffinity.leading,
                    // 체크박스 왼쪽 배치
                    onChanged: (value) =>
                        cubit.updateIndividual('privacy', value ?? false),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<TermsCubit, TermsState>(
          builder: (context, state) {
            return CustomButtomNavBar(
              title: '계속하기',
              onPressed: state.agreeAll // 모든 약관 동의 시에만 활성화
                  ? () {
                Navigator.pushNamed(context, Routes.regEmail);
              }
                  : null, // 비활성화
            );
          },
        ),
      ),
    );
  }
}