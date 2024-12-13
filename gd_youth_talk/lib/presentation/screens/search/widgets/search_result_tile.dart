import 'package:flutter/material.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.program,
    required this.onTap,
  });

  final ProgramModel program;
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      title: Text(program.title ?? "", style: Theme.of(context).textTheme.labelLarge),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('위치: ${program.location}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          program.thumbnail ?? "",
          width: 65,
          height: 65,
          fit: BoxFit.cover,
        ),
      ),
      onTap: () {
        onTap?.call(program);
      },
    );
  }
}