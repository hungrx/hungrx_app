import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class HeaderText extends StatelessWidget {
  final String mainHeading;
  final String subHeading;

  const HeaderText({super.key, required this.mainHeading, required this.subHeading});

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mainHeading,
                  style: const TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontColor,
                  ),
                ),
                Text(
                  subHeading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontColor,
                  ),
                ),
              ],
            );
  }
}