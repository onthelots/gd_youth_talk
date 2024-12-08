import 'package:flutter/material.dart';
import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';
import 'package:intl/intl.dart';

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.program,
  });

  final Program program;

  String formatDateTime(DateTime dateTime) {
    // 'yyyy-MM-dd HH:mm' 형식으로 포맷
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: double.infinity, // 페이지 뷰 너비
      height: double.infinity, // 페이지 뷰 높이
      child: Stack(
        alignment: Alignment.center, // Stack 전체 중앙정렬
        children: [

          // Right Contents (image)
          Positioned(
            right: 0,
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    program.thumbnailUrl,
                    width: 180, // 이미지 크기 조정
                    height: 180,
                    fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
                  ),
                ),
              ),
            ),
          ),

          // Left Contents
          Positioned(
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 200, // 현재 페이지 너비에서 이미지 Container Width 200(고정값) 뺀 값
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                    ),
                    child: Text(
                      program.category.displayName,
                    ),
                  ),

                  Text(
                    program.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // max line
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  // 위치 정보 텍스트, 하단에 고정
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.timer, color: Theme
                          .of(context)
                          .primaryColor,),

                      SizedBox(
                        width: 5,
                      ),

                      Text(
                        formatDateTime(program.date), // 날짜와 시간을 포맷하여 출력
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // max line
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
