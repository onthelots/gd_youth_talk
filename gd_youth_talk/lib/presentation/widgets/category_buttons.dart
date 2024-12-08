import 'package:flutter/material.dart';

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final void Function() onTap;

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
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: IconButton(
            icon: Icon(
              widget.icon,
              size: 25,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              widget.onTap();
            },
          ),
        ),

        const SizedBox(height: 4),

        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}