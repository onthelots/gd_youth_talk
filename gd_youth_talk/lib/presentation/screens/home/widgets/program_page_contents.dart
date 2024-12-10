import 'package:flutter/material.dart';
import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';
import 'package:gd_youth_talk/core/theme.dart';
import 'package:intl/intl.dart';

class PageContent extends StatelessWidget {
  final Function(Program)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final Program program;

  const PageContent({
    super.key,
    required this.program,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(

      child: InkWell(
        onTap: () => onTap?.call(program), // program을 전달하며 탭 이벤트 핸들러 호출
        onDoubleTap: () => onTap?.call(program), // program을 전달하며 두 번 탭 이벤트 핸들러 호출
        onLongPress: () => onTap?.call(program), // program을 전달하며 길게 누름 이벤트 핸들러 호출

        child: Container(
          // TODO: - Card 배경색 설정 -> thumbnail 이미지를 기반으로 메인 색상을 가져오는걸로..?
          color: Theme.of(context).cardColor,
          width: double.infinity, // 페이지 뷰 너비
          height: double.infinity, // 페이지 뷰 높이
          child: Stack(
            alignment: Alignment.center, // Stack 전체 중앙정렬
            children: [

              // Right Contents (image)
              Positioned(
                right: 13,
                child: Container(
                  width: 150,
                  height: 150,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        program.thumbnailUrl,
                        width: 150, // 이미지 크기 조정
                        height: 150,
                        fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
                      ),
                    ),
                  ),
                ),
              ),

              // Left Contents
              Positioned(
                left: 13,
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
                          backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).highlightColor),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                          minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                        ),
                        child: Text(
                          program.category.displayName,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),

                      Text(
                        program.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // max line
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      // 위치 정보 텍스트, 하단에 고정
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 15.0,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          style: Theme.of(context).textTheme.labelSmall,
                          program.formatDateTime(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // max line
                        ),
                      ]),
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
