import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/daily_insight.dart';
import 'package:hungrx_app/presentation/pages/eat_screen/eat_screen.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/food_cart_screen.dart';
import 'package:hungrx_app/presentation/widgets/bottom_navbar.dart';
import 'package:hungrx_app/presentation/pages/home_screen/widget/feedbacks_widget.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screen/user_profile_screen.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_tracking.dart';
import 'package:hungrx_app/presentation/widgets/responsive_text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
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

  //  Widget _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: 'Dashboard',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.restaurant_menu),
  //         label: 'Eat',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person),
  //         label: 'Profile',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.shopping_cart),
  //         label: 'Food Cart',
  //       ),
  //     ],
  //     currentIndex: _selectedIndex,
  //     selectedItemColor: AppColors.buttonColors,
  //     unselectedItemColor: Colors.grey,
  //     onTap: _onItemTapped,
  //     backgroundColor: AppColors.tileColor,
  //     type: BottomNavigationBarType.fixed,
  //   );
  // }

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveTextWidget(
            text: 'Calories to Burn',
            fontWeight: FontWeight.w600,
            sizeFactor: 0.04,
            color: AppColors.fontColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveTextWidget(
                text: 'Daily Target',
                fontWeight: FontWeight.w600,
                sizeFactor: 0.04,
                color: AppColors.fontColor,
              ),
              ResponsiveTextWidget(
                text: '2130 cal',
                fontWeight: FontWeight.w600,
                sizeFactor: 0.05,
                color: AppColors.buttonColors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
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

  Widget _buildInfoCard(
      {required String title,
      required String value,
      required String unit,
      required void Function()? ontap,
      required Widget icon}) {
    return InkWell(
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
                Text(title, style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    ResponsiveTextWidget(
                      text: value,
                      fontWeight: FontWeight.w600,
                      sizeFactor: 0.085,
                      color: AppColors.fontColor,
                    ),
                    const SizedBox(width: 4),
                    Text(unit, style: const TextStyle(color: Colors.grey)),
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
      padding: const EdgeInsets.all(16),
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
            size: 15,
            borderRadius: 4,
            startDate: DateTime(2024, 9, 7, 20, 30),
            endDate: DateTime(2025, 3, 7, 20, 30),
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
            title: 'Feedbacks',
            value: '0',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBottomButton(
            ontap: () {},
            title: 'Days',
            value: '290',
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
      {required String title,
      required String value,
      required void Function()? ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            AnimatedFlipCounter(
              value: int.tryParse(value) ?? 0,
              textStyle: const TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildEatFoodButton() {
  //   return AnimatedEatFoodButton(
  //     onLogMeal: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LogMealScreen()),
  //       );
  //       // Implement log meal functionality
  //     },
  //     onNearbyRestaurant: () {
  //           Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const RestaurantScreen()),
  //       );
  //     },
  //   );
  // }
}
