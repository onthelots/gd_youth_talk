import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.program,
    required this.query,
    required this.onTap,
  });

  final ProgramModel program;
  final Function(ProgramModel)? onTap; // program을 전달할 수 있는 탭 이벤트 핸들러
  final String query; // 검색어

  // 강조된 텍스트 생성 함수
  Widget _buildHighlightedText(String? text, String query, TextStyle? style) {
    if (text == null || text.isEmpty || query.isEmpty) {
      return Text(text ?? "", style: style);
    }

    final matches = RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);
    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final highlightedTextSpans = <TextSpan>[];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        highlightedTextSpans.add(TextSpan(text: text.substring(start, match.start), style: style));
      }
      highlightedTextSpans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: style?.copyWith(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ));
      start = match.end;
    }

    if (start < text.length) {
      highlightedTextSpans.add(TextSpan(text: text.substring(start), style: style));
    }

    return RichText(text: TextSpan(children: highlightedTextSpans));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      title: _buildHighlightedText(program.title, query, Theme.of(context).textTheme.labelLarge),
      subtitle: _buildHighlightedText(program.subtitle, query, Theme.of(context).textTheme.bodySmall),
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