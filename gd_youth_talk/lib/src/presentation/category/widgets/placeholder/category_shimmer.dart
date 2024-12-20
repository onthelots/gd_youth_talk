import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material( // Material 위젯을 추가
      color: Colors.transparent, // 배경색을 투명하게 설정
      child: InkWell(
        onTap: () {},
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            alignment: Alignment.center, // Stack 전체 중앙정렬
            children: [
              // Right Contents (image)
              Positioned(
                right: 13,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ),

              // Left Contents
              Positioned(
                left: 13,
                child: Container(
                  width: MediaQuery.of(context).size.width - 170,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 120,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
