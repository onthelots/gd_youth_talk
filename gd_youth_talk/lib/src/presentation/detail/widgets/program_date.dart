import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/utils.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class ProgramDateRow extends StatelessWidget {
  final ProgramModel program;
  final Icon icon;
  final String title;
  final bool isProgramDate; // true: 프로그램 날짜, false: 등록 날짜

  const ProgramDateRow({
    super.key,
    required this.program,
    required this.icon,
    required this.title,
    required this.isProgramDate,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? startDate = isProgramDate
        ? program.programStartDate
        : program.registrationStartDate;
    final DateTime? endDate = isProgramDate
        ? program.programEndDate
        : program.registrationEndDate;

    String dateText = startDate?.day != endDate?.day
        ? '${formatDate(startDate ?? DateTime.now())} - ${formatDate(endDate ?? DateTime.now())}'
        : '${formatDate(startDate ?? DateTime.now())}';

    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),

        // 날짜 텍스트
        Text(
          '$title : $dateText',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}