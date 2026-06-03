import 'package:flutter/material.dart';

//? THEME & IMAGES

//? OTHERS
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicProgressIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  final double percent;
  final String? label;
  final TextStyle? labelStyle;

  const DynamicProgressIndicator({
    super.key,
    this.label,
    this.labelStyle,

    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                label!,
                style:
                    labelStyle ??
                    textTheme.titleSmall?.copyWith(
                      color: AppColors.dark2,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),

        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          animation: true,
          lineHeight: 10,
          percent: percent,
          barRadius: Radius.circular(20),
          backgroundColor: AppColors.dark3,
          progressColor: AppColors.main,
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
