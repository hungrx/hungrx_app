// lib/core/utils/size_utils.dart
import 'package:flutter/material.dart';

class SizeUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  
  // Initialize in the beginning
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }
  
  // Get responsive width (based on design width of 375)
  static double getWidth(double width) {
    return (width / 375.0) * screenWidth;
  }
  
  // Get responsive height (based on design height of 812)
  static double getHeight(double height) {
    return (height / 812.0) * screenHeight;
  }
  
  // Get responsive font size
  static double getFontSize(double size) {
    return getWidth(size);
  }
}

// Extension methods for easy use
extension ResponsiveSize on num {
  // For width
  double get w => SizeUtils.getWidth(toDouble());
  
  // For height
  double get h => SizeUtils.getHeight(toDouble());
  
  // For font size
  double get fs => SizeUtils.getFontSize(toDouble());
}