// lib/presentation/pages/subscription_screen/widgets/subscription_plan_card.dart
import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    super.key,
    required this.subscription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: subscription.isPromoted
              ? LinearGradient(
                  colors: [
                    AppColors.buttonColors.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: Border.all(
            color: subscription.isPromoted
                ? AppColors.buttonColors
                : Colors.white24,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subscription.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (subscription.savings != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColors,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subscription.savings!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subscription.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // In your SubscriptionPlanCard build method
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.priceString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subscription.duration == 'year'
                          ? 'per year'
                          : subscription.duration == 'month'
                              ? 'per month'
                              : subscription.duration == 'week'
                                  ? 'for 7 days'
                                  : '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: subscription.isPromoted
                        ? AppColors.buttonColors
                        : Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    subscription.isPromoted
                        ? Icons.arrow_forward
                        : Icons.arrow_forward_outlined,
                    color:
                        subscription.isPromoted ? Colors.black : Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
