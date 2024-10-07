import 'package:flutter/material.dart';

class ResponsiveTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double sizeFactor;

  const ResponsiveTextWidget({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontWeight = FontWeight.normal,
    this.sizeFactor = 0.05, // Default size factor, adjust as needed
  });

  double _getResponsiveFontSize(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate font size based on screen width and size factor
    return screenWidth * sizeFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: _getResponsiveFontSize(context),
      ),
    );
  }
}