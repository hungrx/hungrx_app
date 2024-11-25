import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        if (state is StreakLoading) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StreakError) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Error loading streak data: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is StreakLoaded) {
          final streakData = state.streakData;
          final streakMap = streakData.getStreakMap();
          final startingDate = streakData.startDate();
          final endingDate  = streakData.endDate();
          return Container(
            padding: const EdgeInsets.all(10),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB4D147),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.flame,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Streaks',
                              style: GoogleFonts.stickNoBills(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '#beUnstoppable',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.19,
                  child: ShaderMask(
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
                        startDate: startingDate,
                        endDate: endingDate,
                        datasets: streakMap,
                        colorMode: ColorMode.color,
                        defaultColor: const Color(0xFF2A2A2A),
                        textColor: Colors.transparent,
                        showColorTip: false,
                        showText: false,
                        scrollable: true,
                        size: 12,
                        colorsets: const {
                          1: Color(0xFFB4D147),
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Streak Stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.flame,
                            color: Color(0xFFB4D147),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${streakData.totalStreak}',
                            style: GoogleFonts.stickNoBills(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Months Counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${streakData.daysLeft} Days Left',
                        style: GoogleFonts.stickNoBills(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
