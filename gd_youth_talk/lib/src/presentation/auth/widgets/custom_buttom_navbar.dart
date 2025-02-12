import 'package:flutter/material.dart';

class CustomButtomNavBar extends StatelessWidget {
  final VoidCallback? onPressed; // 외부에서 onPressed를 전달받기 위한 콜백
  final String title; // 버튼 text
  final bool isLoading; // 로딩 상태를 나타내는 변수

  const CustomButtomNavBar({
    super.key,
    required this.onPressed,
    required this.title, // 필수 매개변수로 지정
    this.isLoading = false, // 기본값 false (비활성화)
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13, bottom: 50),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed, // 로딩 중일 때는 버튼 비활성화
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          icon: isLoading
              ? const SizedBox(
            width: 24.0, // 원하는 크기 설정
            height: 24.0, // 원하는 크기 설정
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.0, // 인디케이터 선 두께 조정 (선택 사항)
            ),
          )
              : const SizedBox.shrink(), // 로딩 중이면 인디케이터 표시, 아니면 빈 사이즈
          label: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
