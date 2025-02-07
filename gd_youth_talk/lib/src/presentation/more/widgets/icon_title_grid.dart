import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';

class IconTitleGrid extends StatelessWidget {
  final List<IconTitleItem> items;

  const IconTitleGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black12
            : Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () => item.onTap(context), // 변경된 부분
            borderRadius: BorderRadius.circular(5),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 35,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}