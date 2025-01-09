import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/responsive_text.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/animated_calorie_count.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/feedback_bottom.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardWidgets {
  // Responsive sizes based on screen width
  static double getFontSize(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  static double getPadding(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  static Widget buildHeader(HomeData data, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveTextWidget(
              text: 'Hi, ${data.username}',
              fontWeight: FontWeight.bold,
              sizeFactor: isSmallScreen ? 0.05 : 0.06,
              color: Colors.white,
            ),
            ResponsiveTextWidget(
              text: _getGreeting(),
              fontWeight: FontWeight.bold,
              sizeFactor: isSmallScreen ? 0.03 : 0.035,
              color: AppColors.fontColor,
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildCalorieCounter(
      HomeData data, Stream<double>? calorieStream) {
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

  static Widget buildDailyTargetAndRemaining(
      HomeData data, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = getPadding(context, 0.04);
    final verticalPadding = getPadding(context, 0.02);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Target',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getFontSize(context, 0.04),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.dailyCalorieGoal.toStringAsFixed(0),
                      style: GoogleFonts.stickNoBills(
                        color: Colors.white,
                        fontSize:
                            getFontSize(context, isSmallScreen ? 0.09 : 0.1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getPadding(context, 0.03),
                        left: getPadding(context, 0.01),
                      ),
                      child: Text(
                        'cal',
                        style: GoogleFonts.stickNoBills(
                          color: Colors.grey,
                          fontSize: getFontSize(context, 0.035),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: getPadding(context, 0.04)),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.dailyInsightScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularPercentIndicator(
                    radius: isSmallScreen ? 18 : 22,
                    lineWidth: isSmallScreen ? 3 : 4,
                    percent: data.remaining / data.dailyCalorieGoal,
                    progressColor: Colors.grey[800]!,
                    backgroundColor: Colors.green,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: getFontSize(context, 0.04),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            data.remaining.toStringAsFixed(0),
                            style: GoogleFonts.stickNoBills(
                              color: Colors.white,
                              fontSize: getFontSize(
                                  context, isSmallScreen ? 0.09 : 0.1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: getPadding(context, 0.03),
                              left: getPadding(context, 0.01),
                            ),
                            child: Text(
                              'cal',
                              style: GoogleFonts.stickNoBills(
                                color: Colors.grey,
                                fontSize: getFontSize(context, 0.035),
                              ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = getPadding(context, 0.04);
    final verticalPadding = getPadding(context, 0.02);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FeedbackBottomSheet(
                  phoneNumber:
                      '7736150287', // Replace with your WhatsApp number
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding * 2.1,
              ),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Feedbacks',
                  style: GoogleFonts.stickNoBills(
                    color: Colors.white,
                    fontSize:
                        getFontSize(context, isSmallScreen ? 0.07 : 0.075),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: getPadding(context, 0.04)),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final AuthService authService = AuthService();
              final userId = await authService.getUserId();
              if (userId != null && context.mounted) {
                context.pushNamed(RouteNames.weightTracking);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Weight',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: getFontSize(context, 0.04),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    data.weight,
                    style: GoogleFonts.stickNoBills(
                      color: Colors.white,
                      fontSize:
                          getFontSize(context, isSmallScreen ? 0.06 : 0.065),
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
