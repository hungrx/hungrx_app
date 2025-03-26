import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EatScreenShimmer extends StatelessWidget {
  const EatScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight * 0.7, // Minimum 70% of screen height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              _buildHeaderShimmer(screenWidth),
              SizedBox(height: screenHeight * 0.04), // 4% of screen height
              // Calorie budget shimmer
              _buildCalorieBudgetShimmer(screenWidth),
              SizedBox(height: screenHeight * 0.08), // 8% of screen height
              // Options grid shimmer
              _buildOptionsGridShimmer(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer(double screenWidth) {
    return Container(
      width: screenWidth * 0.5, // 50% of screen width
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildCalorieBudgetShimmer(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.3, // 30% of screen width
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: screenWidth * 0.45, // 45% of screen width
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsGridShimmer(double screenWidth, double screenHeight) {
    return Row(
      children: [
        Expanded(
          child: _buildOptionCardShimmer(screenHeight),
        ),
        SizedBox(width: screenWidth * 0.04), // 4% of screen width
        Expanded(
          child: _buildOptionCardShimmer(screenHeight),
        ),
      ],
    );
  }

  Widget _buildOptionCardShimmer(double screenHeight) {
    return Container(
      height: screenHeight * 0.35, // 35% of screen height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle shimmer
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            // Image placeholder shimmer
            Container(
              width: double.infinity,
              height: 120, // Fixed height for image placeholder
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
