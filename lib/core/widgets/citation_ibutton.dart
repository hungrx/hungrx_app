import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/citation_dialog.dart';

class InfoButton extends StatelessWidget {
  final String metricType;
  final double size;
  final Color? color;
  final bool compact;

  const InfoButton({

    super.key,

    required this.metricType,
    this.size = 20,
    this.color, 
    required this.compact,
  });

  @override
@override
Widget build(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: () => CitationDialog.show(context, metricType),
        borderRadius: BorderRadius.circular(20),
        child:  Container(
          padding:  EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: !compact ? BoxDecoration(
            border:  Border.all(
              color: color ?? AppColors.buttonColors.withOpacity(0.7),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ):BoxDecoration(
            border:  Border.all(
              color: color ?? AppColors.buttonColors.withOpacity(0.7),
              width: 0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: !compact ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: color ?? AppColors.buttonColors.withOpacity(0.7),
                size: size,
              ),
              const SizedBox(width: 2),
              Text(
                'Citations',
                style: TextStyle(
                  color: color ?? AppColors.buttonColors.withOpacity(0.7),
                  fontSize: size * 0.5, // Scale text size relative to icon size
                ),
              ),
            ],
          ):Icon(
                Icons.info_outline,
                color: color ?? AppColors.buttonColors.withOpacity(0.7),
                size: size,
              ),
        ),
      ),
    ],
  );
}
}