import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/utils.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class CategoryTile extends StatelessWidget {
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final ProgramModel program;

  // 사용자 지정 목록 타일의 생성자
  const CategoryTile({
    super.key,
    this.onTap,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 이벤트 핸들러가 있는 탭 가능 영역
      onTap: () => onTap?.call(program),

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
                width: 100,
                height: 100,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      program.thumbnail ?? "",
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
                height: 100, // 이미지 크기에 맞춤
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        program.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // max line
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    /// 위치정보
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Expanded(
                        child: Text(
                          program.location ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelSmall // max line
                        ),
                      ),
                    ]),

                    SizedBox(
                      height: 5,
                    ),

                    /// 날짜정보
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              program.programStartDate?.day !=
                                  program.programEndDate?.day
                                  ? '${formatDate(program.programStartDate ?? DateTime.now())} - ${formatDate(program.programEndDate ?? DateTime.now())}'
                                  : formatDate(program.programStartDate ??
                                  DateTime.now()),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.labelSmall // max lin// max line
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
