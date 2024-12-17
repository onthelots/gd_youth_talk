import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class Section extends StatelessWidget {
  final List<ProgramModel> programs;

  Section({
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Section text
          Text(
            programs.first.category ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
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
                    onTap: (program) {
                      Navigator.pushNamed(context, Routes.programDetail, arguments: program);
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
                  child: Image.network(
                    program.thumbnail ?? "",
                    width: 120, // 이미지 크기 조정
                    height: 120,
                    fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
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
                  maxLines: 2, // max line
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
