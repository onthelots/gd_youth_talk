import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:shimmer/shimmer.dart';

class Section extends StatelessWidget {
  final String sectionTitle;
  final List<ProgramModel> programs;
  final VoidCallback? onMorePressed; // 더보기 버튼 클릭 시 호출되는 콜백 이벤트

  Section({
    required this.sectionTitle,
    required this.programs,
    this.onMorePressed, // 콜백 함수 전달
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section text
          Row(
            children: [
              Text(
                sectionTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Spacer(), // 버튼을 오른쪽 끝으로 밀어줍니다
              TextButton(
                onPressed: onMorePressed, // 버튼 클릭 시 콜백 호출
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소화하여 텍스트와 아이콘만 포함되도록 설정
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '더보기',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right, // 오른쪽 화살표 아이콘
                      color: Theme.of(context).disabledColor,
                      size: 16, // 아이콘 크기
                    ),
                  ],
                ),
              )
            ],
          ),

          // ListView
          SizedBox(
            height: 200, // 명확한 높이 지정
            child: ListView.builder(
              shrinkWrap: true, // 콘텐츠 크기에 따라 높이 결정
              scrollDirection: Axis.horizontal,
              itemCount: programs.length, // item 갯수
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ProgramSectionListTile(
                    program: programs[index],
                    index: index,
                    onTap: (program) async {
                      Navigator.pushNamed(context, Routes.programDetail,
                          arguments: program);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramSectionListTile extends StatelessWidget {
  final ProgramModel program;
  final int index;
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러

  ProgramSectionListTile({
    required this.program,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onTap?.call(program), // program을 전달하며 탭 이벤트 핸들러 호출
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: program.thumbnail ?? "",
                    width: 120, // 이미지 크기 조정
                    height: 120,
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
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Text(
                  program.title ?? "",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // max line
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
