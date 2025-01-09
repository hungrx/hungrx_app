import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_state.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/dashboard_widgets.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/streak_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _calorieController = StreamController<double>.broadcast();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    _fetchData();
  }

  @override
  void dispose() {
    _calorieController.close();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    context.read<HomeBloc>().add(RefreshHomeData());
  }

  void updateCalories(double newValue) {
    _calorieController.add(newValue);
  }

  Widget _buildErrorView(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tileColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your dashboard...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      await _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dashboard updated!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to refresh. Please try again.'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _handleRefresh,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _fetchData,
                  textColor: Colors.white,
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return _buildLoadingView();
          }

          if (state is HomeError) {
            return _buildErrorView(
              state.message,
              _fetchData,
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardWidgets.buildHeader(state.homeData, context),
                        const SizedBox(height: 12),
                        DashboardWidgets.buildCalorieCounter(
                          state.homeData,
                          _calorieController.stream,
                        ),
                        const SizedBox(height: 12),
                        DashboardWidgets.buildDailyTargetAndRemaining(
                          state.homeData,
                          context,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Streak Calendar with flex
                            const Expanded(
                              flex: 3,
                              child: StreakCalendar(),
                            ),
                            const SizedBox(width: 12),

                            // when user tap on this container show the water screen
                            // Replace the existing GestureDetector with this updated version
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                 context.push('/water-intake');
                                },
                                child: Container(
                                  // Use MediaQuery for responsive height
                                  height: MediaQuery.of(context).size.height *
                                      0.266,
                                  // Min height to ensure visibility
                                  constraints: const BoxConstraints(
                                    minHeight: 200,
                                    maxHeight: 300,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.tileColor,
                                    borderRadius: BorderRadius.circular(20),
                                    // Add subtle border for better visibility
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        LucideIcons.glassWater,
                                        color: Color(0xFFB4D147),
                                        size: 64,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Water Intake',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Optional: Add current water intake if available
                                      // Text(
                                      //   '0/2L',
                                      //   style: TextStyle(
                                      //     color: Colors.white.withOpacity(0.7),
                                      //     fontSize: 14,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        DashboardWidgets.buildBottomButtons(
                          context,
                          state.homeData,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return _buildErrorView(
            'Something unexpected happened',
            _fetchData,
          );
        },
      ),
    );
  }
}
