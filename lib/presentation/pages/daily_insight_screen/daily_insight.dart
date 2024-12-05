import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/header_section.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyInsightScreen extends StatefulWidget {
  const DailyInsightScreen({super.key});

  @override
  DailyInsightScreenState createState() => DailyInsightScreenState();
}

class DailyInsightScreenState extends State<DailyInsightScreen> {
  late DateTime selectedDate;
  final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDateSelector(),
            Expanded(
              child: _buildMealList(),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: _buildEatFoodButton(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderSection(title: 'Daily Insight',);
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == selectedDate.day;
          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.buttonColors : AppColors.tileColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekDays[date.weekday % 7],
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalorieProgress() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 8,
            percent: 0.28,
            center: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '590',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'kcal',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            progressColor: AppColors.buttonColors,
            backgroundColor: Colors.grey[800]!,
          ),
          const SizedBox(width: 50),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalorieInfo(Icons.flag, 'Daily Target', '2130 cal'),
                const SizedBox(height: 8),
                _buildCalorieInfo(Icons.restaurant, 'Total Now', '530 cal'),
                const SizedBox(height: 8),
                _buildCalorieInfo(Icons.balance, 'Remaining', '1630 cal'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.buttonColors, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMealList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCalorieProgress(),

        _buildMealSection('Breakfast', [
          _buildMealItem('Big Mac', '590 Cal.', 4.8),
          _buildMealItem('Double Quarter Pounder with Cheese', '740 Cal.', 4.2),
          _buildMealItem('Double Quarter Pounder with Cheese', '740 Cal.', 4.2),
          _buildMealItem('Double Quarter Pounder with Cheese', '740 Cal.', 4.2),
          _buildMealItem('Cheese Burger', '300 Cal.', 3.9),
          _buildMealItem('Cheese Burger', '300 Cal.', 3.9),
        ]),
        _buildMealSection('Lunch', [
          _buildMealItem('Big Mac', '590 Cal.', 4.8),
        ]),
      ],
    );
  }

  Widget _buildMealSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppColors.fontColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMealItem(String name, String calories, double rating) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: AppColors.fontColor, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toString(),
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Text(calories,
                style: const TextStyle(
                    color: AppColors.fontColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  void _showDeleteDialog(String foodName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.tileColor,
          title: Text('Delete $foodName?',
              style: const TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to remove $foodName from your meal list?',
              style: const TextStyle(color: Colors.grey)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Implement delete functionality here
                // For now, we'll just close the dialog
                Navigator.of(context).pop();
                _showDeleteConfirmation(foodName);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(String foodName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$foodName has been deleted from your meal list.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    // Here you would typically update your state to remove the item
    // setState(() {
    //   // Remove the item from your data source
    // });
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
  //     onNearbyRestaurant: () {},
  //   );
  // }
}
