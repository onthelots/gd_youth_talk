import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.menuTitle,
    required this.onTap,
    this.trailing,
  });

  final String menuTitle;
  final Widget? trailing;
  final VoidCallback? onTap; // Nullable onTap

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0), // 좌우 여백 조정
      dense: true, // ListTile의 높이를 낮추는 옵션
      title: Text(
        menuTitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
          ),
      onTap: onTap != null // Null check before calling onTap
          ? () {
              onTap!(); // Call onTap safely
            }
          : null, // or provide a fallback if onTap is null
    );
  }
}
