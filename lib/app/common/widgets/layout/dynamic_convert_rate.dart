import 'package:flutter/material.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class DynamicConverRate extends StatelessWidget implements PreferredSizeWidget {
  final String label;

  const DynamicConverRate({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 4,
      children: [
        Text(
          "Tarifa dinámica \n$label",
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
