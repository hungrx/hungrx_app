import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/custom_button.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;
  final String buttonText;

  const NavigationButtons({
    super.key,
    this.onBackPressed,
    this.onNextPressed,  this.buttonText= "Next",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onBackPressed ?? () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColors,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(14),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        CustomNextButton(
         btnName: buttonText,
          onPressed: onNextPressed!,
            
          height: 50,
        ),
      ],
    );
  }
}
