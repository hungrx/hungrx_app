import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_bloc.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_event.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_state.dart';
import 'package:hungrx_app/presentation/controller/home_data_notifier.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MetricsDialog extends StatelessWidget {
  final bool isMaintain;
  final double consumedCalories;
  final double dailyTargetCalories;
  final double remainingCalories;
  final String goalMessage;
  final String weightChangeRate;
  final String caloriesToReachGoal;
  final double dailyWeightLoss;
  final double ratio;
  final String goal;
  final int daysLeft;
  final String date;

  const MetricsDialog({
    super.key,
    required this.consumedCalories,
    required this.dailyTargetCalories,
    required this.remainingCalories,
    required this.goalMessage,
    required this.weightChangeRate,
    required this.caloriesToReachGoal,
    required this.dailyWeightLoss,
    required this.ratio,
    required this.goal,
    required this.daysLeft,
    required this.date,
    required this.isMaintain,
  });

  bool get isWeightGainGoal =>
      !isMaintain && goal.toLowerCase().contains('gain');

  double get actualWeightChange {
    if (isMaintain) return 0;

    final consumptionRatio = consumedCalories / dailyTargetCalories;
    if (isWeightGainGoal) {
      return dailyWeightLoss * consumptionRatio;
    } else {
      return dailyWeightLoss * (2 - consumptionRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGaining = isWeightGainGoal;
    final analysisColor =
        isGaining ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B);

    return BlocListener<ChangeCalorieGoalBloc, ChangeCalorieGoalState>(
      listener: (context, state) {
        if (state is ChangeCalorieGoalSuccess) {
          HomeDataNotifier.updateCalories(
            HomeDataNotifier.caloriesNotifier.value - actualWeightChange,
          );
          Navigator.pop(context);
        } else if (state is ChangeCalorieGoalFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<ChangeCalorieGoalBloc, ChangeCalorieGoalState>(
        builder: (context, state) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress Update',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Analysis for $date',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(LucideIcons.x,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Main metrics cards
                    Row(
                      children: [
                        _buildMetricCard(
                          icon: LucideIcons.flame,
                          value: consumedCalories.toStringAsFixed(0),
                          label: 'Consumed',
                          color: const Color(0xFFFF6B6B),
                          context: context,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          icon: LucideIcons.target,
                          value: dailyTargetCalories.toStringAsFixed(0),
                          label: 'Target',
                          color: const Color(0xFF4ECDC4),
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress bar card
                    _buildRemainingCard(context),

                    // Weight Analysis - Only show if not maintaining
                    if (!isMaintain) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: analysisColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: analysisColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.activitySquare,
                                  color: analysisColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isGaining
                                      ? 'Weight Gain Analysis'
                                      : 'Weight Loss Analysis',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              isGaining
                                  ? 'Total Surplus Goal'
                                  : 'Total Burn Goal',
                              '${(double.tryParse(caloriesToReachGoal) ?? 0).toStringAsFixed(0)} cal',
                              analysisColor,
                            ),
                            _buildInfoRow(
                              isGaining
                                  ? 'Daily Surplus Goal'
                                  : 'Daily Burn Goal',
                              '${dailyWeightLoss.toStringAsFixed(1)} cal',
                              analysisColor,
                            ),
                            _buildInfoRow(
                              isGaining ? 'Achieved Surplus' : 'Achieved Burn',
                              '${actualWeightChange.toStringAsFixed(1)} cal',
                              isGaining
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFF4ECDC4),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: actualWeightChange / dailyWeightLoss,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              color: analysisColor,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isGaining
                                  ? 'Lower calorie intake reduces weight gain rate'
                                  : 'Lower calorie intake increases weight loss rate',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Maintenance message or goal message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.info,
                            color: Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isMaintain
                                  ? 'Stay within your daily target calories to maintain your current weight.'
                                  : goalMessage,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // OK Button
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is ChangeCalorieGoalLoading
                            ? null
                            : () {
                                context.read<ChangeCalorieGoalBloc>().add(
                                      SubmitChangeCalorieGoal(
                                        day: 1,
                                        calorie: actualWeightChange,
                                      ),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ChangeCalorieGoalLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'OK',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required BuildContext context,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainingCard(BuildContext context) {
    final percentage =
        (consumedCalories / dailyTargetCalories * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width *
                    (percentage / 100) *
                    0.65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4ECDC4),
                      const Color(0xFF4ECDC4).withOpacity(0.6)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${remainingCalories.toStringAsFixed(0)} calories left',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
