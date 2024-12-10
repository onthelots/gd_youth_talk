import 'package:flutter/material.dart';

class BannerContainer extends StatelessWidget {
  final VoidCallback onTap; // program을 전달할 수 있는 탭 이벤트 핸들러

  const BannerContainer({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.teal,
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '더 자세한 정보를 알고싶다면?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '서울청년센터 강동 홈페이지 둘러보기',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.engineering,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
