import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Subscription Screen'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          // fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16,top: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  ],
                ),
                const Text(
                  'Say hello to\nyour best self.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Members are up to 65% more likely to reach their goals with Premium.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
            
                // Features List
                // _buildFeatureItem('Barcode Scan', 'Skip the search and log faster'),
                // _buildFeatureItem('Custom Macro Tracking', 'Find your balance of carbs, protein & fat'),
                // _buildFeatureItem('Zero Ads', 'Track and reach your goals, distraction-free'),
                const SizedBox(height: 32),
            
                // Plan Selection Title
                const Text(
                  'Select the plan for you.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
            
                // Subscription Plans
                _buildPlanCard(
                  'Try 7 Days',
                  '99¢',
                  'Trial period',
                  true,
                  AppColors.buttonColors,
                  context,
                ),
                const SizedBox(height: 12),
                _buildPlanCard(
                  'YEARLY',
                  '\$20.00',
                  'Most popular',
                  false,
                  AppColors.buttonColors,
                  context,
                  savings: '58% SAVINGS',
                  originalPrice: '\$7.99/mo',
                ),
                const SizedBox(height: 12),
                _buildPlanCard(
                  'MONTHLY',
                  '\$7.99',
                  'Billed monthly',
                  false,
                  Colors.grey,
                  context,
                ),
            
                // const Spacer(),
                // Terms Text
                const Text(
                  'Billed at the start of every cycle. Plans renew automatically. Cancel via Google Play.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Subscribe Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add subscription logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColors,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue Premium',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildFeatureItem(String title, String description) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Row(
  //       children: [
  //         const Icon(
  //           Icons.star,
  //           color: Colors.amber,
  //           size: 24,
  //         ),
  //         const SizedBox(width: 12),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             Text(
  //               description,
  //               style: const TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPlanCard(
    String title,
    String price,
    String subtitle,
    bool isPromoted,
    Color accentColor,
    BuildContext context, {
    String? savings,
    String? originalPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isPromoted ? accentColor : Colors.white24,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isPromoted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isPromoted ? accentColor : Colors.white54,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (savings != null) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.buttonColors,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          savings,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (originalPrice != null)
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}