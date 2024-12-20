import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // 페이지 뷰 높이
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // 보여줄 개수
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
