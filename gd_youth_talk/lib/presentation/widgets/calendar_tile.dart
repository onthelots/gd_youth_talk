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
    return Material(
      child: InkWell(
        onTap: () => onTap?.call(program), // program을 전달하며 탭 이벤트 핸들러 호출,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),

          leading: Container(
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
          trailing: Text(
            program.time,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
