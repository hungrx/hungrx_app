import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/daily_insight.dart';
import 'package:hungrx_app/core/widgets/bottom_navbar.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/feedbacks_widget.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/user_profile_screen.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_tracking.dart';
import 'package:hungrx_app/core/widgets/responsive_text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double totalCalories = 115300;
  int _selectedIndex = 0;
  final TextEditingController _calorieController = TextEditingController();

  @override
  void dispose() {
    _calorieController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on HomeScreen, no navigation needed
        break;
      case 1:
        context.go('/eatscreen');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/foodcart');
        break;
    }
  }

  void _showFeedbackDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return FeedbackDialog(
          onSubmit: (rating, feedback) {
            // Handle the feedback submission here
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      _buildCalorieCounter(),
                      const SizedBox(height: 20),
                      _buildInfoCards(),
                      const SizedBox(height: 20),
                      _buildHeatmapCalendar(),
                      const SizedBox(height: 20),
                      _buildBottomButtons(),
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: _buildEatFoodButton(),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResponsiveTextWidget(
              text: 'Hi, Warren Daniel',
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
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    if (hour < 21) {
      return 'Good Evening';
    }
    return 'Good Night';
  }

  Widget _buildCalorieCounter() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ResponsiveTextWidget(
                text: 'Calories to Burn',
                fontWeight: FontWeight.w600,
                sizeFactor: 0.04,
                color: AppColors.fontColor,
              ),
              SizedBox(
                child: Row(
                  children: [
                    AnimatedFlipCounter(
                      value: int.tryParse("256") ?? 0,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const ResponsiveTextWidget(
                      text: ' Days left',
                      fontWeight: FontWeight.w600,
                      sizeFactor: 0.03,
                      color: AppColors.fontColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedFlipCounter(
                thousandSeparator: ",",
                negativeSignDuration: const Duration(milliseconds: 5000),
                duration: const Duration(milliseconds: 5000),
                value: totalCalories,
                wholeDigits: 6,
                fractionDigits: 0,
                textStyle: const TextStyle(
                  fontFamily: "digifont",
                  color: Colors.white,
                  fontSize: 78,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ResponsiveTextWidget(
                  text: ' cal',
                  fontWeight: FontWeight.w600,
                  sizeFactor: 0.04,
                  color: AppColors.fontColor,
                ),
              ),
              // SizedBox(height: 20,)
            ],
          ),
          const SizedBox(height: 8),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ResponsiveTextWidget(
          //       text: 'Daily Target',
          //       fontWeight: FontWeight.w600,
          //       sizeFactor: 0.04,
          //       color: AppColors.fontColor,
          //     ),
          //     ResponsiveTextWidget(
          //       text: '2130 cal',
          //       fontWeight: FontWeight.w600,
          //       sizeFactor: 0.05,
          //       color: AppColors.buttonColors,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
        padding: const EdgeInsets.only(top: 34,left: 16,right: 16,bottom: 34),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("value", style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold)),
            Text("value", style: TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.bold)),
             
          ],
        ),
      ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DailyInsightScreen()),
              );
            },
            title: 'Remaining',
            value: '530',
            unit: 'cal',
            icon: CircularPercentIndicator(
              radius: 30,
              lineWidth: 5,
              percent: 0.25,
              progressColor: AppColors.buttonColors,
              backgroundColor: Colors.grey[800]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required String? title,
      required String? value,
      required String? unit,
      required void Function()? ontap,
      required Widget icon
      
      }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            icon,
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title??'', style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    ResponsiveTextWidget(
                      text: value??'',
                      fontWeight: FontWeight.w600,
                      sizeFactor: 0.075,
                      color: AppColors.fontColor,
                    ),
                    const SizedBox(width: 4),
                    Text(unit??'', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapCalendar() {
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveTextWidget(
            text: "Streaks 🔥",
            fontWeight: FontWeight.w600,
            sizeFactor: 0.04,
            color: AppColors.fontColor,
          ),
          HeatMap(
            margin: const EdgeInsets.all(2),
            fontSize: 0,
            defaultColor: Colors.grey,
            size: 12,
            borderRadius: 2,
            startDate: DateTime(2024, 8, 1, 20, 30),
            endDate: DateTime(2024, 12, 30, 20, 30),
            textColor: Colors.grey,
            datasets: {
              // this data daily add after comple the colorie budget
              DateTime(2024, 9, 1): 1,
              DateTime(2024, 9, 2): 2,
              DateTime(2024, 9, 3): 1,
              DateTime(2024, 9, 4): 13,
              DateTime(2024, 9, 5): 6,
              DateTime(2024, 9, 6): 6,
              DateTime(2024, 9, 7): 6,
              DateTime(2024, 9, 8): 6,
              DateTime(2024, 9, 9): 6,
              DateTime(2024, 9, 10): 1,
              DateTime(2024, 9, 11): 6,
              DateTime(2024, 9, 12): 6,
              DateTime(2024, 9, 13): 1,
            },
            colorMode: ColorMode.color,
            showText: false,
            scrollable: true,
            showColorTip: false,
            colorsets: const {
              1: Colors.red,
              2: Colors.green,
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildBottomButton(
            ontap: () {
              _showFeedbackDialog();
            },
            title: '',
            value: 'Feedbacks',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WeightTrackingScreen()),
              );
            },
            title: 'Current Weight',
            value: '98',
            unit: 'KG',
            icon: const FaIcon(
              FontAwesomeIcons.weightScale,
              color: AppColors.buttonColors,
              size: 34,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
      {required String title,
      required String value,
      required void Function()? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.only(top: 34,left: 16,right: 16,bottom: 34),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.bold)),
             
          ],
        ),
      ),
    );
  }
}
