import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/utils.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramLocationRow extends StatelessWidget {
  final ProgramModel program;
  final Icon icon;

  const ProgramLocationRow({super.key, required this.program, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),

        // 프로그램 기간
        Text(
          '장소 : ${program.location}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}