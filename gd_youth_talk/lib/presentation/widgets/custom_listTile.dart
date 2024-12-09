import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

class CustomListTile extends StatelessWidget {
  final Function(Program)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final Program program;

  // 사용자 지정 목록 타일의 생성자
  const CustomListTile({
    super.key,
    this.onTap,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // 이벤트 핸들러가 있는 탭 가능 영역
        onTap: () => onTap?.call(program), // program을 전달하며 탭 이벤트 핸들러 호출
        onDoubleTap: () => onTap?.call(program), // program을 전달하며 두 번 탭 이벤트 핸들러 호출
        onLongPress: () => onTap?.call(program), // program을 전달하며 길게 누름 이벤트 핸들러 호출

        // 목록 타일의 크기 제한
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            alignment: Alignment.center, // Stack 전체 중앙정렬
            children: [
              // Right Contents (image)
              Positioned(
                right: 13,
                child: Container(
                  width: 130,
                  height: 130,
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
                  width: MediaQuery.of(context).size.width - 170,
                  // 현재 페이지 너비에서 이미지 Container Width 200(고정값) 뺀 값
                  height: 130, // 이미지 크기에 맞춤
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.subtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // max line
                        style: Theme.of(context).textTheme.bodySmall,
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).highlightColor,
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            style: Theme.of(context).textTheme.labelSmall,
                            program.location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // max line
                          ),
                        ],
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
