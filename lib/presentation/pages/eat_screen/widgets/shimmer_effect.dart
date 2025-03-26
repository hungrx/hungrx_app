import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EatScreenShimmer extends StatelessWidget {
  const EatScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer (Hi, Name)
            Container(
              width: size.width * 0.5,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // Calorie budget number
            Container(
              width: size.width * 0.3,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 8),

            // Calorie budget text
            Container(
              width: size.width * 0.45,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(height: size.height * 0.05),

            // Options Grid
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(size),
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: _buildOptionCard(size),
                ),
              ],
            ),

            // Spacer replacement - calculate remaining space
            SizedBox(height: size.height * 0.15),

            // Enjoy Calories text
            Container(
              width: size.width * 0.7,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            // Space for bottom navigation
            SizedBox(height: size.height * 0.08),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(Size size) {
    return Container(
      height: size.height * 0.28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              width: double.infinity,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            SizedBox(height: size.height * 0.01),

            // Subtitle
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const Spacer(),

            // Icon placeholder
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
