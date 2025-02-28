import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
import 'package:intl/intl.dart';

class ActiveSubscriptionWidget extends StatelessWidget {
  const ActiveSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: PurchaseService.getActiveSubscriptionDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load subscription details',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    // Refresh the subscription details
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry',
                      style: TextStyle(color: AppColors.buttonColors)),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        final expirationDate = data['expirationDate'] != null
            ? DateTime.parse(data['expirationDate'])
            : null;
        final formattedDate = expirationDate != null
            ? DateFormat('MMM dd, yyyy').format(expirationDate)
            : 'N/A';

        // Extract product ID to determine subscription type
        final productId = data['productIdentifier'] as String;
        final isAnnual = productId.contains('annual');
        final isMonthly = productId.contains('monthly');
        final isTrial =
            productId.contains('trial') || productId.contains('7day');

        String planType = isAnnual
            ? 'Annual Plan'
            : isMonthly
                ? 'Monthly Plan'
                : isTrial
                    ? 'Trial Plan'
                    : 'Premium Plan';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Smaller gradient container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A0CA3), Color(0xFF4361EE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.star,
                              color: Colors.amber, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Active Subscription',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                planType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                        Icons.calendar_today, 'Renewal Date', formattedDate),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.autorenew, 'Auto Renewal',
                        data['willRenew'] == true ? 'On' : 'Off'),
                  ],
                ),
              ),

              // Plan Information Section

              // Premium Features Section
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Features',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      Icons.restaurant,
                      'Personalized Meal Suggestions',
                    ),
                    _buildFeatureItem(
                      Icons.restaurant_menu,
                      'Nearby Restaurant Integration',
                    ),
                    _buildFeatureItem(
                      Icons.local_dining,
                      'Real-Time Calorie Tracking',
                    ),
                    _buildFeatureItem(
                      Icons.analytics,
                      'Advanced Health Analytics',
                    ),
                  ],
                ),
              ),

              // Manage subscription button
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Open system subscription management
                  PurchaseService.manageSubscriptions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColors,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.buttonColors.withOpacity(0.5),
                ),
                child: const Text(
                  'Manage Subscription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Support option
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
