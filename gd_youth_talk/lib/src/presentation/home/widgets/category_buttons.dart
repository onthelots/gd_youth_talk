import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final Color color;
  final VoidCallback onTap;

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.lightCategoryButton
                : AppColors.darkCategoryButton,
          ),
          child: IconButton(
            icon: Icon(
              widget.icon,
              size: 25,
              color: widget.color,
            ),
            onPressed: () {
              widget.onTap();
            },
          ),
        ),

        const SizedBox(height: 10),

        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}