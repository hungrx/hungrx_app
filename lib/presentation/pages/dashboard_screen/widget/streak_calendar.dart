import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StreakCalendar extends StatefulWidget {
  final bool isMaintain;

  const StreakCalendar({super.key, required this.isMaintain});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  double getResponsiveSize(BuildContext context,
      {required double small, required double medium, required double large}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return small;
    if (width < 600) return medium;
    return large;
  }

  // Simplified padding calculation
  EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(
      getResponsiveSize(
        context,
        small: 8,
        medium: 12,
        large: 16,
      ),
    );
  }

  double getFontSize(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  double getPadding(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  double getIconSize(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    // Assuming you have a FetchStreakData event
    context.read<StreakBloc>().add(FetchStreakData());

    setState(() => _isLoading = false);
  }

  Widget _buildLoadingView() {
    return _buildContainer(
      context,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB4D147)),
            ),
            SizedBox(height: getPadding(context, 0.04)),
            Text(
              'Loading streaks...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: getFontSize(context, 0.035),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return _buildContainer(
      context,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.27,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.alertCircle,
              color: Colors.red[300],
              size: getIconSize(context, 0.08),
            ),
            SizedBox(height: getPadding(context, 0.03)),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: getFontSize(context, 0.03),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getPadding(context, 0.03)),
            ElevatedButton.icon(
              onPressed: _loadStreakData,
              icon:
                  Icon(LucideIcons.refreshCw, size: getIconSize(context, 0.04)),
              label: Text(
                'Retry',
                style: TextStyle(
                  fontSize: getFontSize(context, 0.035),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4D147),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: getPadding(context, 0.04),
                  vertical: getPadding(context, 0.02),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return BlocConsumer<StreakBloc, StreakState>(
      listener: (context, state) {
        if (state is StreakError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: _loadStreakData,
                textColor: Colors.white,
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is StreakLoading || _isLoading) {
          return _buildLoadingView();
        }

        if (state is StreakError) {
          return _buildErrorView(state.message);
        }

        if (state is StreakLoaded) {
          final streakData = state.streakData;
          final streakMap = streakData.getStreakMap();
          final startingDate = streakData.startDate;
          final endingDate = DateTime.now().add(
              const Duration(days: 365)); // Show one year ahead for unlimited
print(startingDate);
print(endingDate);
          // final endingDate = streakData.endDate();

          return _buildContainer(
            context,
            child: SizedBox(
              
              // width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  SizedBox(
                    height: screenSize.width * (isSmallScreen ? 0.50 : 0.56),
                    child: _buildHeatMap(startingDate, endingDate, streakMap,
                        screenSize, isSmallScreen),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 3),
                  //   child: _buildStats(context, streakData, isSmallScreen),
                  // ),
                ],
              ),
            ),
          );
        }

        return _buildErrorView('Unable to load streak data');
      },
    );
  }

  Widget _buildContainer(BuildContext context, {required Widget child}) {
    return Container(
      padding: getResponsivePadding(context),
      constraints: const BoxConstraints(
        maxWidth: 600, // Prevent excessive width on large screens
      ),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }



  Widget _buildHeatMap(DateTime startDate, DateTime endDate,
      Map<DateTime, int> datasets, Size screenSize, bool isSmallScreen) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,
            Colors.transparent,
            Colors.transparent,
            Colors.black,
          ],
          stops: [0.0, 0.02, 0.98, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HeatMap(
          
           margin: const EdgeInsets.all(4),
          borderRadius: 20,
          fontSize:  screenSize.width * (isSmallScreen ? 0.03 : 0.026),
          startDate: startDate,
          endDate: endDate,
          datasets: datasets,
          colorMode: ColorMode.color,
          defaultColor: const Color(0xFF2A2A2A),
          textColor: Colors.white,
          showColorTip: false,
          showText: true,
          scrollable: true,
          size: screenSize.width * (isSmallScreen ? 0.04 : 0.047),
          colorsets: const {
            1: Color.fromARGB(255, 119, 141, 41),
          },
        ),
      ),
    );
  }
}
