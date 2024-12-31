import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StreakCalendar extends StatefulWidget {
  final String userId;
  const StreakCalendar({super.key, required this.userId});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
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
        width: 240,
        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB4D147)),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading streaks...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
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
        width: 240,
        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.alertCircle,
              color: Colors.red[300],
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loadStreakData,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4D147),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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
          final startingDate = streakData.startDate();
          final endingDate = streakData.endDate();

          return _buildContainer(
            context,
            child: SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        _buildHeader(context, isSmallScreen),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * (isSmallScreen ? 0.13 : 0.155),
                    child: _buildHeatMap(
                      startingDate,
                      endingDate,
                      streakMap,
                      screenSize,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: _buildStats(context, streakData, isSmallScreen),
                  ),
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
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 6 : 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB4D147),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                LucideIcons.flame,
                color: Colors.black,
                size: isSmallScreen ? 24 : 26,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streaks',
                  style: GoogleFonts.stickNoBills(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#beUnstoppable',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                    fontSize: isSmallScreen ? 12 : 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatMap(
    DateTime startDate,
    DateTime endDate,
    Map<DateTime, int> datasets,
    Size screenSize,
  ) {
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
          fontSize: 0,
          startDate: startDate,
          endDate: endDate,
          datasets: datasets,
          colorMode: ColorMode.color,
          defaultColor: const Color(0xFF2A2A2A),
          textColor: Colors.transparent,
          showColorTip: false,
          showText: false,
          scrollable: true,
          size: screenSize.width < 360 ? 8 : 13,
          colorsets: const {
            1: Color(0xFFB4D147),
          },
        ),
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    dynamic streakData,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatContainer(
          text: '${streakData.daysLeft}',
          isSmallScreen: isSmallScreen,
          showIcon: false,
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        _buildStatContainer(
          icon: LucideIcons.flame,
          text: '${streakData.totalStreak}',
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildStatContainer({
    IconData? icon,
    required String text,
    required bool isSmallScreen,
    bool showIcon = true,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 2 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (showIcon && icon != null) ...[
            Icon(
              icon,
              color: const Color(0xFFB4D147),
              size: isSmallScreen ? 16 : 20,
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
          ],
          Text(
            text,
            style: GoogleFonts.stickNoBills(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}