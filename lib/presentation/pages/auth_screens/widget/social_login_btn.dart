import 'package:flutter/material.dart';

class SocialLoginBotton extends StatelessWidget {
  final String iconPath;
  final String label;
  final double size;
  final VoidCallback? onPressed;
  final SocialButtonStyle style;

  const SocialLoginBotton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.size,
    this.onPressed,
    this.style = SocialButtonStyle.capsule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Capsule shape
          ),
        ),
        child: Row(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: size,
              width: size,
            ),
            
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SocialButtonStyle {
  capsule,
  circular,
}