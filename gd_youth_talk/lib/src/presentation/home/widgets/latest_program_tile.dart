import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/core/utils.dart';
import 'package:shimmer/shimmer.dart';

class LatestProgramTile extends StatelessWidget {
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final ProgramModel program;

  const LatestProgramTile({
    super.key,
    required this.program,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => onTap?.call(program),
        onDoubleTap: () => onTap?.call(program),
        onLongPress: () => onTap?.call(program),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: getColorFromHex(program.primaryColor ?? '#FFFFFF').withOpacity(0.6), // opacity 적용
          ),
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
                      child: CachedNetworkImage(
                        imageUrl: program.thumbnail ?? "",
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey[300],
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),    // 에러 발생 시 표시
                      )
                    ),
                  ),
                ),
              ),

              // Left Contents
              Positioned(
                left: 13,
                child: Container(
                  width: MediaQuery.of(context).size.width - 220, // 현재 페이지 너비에서 이미지 Container Width 200(고정값) 뺀 값
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),

                      /// 타이틀
                      Expanded(
                        child: Text(
                          program.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // max line
                          style: TextStyle(
                              color: getTextColorBasedOnBackground(program.primaryColor ?? '#FFFFFF'),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      /// 위치정보
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Expanded(
                          child: Text(
                            program.location ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: getTextColorBasedOnBackground(program.primaryColor ?? '#FFFFFF'),
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ), // max line
                          ),
                        ),
                      ]),

                      SizedBox(
                        height: 10,
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
                                style: TextStyle(
                                    color: getTextColorBasedOnBackground(
                                        program.primaryColor ?? '#FFFFFF'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500), // max line
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
      ),
    );
  }
}
