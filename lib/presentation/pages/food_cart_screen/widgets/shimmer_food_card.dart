import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFoodCard extends StatelessWidget {
  final double screenWidth;

  const ShimmerFoodCard({
    super.key,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = screenWidth < 360;
    final double horizontalMargin = screenWidth * 0.04;
    final double verticalMargin = screenWidth * 0.02;
    final double padding = screenWidth * 0.03;
    final double imageSize = isSmallScreen ? 60.0 : 80.0;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Row(
          children: [
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: isSmallScreen ? 13 : 15,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: isSmallScreen ? 12 : 14,
                    width: screenWidth * 0.3,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: isSmallScreen ? 10 : 12,
                    width: screenWidth * 0.25,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              width: isSmallScreen ? 80 : 100,
              height: isSmallScreen ? 30 : 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}