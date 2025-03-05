import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_state.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_state.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/active_subscriptiion_screen.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/feature_item_widget.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/google_play_account_error_dialog.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/legal_section_widget.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/widgets/subscription_plan_card.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool fromResultScreen;
  const SubscriptionScreen({super.key, this.fromResultScreen = false});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final String _privacyPolicyUrl = 'https://www.hungrx.com/privacy-policy.html';
  bool _isLoading = false;
  bool _isInitialLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    PurchaseService.debugOfferings();

    // First check subscription status, then load plans only if needed
    _checkInitialSubscriptionStatus().then((_) {
      // Only load subscription plans if we're still mounted and not already in an active state
      if (mounted && !_isActiveSubscription()) {
        _initializeAndLoadSubscriptions();
      }
    });
  }

  bool _isActiveSubscription() {
    final state = context.read<CheckStatusSubscriptionBloc>().state;
    return state is CheckSubscriptionActive;
  }

  // Debug function to log subscription state
  void _logSubscriptionState(SubscriptionState state) {
    print("🔍 SUBSCRIPTION STATE: ${state.runtimeType}");
    if (state is SubscriptionsLoaded) {
      print("🔍 Subscriptions count: ${state.subscriptions.length}");
      if (state.subscriptions.isEmpty) {
        print("⚠️ WARNING: Subscriptions list is empty!");
      } else {
        for (var sub in state.subscriptions) {
          print(
              "🔍 Subscription: ${sub.id} - ${sub.title} - ${sub.priceString}");
        }
      }
    }
  }

  Future<void> _checkInitialSubscriptionStatus() async {
    setState(() {
      _isInitialLoading = true;
    });

    final userId = await _authService.getUserId();
    if (userId != null && mounted) {
      context
          .read<CheckStatusSubscriptionBloc>()
          .add(CheckSubscription(userId));

      // Wait for the subscription check to complete
      await _waitForSubscriptionCheck();
    }

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _waitForSubscriptionCheck() {
    final completer = Completer<void>();

    // Create a subscription to the bloc state changes
    late final StreamSubscription subscription;
    subscription =
        context.read<CheckStatusSubscriptionBloc>().stream.listen((state) {
      if (state is! CheckSubscriptionLoading) {
        // The check is complete (either success, error, or inactive)
        subscription.cancel();
        completer.complete();
      }
    });

    // Also set a timeout in case the check takes too long
    Future.delayed(const Duration(seconds: 3), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }

  void _initializeAndLoadSubscriptions() {
    print("🔄 Initializing and loading subscriptions");
    // Only trigger initialization, which will now also load subscriptions
    BlocProvider.of<SubscriptionBloc>(context)
        .add(InitializeSubscriptionService());

    // Add a retry after a short delay if we suspect initialization might fail
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final state = context.read<SubscriptionBloc>().state;
        if (state is! SubscriptionsLoaded || (state.subscriptions.isEmpty)) {
          print("⚠️ Retry loading subscriptions after delay");
          BlocProvider.of<SubscriptionBloc>(context)
              .add(InitializeSubscriptionService());
        }
      }
    });
  }

  Future<void> purchaseSubscription(SubscriptionModel subscription) async {
    try {
      // Dispatch the purchase event to the BLoC instead of calling the service directly
      BlocProvider.of<SubscriptionBloc>(context)
          .add(PurchaseSubscription(subscription));
    } catch (e) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to purchase subscription: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      if (a.title.contains('Monthly') && !b.title.contains('Monthly')) {
        return -1;
      }
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

  Future<void> _handleLogout() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();

      if (mounted) {
        // Navigate to login screen
        GoRouter.of(context).go('/phoneNumber');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    if (!mounted) return;

    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: _isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(color: Colors.white),
                ),
          actions: _isLoading
              ? null
              : <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await _handleLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.fromResultScreen
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              )
            : IconButton(
                onPressed: _showLogoutConfirmationDialog,
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Premium Plans', style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
        child: _isInitialLoading
            // Show a consistent loading screen initially
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Checking subscription status...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            // Once initial loading is done, show the appropriate UI
            : BlocConsumer<CheckStatusSubscriptionBloc,
                CheckStatusSubscriptionState>(
                listener: (context, checkStatusState) {
                  if (checkStatusState is CheckSubscriptionLoading) {
                    setState(() => _isLoading = true);
                  } else {
                    setState(() => _isLoading = false);
                  }

                  if (checkStatusState is CheckSubscriptionError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(checkStatusState.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, checkStatusState) {
                  if (checkStatusState is CheckSubscriptionActive) {
                    return const ActiveSubscriptionWidget();
                  }

                  return BlocConsumer<SubscriptionBloc, SubscriptionState>(
                    listener: (context, state) {
                      _logSubscriptionState(state);

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
                        print('❌ Subscription error: ${state.message}');

                        // Check for Google Play account mismatch
                        if (state.message == 'GOOGLE_PLAY_ACCOUNT_MISMATCH') {
                          print('🎯 Showing Google Play account error dialog');
                          Future.microtask(() {
                            if (mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    GooglePlayAccountErrorDialog(),
                              ).then((_) => print('✅ Dialog closed'));
                            }
                          });
                        } else {
                          // Show regular error snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }

                      if (state is SubscriptionPurchased) {
                        // Enhanced Snackbar with animation, icon, and better styling
                        final snackBar = SnackBar(
                          content: Row(
                            children: [
                              // Add success icon
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.black,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              // Message with rich text styling
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Welcome to HungrX Premium!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Enjoy your personalized health journey.',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          backgroundColor:
                              AppColors.buttonColors.withOpacity(0.95),
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(12),
                          elevation: 6,
                          action: SnackBarAction(
                            label: 'EXPLORE',
                            textColor: Colors.black,
                            onPressed: () {
                              context.go('/home');
                            },
                          ),
                        );

                        // Show enhanced snackbar
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        // Add a slightly longer delay for better UX
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          // ignore: use_build_context_synchronously
                          context.go('/home');
                        });
                      }
                    },
                    builder: (context, state) {
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
                                  // const SizedBox(height: 32),

                                  // Subscription plans section with fixed syntax
                                  if (state is SubscriptionsLoaded) ...[
                                    if (state.subscriptions.isEmpty) ...[
                                      // Try to reload the offerings from the PurchaseService directly
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.sync_problem,
                                                color: Colors.amber, size: 48),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Subscription plans are currently unavailable',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'We detected your plans but couldn\'t load them properly',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 24),
                                            ElevatedButton(
                                              onPressed: () {
                                                print(
                                                    "🔄 Attempting direct offering reload");
                                                PurchaseService
                                                    .debugOfferings();
                                                _initializeAndLoadSubscriptions();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.buttonColors,
                                              ),
                                              child: const Text('Reload Plans'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      ..._getSortedSubscriptions(
                                          state.subscriptions),
                                    ],
                                  ] else if (state is SubscriptionError) ...[
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error_outline,
                                              color: Colors.red, size: 48),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Error loading subscription plans',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Error: ${state.message}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed:
                                                _initializeAndLoadSubscriptions,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.buttonColors,
                                            ),
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (state is! SubscriptionsLoaded &&
                                      !_isLoading) ...[
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.buttonColors),
                                          ),
                                          const SizedBox(height: 24),
                                          const Text(
                                            'Loading subscription plans...',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          const SizedBox(height: 16),
                                          TextButton(
                                            onPressed:
                                                _initializeAndLoadSubscriptions,
                                            child: const Text(
                                              'Retry loading plans',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.buttonColors),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  // const SizedBox(height: 24),
                                  LegalSectionWidget(
                                    privacyPolicyUrl: _privacyPolicyUrl,
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        title: const Text(
                                          'Subscription Management',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Access your subscription details, update payment methods, or cancel anytime',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Open system subscription management
                                                      PurchaseService
                                                          .manageSubscriptions();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .buttonColors,
                                                      foregroundColor:
                                                          Colors.black,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      elevation: 4,
                                                      shadowColor: AppColors
                                                          .buttonColors
                                                          .withOpacity(0.5),
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.settings),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Manage Subscription',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                  );
                },
              ),
      ),
    );
  }
}
