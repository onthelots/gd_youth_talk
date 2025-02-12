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
  final void Function(BuildContext context)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0), // 좌우 여백 조정
      dense: true, // ListTile의 높이를 낮추는 옵션
      title: Text(
        menuTitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
          ),
      onTap: onTap != null
          ? () => onTap!(context) // onTap이 null이 아닐 때만 호출
          : null, // onTap이 null이면 아무 동작도 하지 않음
    );
  }
}
