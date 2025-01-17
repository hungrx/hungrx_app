import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_bloc.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_event.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_state.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_state.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/animated_calorie_count.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/dashboard_widgets.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/metric_dialogbox.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/shimmer_effect.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/streak_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _calorieController = StreamController<double>.broadcast();
  Timer? _refreshTimer;

  static double getFontSize(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  static double getPadding(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  static double getIconSize(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  late SharedPreferences _prefs;
  final String _lastDialogDateKey = 'last_dialog_date';

  @override
  void initState() {
    super.initState();
    // Initialize everything in sequence
    _initializeAndFetch();
  }

  Future<void> _initializeAndFetch() async {
    try {
      await _initializePrefs();
      if (!mounted) return;

      await _fetchMetrics();
      if (!mounted) return;

      await _fetchData();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  void dispose() {
    _calorieController.close();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchMetrics() async {
    if (!mounted) return;

    print('Fetching metrics');
    context.read<CalorieMetricsBloc>().add(FetchCalorieMetrics());

    // Wait for the metrics to be loaded
    bool metricsLoaded = false;
    await for (final state in context.read<CalorieMetricsBloc>().stream) {
      if (state is CalorieMetricsLoaded) {
        metricsLoaded = true;
        _checkAndShowDialog();
        break;
      }
    }

    // Add timeout to prevent infinite waiting
    if (!metricsLoaded) {
      print('Metrics loading timed out');
    }
  }

  Future<void> _checkAndShowDialog() async {
    final String today = DateTime.now().toIso8601String().split('T')[0];
    final String? lastShownDate = _prefs.getString(_lastDialogDateKey);

    print('Checking dialog - Last shown: $lastShownDate, Today: $today');

    // Show dialog if:
    // 1. Never shown before (lastShownDate is null)
    // 2. Last shown date is different from today
    if (lastShownDate == null || lastShownDate != today) {
      await _prefs.setString(_lastDialogDateKey, today);
      if (mounted) {
        _showMetricsDialog();
      }
    }
  }

  void _showMetricsDialog() {
    print('Attempting to show metrics dialog');

    if (!mounted) return;

    final state = context.read<CalorieMetricsBloc>().state;
    if (state is CalorieMetricsLoaded) {
      print('Showing dialog with metrics: ${state.metrics.consumedCalories}');

      showDialog(
        context: context,
        builder: (context) => MetricsDialog(
          consumedCalories: state.metrics.consumedCalories,
          dailyTargetCalories: state.metrics.dailyTargetCalories,
          remainingCalories: state.metrics.remainingCalories,
          goalMessage: state.metrics.message,
          weightChangeRate: state.metrics.weightChangeRate,
          caloriesToReachGoal: state.metrics.caloriesToReachGoal,
          dailyWeightLoss: state.metrics.dailyWeightLoss,
          ratio: state.metrics.ratio,
          goal: state.metrics.goal, // or "lose weight"
          daysLeft: state.metrics.daysLeft,
          date: state.metrics.date,
        ),
      );
    } else {
      print('Cannot show dialog: State is not loaded (${state.runtimeType})');
    }
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    context.read<HomeBloc>().add(RefreshHomeData());
  }

  void updateCalories(double newValue) {
    _calorieController.add(newValue);
  }

  // Add this method
  Future<void> resetLastShownDate() async {
    print("he;;");
    await _prefs.remove(_lastDialogDateKey);
  }

  Widget _buildErrorView(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: getIconSize(context, 0.12),
            color: Colors.red[300],
          ),
          SizedBox(height: getPadding(context, 0.04)),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: getFontSize(context, 0.04),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: getPadding(context, 0.04)),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(
              LucideIcons.refreshCw,
              size: getIconSize(context, 0.05),
            ),
            label: Text(
              'Try Again',
              style: TextStyle(
                fontSize: getFontSize(context, 0.04),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tileColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: getPadding(context, 0.04),
                vertical: getPadding(context, 0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const DashboardShimmer();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<CalorieMetricsBloc, CalorieMetricsState>(
        listener: (context, state) {
          print('BlocListener state: $state'); // Debug print
          if (state is CalorieMetricsLoaded) {
            print('Metrics loaded in listener'); // Debug print
          }
        },
        child: BlocConsumer<HomeBloc, HomeState>(
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
              return _buildErrorView(state.message, _fetchData);
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(getPadding(context, 0.03)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardWidgets.buildHeader(state.homeData, context),
                          SizedBox(height: getPadding(context, 0.03)),
                          buildCalorieCounter(
                            state.homeData,
                            _calorieController.stream,
                          ),
                          SizedBox(height: getPadding(context, 0.03)),
                          DashboardWidgets.buildDailyTargetAndRemaining(
                            state.homeData,
                            context,
                          ),
                          SizedBox(height: getPadding(context, 0.03)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                flex: 3,
                                child: StreakCalendar(),
                              ),
                              SizedBox(width: getPadding(context, 0.03)),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push('/water-intake');
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        (isSmallScreen ? 0.24 : 0.27),
                                    constraints: BoxConstraints(
                                      minHeight: screenWidth * 0.5,
                                      maxHeight: screenWidth * 0.75,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.tileColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          LucideIcons.glassWater,
                                          color: const Color(0xFFB4D147),
                                          size: getIconSize(context, 0.16),
                                        ),
                                        SizedBox(
                                            height: getPadding(context, 0.03)),
                                        Text(
                                          'Water Intake',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize:
                                                getFontSize(context, 0.04),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: getPadding(context, 0.03)),
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
      ),
    );
  }

  static Widget buildCalorieCounter(
      HomeData data, Stream<double>? calorieStream) {
    // print(data.goalHeading);
    // print(data.caloriesToReachGoal);
    return Builder(builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: getPadding(context, 0.04),
          vertical: getPadding(context, 0.02),
        ),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.goalHeading,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getFontSize(context, 0.045),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    AnimatedFlipCounter(
                      thousandSeparator: ',',
                      value: data.daysToReachGoal,
                      textStyle: GoogleFonts.stickNoBills(
                        color: Colors.white,
                        fontSize:
                            getFontSize(context, isSmallScreen ? 0.08 : 0.085),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 0,
                        left: getPadding(context, 0.01),
                        top: getPadding(context, 0.025),
                      ),
                      child: Text(
                        ' Days',
                        style: GoogleFonts.stickNoBills(
                          color: Colors.grey,
                          fontSize: getFontSize(context, 0.04),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            AnimatedCalorieDisplay(initialData: data),
          ],
        ),
      );
    });
  }
}
