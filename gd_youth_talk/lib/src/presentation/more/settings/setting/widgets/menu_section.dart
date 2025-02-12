import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/widgets/menu_tile.dart';

class MenuSection extends StatelessWidget {
  final String sectionTitle;
  final List<MenuTile> menuItem;

  MenuSection({
    required this.sectionTitle,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section title
          Text(
            sectionTitle,
            style: Theme.of(context).textTheme.labelMedium,
          ),

          SizedBox(
            height: 10,
          ),

          // ListView
          Column(
            children: menuItem.map((item) {
              return MenuTile(
                menuTitle: item.menuTitle,
                trailing: item.trailing,
                onTap: item.onTap != null
                    ? (context) => item.onTap!(context)
                    : null, // null 체크 후 안전하게 처리
              );
            }).toList(),
          ),

          Divider(
            height: 30.0,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
