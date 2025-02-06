import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/preferance_class.dart';
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

  bool _isInitialized = false;
  late AppPreferences _appPrefs;

  @override
  void initState() {
    super.initState();
    // Single initialization point
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (_isInitialized) return;

    try {
      print('Starting initialization...');
      // 1. Initialize preferences
      final prefs = await SharedPreferences.getInstance();
      _appPrefs = AppPreferences(prefs);

      if (!mounted) return;

      // 2. Check first time user status
      final isFirstTime = _appPrefs.isFirstTimeUser();
      print('Is first time user: $isFirstTime');

      // 3. Wait for home data first
      final homeBloc = context.read<HomeBloc>()..add(RefreshHomeData());
      final metricsBloc = context.read<CalorieMetricsBloc>();

      HomeLoaded? homeLoadedState;
      await for (final state in homeBloc.stream) {
        if (state is HomeLoaded) {
          homeLoadedState = state;
          // Update account creation date from API response
          _appPrefs.setAccountCreationDate(state.homeData.calculationDate);

          if (isFirstTime) {
            await _handleFirstTimeUser(state.homeData.calculationDate);
          }
          break;
        }
        if (state is HomeError) {
          _isInitialized = false;
          return;
        }
      }

      // Debug after updating
      _debugPreferences();
      _debugDates();

      // 4. Now fetch metrics and show dialog if needed
      if (!isFirstTime && mounted && homeLoadedState != null) {
        metricsBloc.add(FetchCalorieMetrics());
        await for (final state in metricsBloc.stream) {
          if (state is CalorieMetricsLoaded) {
            await _checkAndShowMetricsDialog();
            break;
          }
          if (state is CalorieMetricsError) break;
        }
      }

      // 5. Check weight reminder
      if (mounted && homeLoadedState != null) {
        await _checkWeightReminder();
      }

      _isInitialized = true;
      print('Initialization completed successfully');
    } catch (e) {
      print('Initialization error: $e');
      _isInitialized = false;
    }
  }

  Future<void> _handleFirstTimeUser(String calculationDate) async {
    // Store the calculationDate as account creation date
    _appPrefs.setFirstTimeUser(false);
    _appPrefs.setAccountCreationDate(calculationDate);

    if (mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WelcomeDialog(),
      );
    }
  }

  void _debugPreferences() {
    print('\n--- Debug Preferences ---');
    _appPrefs.printAllPreferences();

    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      print(
          'Calculation date from home data: ${homeState.homeData.calculationDate}');
    }
    print('----------------------\n');
  }

  void _debugDates() {
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      final data = homeState.homeData;
      print('\n--- Debug Dates ---');
      print('Calculation date: ${data.calculationDate}');
      // print('Starting date: ${data.startingDate}');
      print('Current date: ${DateTime.now().toIso8601String()}');
      print('Last shown date: ${_appPrefs.getLastDialogDate()}');
      print('Account creation date: ${_appPrefs.getAccountCreationDate()}');
      print('-------------------\n');
    }
  }

  Future<void> _checkAndShowMetricsDialog() async {
    if (!mounted) {
      print('Not mounted when checking metrics dialog');
      return;
    }

    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) {
      print('Home state not loaded when checking metrics dialog');
      return;
    }

    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0]; // YYYY-MM-DD
    final lastShownDate = _appPrefs.getLastDialogDate();
    final accountCreationDate = _parseDate(homeState.homeData.calculationDate);
    final isoAccountCreationDate =
        accountCreationDate.toIso8601String().split('T')[0];

    print('API Creation date: ${homeState.homeData.calculationDate}');
    print('Parsed Creation date: $isoAccountCreationDate');
    print('Current date: $today');
    print('Last shown date: $lastShownDate');

    // Don't show on account creation date
    if (isoAccountCreationDate == today) {
      print('Skipping metrics dialog on account creation date');
      return;
    }

    // Show if not shown today (either null or different date)
    if (lastShownDate != today) {
      print('Showing metrics dialog - not shown today');
      if (mounted) {
        _showMetricsDialog(); // Show dialog first
        _appPrefs.setLastDialogDate(today); // Set date after successful show
      }
    } else {
      print('Metrics dialog already shown today');
    }
  }

  Future<void> simulateFutureDate(int daysToAdd) async {
    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) return;

    final accountCreationDate = _parseDate(homeState.homeData.calculationDate);
    final simulatedDate = accountCreationDate.add(Duration(days: daysToAdd));

    print('\n--- Simulating date ${daysToAdd} days in future ---');
    print('Original creation date: ${accountCreationDate.toIso8601String()}');
    print('Simulated current date: ${simulatedDate.toIso8601String()}');

    // Clear last shown dialog date to test dialog showing
    _appPrefs.clearLastDialogDate();

    // Re-run checks
    await _checkAndShowMetricsDialog();
    await _checkWeightReminder();
  }

  Future<void> _checkWeightReminder() async {
    if (!mounted) return;

    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) return;

    // Use calculationDate directly as account creation date
    final accountCreationDate = _parseDate(homeState.homeData.calculationDate);
    final now = DateTime.now();
    final daysSinceCreation = now.difference(accountCreationDate).inDays;

    print('Account Creation Date: ${accountCreationDate.toIso8601String()}');
    print('Days since creation: $daysSinceCreation');

    // Show reminder only after 7 days of account creation
    if (daysSinceCreation >= 7) {
      final shouldShow = await WeightReminderManager.shouldShowReminder();
      print('Should show weight reminder: $shouldShow');
      if (shouldShow && mounted) {
        final lastUpdate = await WeightReminderManager.getLastWeightUpdate();
        await _showWeightReminderDialog(lastUpdate);
      }
    } else {
      print(
          'Not showing weight reminder - only $daysSinceCreation days since creation');
    }
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
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

  Future<void> _fetchMetricsAndShowDialog() async {
    if (!mounted) return;

    final metricsBloc = context.read<CalorieMetricsBloc>();
    metricsBloc.add(FetchCalorieMetrics());

    // Wait for metrics to load
    await for (final state in metricsBloc.stream) {
      if (state is CalorieMetricsLoaded) {
        await _checkAndShowMetricsDialog();
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

  // Future<void> _initializePrefs() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   // Ensure we have the keys initialized
  //   if (!_prefs.containsKey(_firstTimeKey)) {
  //     await _prefs.setBool(_firstTimeKey, true);
  //   }
  // }

  void _showMetricsDialog() {
    print('Attempting to show metrics dialog');
    if (!mounted) {
      print('Not mounted when showing metrics dialog');
      return;
    }

    final metricsState = context.read<CalorieMetricsBloc>().state;
    final homeState = context.read<HomeBloc>().state;

    if (metricsState is CalorieMetricsLoaded && homeState is HomeLoaded) {
      print('Showing metrics dialog with data:');
      print('Consumed: ${metricsState.metrics.consumedCalories}');
      print('Goal: ${metricsState.metrics.goal}');

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => MetricsDialog(
          isMaintain: metricsState.metrics.goal == 'maintain weight',
          consumedCalories: metricsState.metrics.consumedCalories,
          dailyTargetCalories: metricsState.metrics.dailyTargetCalories,
          remainingCalories: metricsState.metrics.remainingCalories,
          goalMessage: metricsState.metrics.message,
          weightChangeRate: metricsState.metrics.weightChangeRate,
          caloriesToReachGoal: metricsState.metrics.caloriesToReachGoal,
          dailyWeightLoss: metricsState.metrics.dailyWeightLoss,
          ratio: metricsState.metrics.ratio,
          goal: metricsState.metrics.goal,
          daysLeft: metricsState.metrics.daysLeft,
          date: metricsState.metrics.date,
        ),
      );
    } else {
      print(
          'Cannot show dialog: Metrics state = ${metricsState.runtimeType}, Home state = ${homeState.runtimeType}');
    }
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    context.read<HomeBloc>().add(RefreshHomeData());
  }

  void updateCalories(double newValue) {
    _calorieController.add(newValue);
  }

  // Future<void> resetLastShownDate() async {
  //   await _appPrefs.clearLastDialogDate();
  // }

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
                                // flex: 4,
                                child: StreakCalendar(
                                  isMaintain: state.homeData.goalStatus,
                                ),
                              ),
                              // SizedBox(width: getPadding(context, 0.03)),
                              // Expanded(
                              //   flex: 2,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       context.push('/water-intake');
                              //     },
                              //     child: Container(
                              //       height: MediaQuery.of(context).size.height *
                              //           (isSmallScreen ? 0.24 : 0.28),
                              //       constraints: BoxConstraints(
                              //         minHeight: screenWidth * 0.5,
                              //         maxHeight: screenWidth * 0.75,
                              //       ),
                              //       decoration: BoxDecoration(
                              //         color: AppColors.tileColor,
                              //         borderRadius: BorderRadius.circular(20),
                              //       ),
                              //       child: Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: [
                              //           Icon(
                              //             LucideIcons.glassWater,
                              //             color: const Color(0xFFB4D147),
                              //             size: getIconSize(context, 0.25),
                              //           ),
                              //           // SizedBox(
                              //           //     height: getPadding(context, 0.03)),
                              //           // Text(
                              //           //   'Water Intake',
                              //           //   style: TextStyle(
                              //           //     color:
                              //           //         Colors.white.withOpacity(0.9),
                              //           //     fontSize:
                              //           //         getFontSize(context, 0.04),
                              //           //     fontWeight: FontWeight.w500,
                              //           //   ),
                              //           // ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(height: getPadding(context, 0.03)),
                          DashboardWidgets.buildBottomButtons(
                            context,
                            state.homeData,
                          ),
                          SizedBox(height: getPadding(context, 0.03)),
                          GestureDetector(
                            onTap: () {
                               HapticFeedback.mediumImpact();
                              context.push('/water-intake');
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                  (isSmallScreen ? 0.6 : 0.12),
                              constraints: BoxConstraints(
                                minHeight: screenWidth * 0.1,
                                maxHeight: screenWidth * 0.2,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.tileColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.glassWater,
                                    color: const Color(0xFFB4D147),
                                    size: getIconSize(context, 0.1),
                                  ),
                                  SizedBox(width: getPadding(context, 0.05)),
                                  Text(
                                    'Drink',
                                    style: GoogleFonts.stickNoBills(
                                      color: Colors.white,
                                      fontSize: getFontSize(
                                          context, isSmallScreen ? 0.07 : 0.08),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
              'MAINTAIN WEIGHT',
              style: GoogleFonts.stickNoBills(
                color: Colors.white,
                fontSize: getFontSize(context, 0.09),
                fontWeight: FontWeight.bold,
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
                            getFontSize(context, isSmallScreen ? 0.75 : 0.080),
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
