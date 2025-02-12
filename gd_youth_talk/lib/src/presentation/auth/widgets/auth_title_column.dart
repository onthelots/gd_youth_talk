import 'package:flutter/material.dart';

class AuthTitleColumn extends StatelessWidget {
  final String title; // 첫 번째 텍스트
  final String subtitle; // 두 번째 텍스트

  const AuthTitleColumn({
    super.key,
    required this.title, // 필수 매개변수
    required this.subtitle, // 필수 매개변수
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, // 외부에서 전달받은 텍스트 사용
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          subtitle, // 외부에서 전달받은 텍스트 사용
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
