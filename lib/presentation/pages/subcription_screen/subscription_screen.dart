import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_state.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/feature_item_widget.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/legal_section_widget.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/subscription_plan_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final String _privacyPolicyUrl = 'https://www.hungrx.com/privacy-policy.html';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    PurchaseService.debugOfferings();
    _initializeAndLoadSubscriptions();
  }

void _initializeAndLoadSubscriptions() {
  // Only trigger initialization, which will now also load subscriptions
  BlocProvider.of<SubscriptionBloc>(context).add(InitializeSubscriptionService());
}

 Future<bool> purchaseSubscription(SubscriptionModel subscription) async {
  try {
    print("Purchasing subscription: ${subscription.id} with product ID: ${subscription.package.storeProduct.identifier}");
    return await PurchaseService.purchasePackage(subscription.package);
  } catch (e) {
    print('❌ Error purchasing subscription: $e');
    rethrow;
  }
}

  // Helper method to get sorted subscriptions
  List<Widget> _getSortedSubscriptions(List<SubscriptionModel> subscriptions) {
    // Sort subscriptions by priority: Trial -> Annual -> Monthly
    final sortedSubscriptions = List<SubscriptionModel>.from(subscriptions);
    sortedSubscriptions.sort((a, b) {
      // Trial plans first
      if (a.title.contains('Trial') && !b.title.contains('Trial')) return -1;
      if (!a.title.contains('Trial') && b.title.contains('Trial')) return 1;

      // Then Annual (since it's best value)
      if (a.title.contains('Annual') && !b.title.contains('Annual')) return -1;
      if (!a.title.contains('Annual') && b.title.contains('Annual')) return 1;

      // Then Monthly
      if (a.title.contains('Monthly') && !b.title.contains('Monthly'))
        return -1;
      if (!a.title.contains('Monthly') && b.title.contains('Monthly')) return 1;

      return 0;
    });

    return sortedSubscriptions.map((subscription) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: SubscriptionPlanCard(
          subscription: subscription,
          onTap: () => purchaseSubscription(subscription),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Premium Plans', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // Add at the bottom of your app bar
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<SubscriptionBloc>(context)
                  .add(RestorePurchases());
            },
            child: const Text(
              'Restore',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            print("Current subscription state: ${state.runtimeType}");
            if (state is SubscriptionLoading) {
              setState(() {
                _isLoading = true;
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }

            if (state is SubscriptionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is SubscriptionPurchased) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Welcome to HungrX Premium! Enjoy your personalized health journey.'),
                  backgroundColor: AppColors.buttonColors,
                  duration: Duration(seconds: 2),
                ),
              );
              context.go('/dashboard');
            }
          },
          builder: (context, state) {
            print("Building UI for state: ${state.runtimeType}");
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          'Smarter Eating\nMade Simple',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Take control of your meals',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const FeatureItemWidget(
                          title: 'Personalized Meal Suggestions',
                          description:
                              'Get food recommendations based on your calorie goals.',
                          icon: Icons.restaurant,
                        ),
                        const FeatureItemWidget(
                          title: 'Nearby Restaurant Integration',
                          description:
                              'Discover meals from local restaurants with nutrition details.',
                          icon: Icons.restaurant_menu,
                        ),
                        const FeatureItemWidget(
                          title: 'Real-Time Calorie Tracking',
                          description:
                              'Monitor your intake and adjust as you go.',
                          icon: Icons.local_dining,
                        ),
                        const SizedBox(height: 32),

                        // Subscription plans section
                        if (state is SubscriptionsLoaded)
                          if (state.subscriptions.isEmpty)
                          
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.red, size: 48),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Unable to load subscription plans',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Please check your connection and try again',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _initializeAndLoadSubscriptions,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.buttonColors,
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children:
                                  _getSortedSubscriptions(state.subscriptions),
                            ),
                        // Retry button if plans aren't loaded yet
                        if (state is! SubscriptionsLoaded && !_isLoading)
                          Center(
                            child: TextButton(
                              onPressed: _initializeAndLoadSubscriptions,
                              child: const Text(
                                'Retry loading plans',
                                style: TextStyle(color: AppColors.buttonColors),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        LegalSectionWidget(
                          privacyPolicyUrl: _privacyPolicyUrl,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                // Loading overlay
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.buttonColors),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
  
}
