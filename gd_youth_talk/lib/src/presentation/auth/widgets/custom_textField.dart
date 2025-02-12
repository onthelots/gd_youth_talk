import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String) onChanged;
  final bool isEnabled;
  final TextInputType keyboardType;
  final String? errorText;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.onChanged,
    this.isEnabled = true,
    required this.keyboardType,
    required this.errorText, // 기본값을 true로 설정
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          cursorColor: Theme.of(context).primaryColor,
          enabled: isEnabled, // 추가된 속성 반영
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          onChanged: isEnabled ? onChanged : null, // 비활성화 시 onChanged 실행 방지
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

