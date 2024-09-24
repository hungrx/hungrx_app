import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomNewUserText extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onCreateAccountTap;
  final Color textColor;
  final Color linkColor;
  final double fontSize;

  const CustomNewUserText({
    super.key,
    required this.onCreateAccountTap,
    this.textColor = const Color(0xFFAAAAAA),  // Default grey color
    this.linkColor = const Color(0xFFB4EC51),  // Default green color
    this.fontSize = 14, required this.text, required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: textColor, fontSize: fontSize),
          children: [
             TextSpan(text: text),
            TextSpan(
              text: buttonText,
              style: TextStyle(
                color: linkColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onCreateAccountTap,
            ),
          ],
        ),
      ),
    );
  }
}