import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/calorie_insight_screen/calorie_insight.dart';
import 'package:hungrx_app/presentation/pages/home_screen/widget/animated_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalCalories = 115300;
  final TextEditingController _calorieController = TextEditingController();

  @override
  void dispose() {
    _calorieController.dispose();
    super.dispose();
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
                      _buildHeader(),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildEatFoodButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Warren Daniel',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Good Night',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          // backgroundImage: AssetImage('assets/profile_picture.jpg'),
        ),
      ],
    );
  }

  Widget _buildCalorieCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calories to Burn',
            style: TextStyle(color: Colors.grey),
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
              Text(
                'Daily Target',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '2130 cal',
                style: TextStyle(
                    color: AppColors.buttonColors,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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
            ontap: () {},
            title: 'Current Weight',
            value: '98',
            unit: 'KG',
            icon: const FaIcon(
              FontAwesomeIcons.weightScale,
              color: Colors.white,
              size: 30,
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
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
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
                    Text(
                      value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
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
    return HeatMap(
      defaultColor: Colors.grey,
      size: 12,
      borderRadius: 1,
      startDate: DateTime(2024, 9, 7, 20, 30),
      endDate: DateTime(2025, 3, 7, 20, 30),
      textColor: Colors.grey,
      datasets: {
        DateTime(2023, 9, 1): 5,
        DateTime(2023, 9, 2): 7,
        DateTime(2023, 9, 3): 10,
        DateTime(2023, 9, 4): 13,
        DateTime(2023, 9, 5): 6,
      },
      colorMode: ColorMode.color,
      showText: false,
      scrollable: true,
      colorsets: {
        1: Colors.green[100]!,
        3: Colors.green[300]!,
        5: Colors.green[500]!,
        7: Colors.green[700]!,
        9: Colors.green[900]!,
      },
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildBottomButton(
            title: 'Feedbacks',
            value: '100',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBottomButton(
            title: 'Days',
            value: '290',
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          AnimatedFlipCounter(
            value: int.parse(value),
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEatFoodButton() {
    return AnimatedEatFoodButton(
      onLogMeal: () {
        // Implement log meal functionality
        print('Log meal pressed');
      },
      onNearbyRestaurant: () {
        // Implement nearby restaurant functionality
        print('Nearby restaurant pressed');
      },
    );
  }
}
