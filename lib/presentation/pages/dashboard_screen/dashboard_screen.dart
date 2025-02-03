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
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/weight_reminder_dialg.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/weight_reminder_manager.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/welcome_dialog.dart';
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
  bool _isInitialized = false;
  static const String _firstTimeKey = 'is_first_time_user';
  static const String _accountCreationDateKey = 'account_creation_date';

  @override
  void initState() {
    super.initState();
    // Single initialization point
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      if (_isInitialized) return;
      _isInitialized = true;

      // 1. Initialize preferences first
      await _initializePrefs();
      if (!mounted) return;

      // 2. Check first time user status
      bool isFirstTime = _prefs.getBool(_firstTimeKey) ?? true;

      // 3. Fetch initial data
      context.read<HomeBloc>().add(RefreshHomeData());

      // 4. Handle first time user flow
      if (isFirstTime) {
        await for (final state in context.read<HomeBloc>().stream) {
          if (state is HomeLoaded) {
            if (mounted) {
              // Set first time flag immediately
              await _prefs.setBool(_firstTimeKey, false);
              await _prefs.setString(
                  _accountCreationDateKey, state.homeData.calculationDate);

              // Show welcome dialog
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const WelcomeDialog(),
              );
            }
            break;
          }
          if (state is HomeError) {
            _isInitialized = false; // Allow retry on error
            break;
          }
        }
      }

      // 5. Initialize other components
      if (mounted) {
        // Fetch metrics
        final metricsBloc = context.read<CalorieMetricsBloc>();
        metricsBloc.add(FetchCalorieMetrics());

        // Wait for metrics and show dialog if needed
        await for (final state in metricsBloc.stream) {
          if (state is CalorieMetricsLoaded) {
            if (!isFirstTime) {
              // Only show metrics dialog for returning users
              await _checkAndShowDialog();
            }
            break;
          }
          if (state is CalorieMetricsError) break;
        }

        // Check weight reminder last
        await _checkWeightReminder();
      }
    } catch (e) {
      print('Initialization error: $e');
      _isInitialized = false;
    }
  }

// Future<void> _handleFirstTimeUser(String calculationDate) async {
//   bool isFirstTime = _prefs.getBool(_firstTimeKey) ?? true;

//   if (isFirstTime) {
//       await _prefs.setBool(_firstTimeKey, false);
//     await _prefs.setString(_accountCreationDateKey, calculationDate);

//     if (mounted) {
//       await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const WelcomeDialog(),
//       );
//     }
//     return;
//   }
// }

  Future<void> _checkAndShowDialog() async {
    if (!mounted) return;

    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      String calculationDate = state.homeData.calculationDate;
      DateTime accountCreationDate = _parseDate(calculationDate);
      DateTime now = DateTime.now();
      String today = now.toIso8601String().split('T')[0];
      String? lastShownDate = _prefs.getString(_lastDialogDateKey);

      // Don't show metrics dialog on account creation date
      if (_isSameDay(accountCreationDate, now)) {
        return;
      }

      // Show metrics dialog only if it hasn't been shown today
      if (lastShownDate != today) {
        await _prefs.setString(_lastDialogDateKey, today);
        if (mounted) {
          _showMetricsDialog();
        }
      }
    }
  }

  Future<void> _checkWeightReminder() async {
    // Wait for screen to load
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      String calculationDate = state.homeData.calculationDate;
      DateTime accountCreationDate = _parseDate(calculationDate);
      DateTime now = DateTime.now();

      // Don't show weight reminder on the first day
      if (_isSameDay(accountCreationDate, now)) {
        return;
      }

      final shouldShow = await WeightReminderManager.shouldShowReminder();
      if (shouldShow) {
        final lastUpdate = await WeightReminderManager.getLastWeightUpdate();
        _showWeightReminderDialog(lastUpdate);
      }
    }
  }

  DateTime _parseDate(String date) {
    // Assuming date format is "dd/MM/yyyy"
    List<String> parts = date.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }

  // Helper method to compare dates
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _showWeightReminderDialog(DateTime lastUpdate) async {
    if (!mounted) return;

    // Update last reminder shown time
    await WeightReminderManager.updateLastReminderShown();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WeightReminderDialog(
        lastWeightUpdate: lastUpdate,
      ),
    );

    if (result == true && mounted) {
      // Navigate to weight picker screen
      await context.push('/weight-picker');

      // After returning from weight picker, update the last weight update time
      await WeightReminderManager.updateLastWeightUpdate();

      // Refresh dashboard data
      if (mounted) {
        context.read<HomeBloc>().add(RefreshHomeData());
      }
    }
  }

  // Future<void> _initializeAndFetch() async {
  //   if (_isInitialized) return;

  //   try {
  //     _isInitialized = true;
  //     await _initializePrefs();
  //     if (!mounted) return;

  //     // Fetch both metrics and home data concurrently
  //     await Future.wait([
  //       _fetchMetricsAndShowDialog(),
  //       _fetchData(),
  //     ]);
  //   } catch (e) {
  //     print('Initialization error: $e');
  //     _isInitialized = false;
  //   }
  // }

  Future<void> _fetchMetricsAndShowDialog() async {
    if (!mounted) return;

    final metricsBloc = context.read<CalorieMetricsBloc>();
    metricsBloc.add(FetchCalorieMetrics());

    // Wait for metrics to load
    await for (final state in metricsBloc.stream) {
      if (state is CalorieMetricsLoaded) {
        await _checkAndShowDialog();
        break;
      }
      if (state is CalorieMetricsError) {
        break;
      }
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
    // Ensure we have the keys initialized
    if (!_prefs.containsKey(_firstTimeKey)) {
      await _prefs.setBool(_firstTimeKey, true);
    }
  }

  void _showMetricsDialog() {
    print('Attempting to show metrics dialog');

    if (!mounted) return;

    final state = context.read<CalorieMetricsBloc>().state;
    if (state is CalorieMetricsLoaded) {
      print('Showing dialog with metrics: ${state.metrics.consumedCalories}');
      print(state.metrics.goal);
      showDialog(
        context: context,
        builder: (context) => MetricsDialog(
          isMaintain: state.metrics.goal == 'maintain',
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
      await Future.wait([
        _fetchMetricsAndShowDialog(),
        _fetchData(),
      ]);
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
                            state.homeData.goalStatus,
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
                              Expanded(
                                flex: 4,
                                child: StreakCalendar(
                                  isMaintain: state.homeData.goalStatus,
                                ),
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
                                        (isSmallScreen ? 0.24 : 0.37),
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
                          //    SizedBox(height: getPadding(context, 0.03)),
                          // GestureDetector(
                          //   onTap: () {
                          //     context.push('/water-intake');
                          //   },
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height *
                          //         (isSmallScreen ? 0.24 : 0.27),
                          //     constraints: BoxConstraints(
                          //       minHeight: screenWidth * 0.5,
                          //       maxHeight: screenWidth * 0.75,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.tileColor,
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(
                          //           LucideIcons.glassWater,
                          //           color: const Color(0xFFB4D147),
                          //           size: getIconSize(context, 0.16),
                          //         ),
                          //         SizedBox(height: getPadding(context, 0.03)),
                          //         Text(
                          //           'Water Intake',
                          //           style: TextStyle(
                          //             color: Colors.white.withOpacity(0.9),
                          //             fontSize: getFontSize(context, 0.04),
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // )
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
      bool isMaintain, HomeData data, Stream<double>? calorieStream) {
    return Builder(builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      if (isMaintain) {
        // Simple maintain weight tile
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: getPadding(context, 0.04),
            vertical: getPadding(context, 0.04),
          ),
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              'Maintain Weight',
              style: TextStyle(
                color: Colors.grey,
                fontSize: getFontSize(context, 0.08),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      }

      // Original calorie counter UI for non-maintain mode
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
