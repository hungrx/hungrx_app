import 'package:flutter/material.dart';

class SocialLoginBotton extends StatelessWidget {
  final String iconPath;
  final String label;
  final double? size;
  final void Function()? onPressed;
  const SocialLoginBotton({super.key, required this.iconPath, required this.label, this.size, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }
}
