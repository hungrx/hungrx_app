// lib/core/utils/responsive_utils.dart

import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double _getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Device size breakpoints
    const double extraSmallBreakpoint = 320;
    const double smallBreakpoint = 360;
    const double mediumBreakpoint = 400;
    
    if (width < extraSmallBreakpoint) return 0.8;  // Extra small devices
    if (width < smallBreakpoint) return 0.9;       // Small devices
    if (width < mediumBreakpoint) return 1.0;      // Medium devices
    return 1.1;                                    // Large devices
  }

  // Font size scaling
  static double getFontSize(BuildContext context, double baseSize) {
    return baseSize * _getScaleFactor(context);
  }

  // Padding scaling
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.symmetric(
      horizontal: width * 0.04,
      vertical: width * 0.02,
    );
  }

  // Custom padding scaling
  static EdgeInsets getCustomPadding(
    BuildContext context, {
    double horizontal = 0.04,
    double vertical = 0.02,
  }) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.symmetric(
      horizontal: width * horizontal,
      vertical: width * vertical,
    );
  }

  // Get responsive width
  static double getWidth(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  // Get responsive height
  static double getHeight(BuildContext context, double factor) {
    return MediaQuery.of(context).size.height * factor;
  }

  // Get device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 320) return DeviceType.extraSmall;
    if (width < 360) return DeviceType.small;
    if (width < 400) return DeviceType.medium;
    return DeviceType.large;
  }

  // Get screen size category
  static bool isExtraSmallScreen(BuildContext context) => 
      MediaQuery.of(context).size.width < 320;
  
  static bool isSmallScreen(BuildContext context) => 
      MediaQuery.of(context).size.width < 360;
  
  static bool isMediumScreen(BuildContext context) => 
      MediaQuery.of(context).size.width < 400;

  // Get responsive radius
  static double getRadius(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  // Get responsive spacing
  static double getSpacing(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get bottom navigation bar height
  static double getBottomNavigationBarHeight(BuildContext context) {
    return kBottomNavigationBarHeight * _getScaleFactor(context);
  }

  // Get app bar height
  static double getAppBarHeight(BuildContext context) {
    return kToolbarHeight * _getScaleFactor(context);
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context, double baseSize) {
    return baseSize * _getScaleFactor(context);
  }
}

// Enum for device types
enum DeviceType {
  extraSmall,
  small,
  medium,
  large,
}

// Extension to add convenient methods to BuildContext
extension ResponsiveExtension on BuildContext {
  // Screen size utilities
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  // Responsive getters
  double get scaleFactor => ResponsiveUtils._getScaleFactor(this);
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);
  bool get isExtraSmallScreen => ResponsiveUtils.isExtraSmallScreen(this);
  bool get isSmallScreen => ResponsiveUtils.isSmallScreen(this);
  bool get isMediumScreen => ResponsiveUtils.isMediumScreen(this);
  
  // Convenient methods
  double responsiveFontSize(double baseSize) => 
      ResponsiveUtils.getFontSize(this, baseSize);
  
  EdgeInsets get responsivePadding => 
      ResponsiveUtils.getResponsivePadding(this);
  
  double responsiveWidth(double factor) => 
      ResponsiveUtils.getWidth(this, factor);
  
  double responsiveHeight(double factor) => 
      ResponsiveUtils.getHeight(this, factor);
  
  double responsiveRadius(double factor) => 
      ResponsiveUtils.getRadius(this, factor);
  
  double responsiveSpacing(double factor) => 
      ResponsiveUtils.getSpacing(this, factor);
}