import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartScreenShimmer extends StatelessWidget {
  const CartScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final padding = screenSize.width * 0.04;
    
    // Calculate responsive dimensions
    final nutritionBoxSize = isSmallScreen ? 70.0 : 80.0;
    final foodImageSize = isSmallScreen ? 70.0 : 80.0;
    final titleHeight = isSmallScreen ? 20.0 : 24.0;
    final subtitleHeight = isSmallScreen ? 12.0 : 14.0;
    final buttonHeight = isSmallScreen ? 40.0 : 48.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Nutrition Facts Card
            Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      width: screenSize.width * 0.5,
                      height: titleHeight,
                      color: Colors.white,
                    ),
                    SizedBox(height: padding),
                    
                    // Nutrition Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: nutritionBoxSize,
                          height: nutritionBoxSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: padding),
                    
                    // Info Rows
                    ...List.generate(
                      2,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: padding * 0.5),
                        child: Row(
                          children: [
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: padding * 0.5),
                            Container(
                              width: screenSize.width * 0.5,
                              height: subtitleHeight,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: padding),
                    
                    // Action Buttons
                    ...List.generate(
                      2,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: padding * 0.5),
                        child: Container(
                          width: double.infinity,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Food Items Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Container(
                width: screenSize.width * 0.25,
                height: titleHeight,
                color: Colors.white,
              ),
            ),
            
            // Food Items List
            ...List.generate(
              2,
              (index) => Padding(
                padding: EdgeInsets.all(padding),
                child: Container(
                  height: foodImageSize + (padding * 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Food Image
                      Container(
                        width: foodImageSize,
                        height: foodImageSize,
                        margin: EdgeInsets.all(padding * 0.75),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      
                      // Food Details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: padding * 0.75,
                            horizontal: padding * 0.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: screenSize.width * 0.4,
                                height: titleHeight * 0.7,
                                color: Colors.white,
                              ),
                              Container(
                                width: screenSize.width * 0.3,
                                height: subtitleHeight,
                                color: Colors.white,
                              ),
                              Container(
                                width: screenSize.width * 0.35,
                                height: subtitleHeight,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Quantity Controls
                      Container(
                        width: screenSize.width * 0.25,
                        padding: EdgeInsets.all(padding * 0.75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Container(
                            //   width: iconSize * 1.3,
                            //   height: iconSize,
                            //   color: Colors.white,
                            // ),
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Space for Calorie Bar
            SizedBox(height: screenSize.height * 0.1),
          ],
        ),
      ),
    );
  }
}