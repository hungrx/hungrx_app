import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/responsive_text.dart';
import 'package:hungrx_app/data/Models/home_screen_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/daily_insight.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/feedbacks_widget.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/user_profile_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardWidgets {
  static Widget buildHeader(HomeData data, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveTextWidget(
              text: 'Hi, ${data.username}',
              fontWeight: FontWeight.bold,
              sizeFactor: 0.06,
              color: Colors.white,
            ),
            ResponsiveTextWidget(
              text: _getGreeting(),
              fontWeight: FontWeight.bold,
              sizeFactor: 0.035,
              color: AppColors.fontColor,
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserProfileScreen()),
            );
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/images/dp.png'),
            // backgroundImage: NetworkImage(data.profilePhoto),
          ),
        ),
      ],
    );
  }

  static Widget buildCalorieCounter(HomeData data) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Row(
                children: [
                  AnimatedFlipCounter(
                    value: data.daysToReachGoal,
                    textStyle: GoogleFonts.stickNoBills(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' Days',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedFlipCounter(
                value: data.caloriesToReachGoal,
                wholeDigits: 6,
                textStyle: GoogleFonts.stickNoBills(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 22, left: 5),
                child: Text(
                  'cal',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildDailyTargetAndRemaining(
      HomeData data, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Target',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.dailyCalorieGoal.toStringAsFixed(0),
                      style: GoogleFonts.stickNoBills(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12, left: 5),
                      child: Text(
                        'cal',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DailyInsightScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 5,
                    percent: data.remaining / data.dailyCalorieGoal,
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey[800]!,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Remaining',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            data.remaining.toStringAsFixed(0),
                            style: GoogleFonts.stickNoBills(
                              color: Colors.white,
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12, left: 5),
                            child: Text(
                              'cal',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildBottomButtons(BuildContext context, HomeData data) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => FeedbackDialog(
                  onSubmit: (rating, feedback) {
                    // Handle feedback
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 22, bottom: 22),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Feedbacks',
                  style: GoogleFonts.stickNoBills(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final AuthService authService = AuthService();
              final userId = await authService.getUserId();
              if (userId != null) {
                if (!context.mounted) return;

              
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weight',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    data.weight,
                    style: GoogleFonts.stickNoBills(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }
}