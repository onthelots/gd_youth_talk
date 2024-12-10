import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile({
    super.key,
    required this.program,
    required this.onTap,
  });

  final Program program;
  final Function(Program)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          program.thumbnailUrl,
          width: 65,
          height: 65,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        program.title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      subtitle: Text(
        program.time,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      trailing: Text(
        // TODO:- 현재 날짜 및 시간을 기준으로, '예정' 혹은 '진행 중', '종료'로 구분하여 trailing에 나타낼 것

        // TODO:- 또한, '종료' 시, 해당 Tile Widget의 투명도를 줄 것
        "예정",
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () {
       onTap?.call(program);
      },
    );
  }
}
