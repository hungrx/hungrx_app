import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/calorie_calculation_screen/widget/complete_dialog.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/dashboard_screen.dart';

class CalorieCalculationScreen extends StatelessWidget {
  const CalorieCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Calculation',
                  style: TextStyle(color: Colors.white)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('2780 cal',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildCalorieProgressBar(),
                    const SizedBox(height: 16),
                    _buildCalculationCard(),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Food list',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildFoodItem(
                    'Big Mac', '590 Cal.', 'assets/images/burger.png'),
                _buildFoodItem('Double Quarter Pounder', '740 Cal.',
                    'assets/images/piza.png'),
                _buildFoodItem(
                    'Big Mac', '590 Cal.', 'assets/images/burger.png'),
                _buildFoodItem('Double Quarter Pounder with Cheese', '740 Cal.',
                    'assets/images/burger.png'),
              ]),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "you'r over recommended calorie for this meal by 240cal 🔥",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTotalCaloriesBar(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieProgressBar() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 28,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: const Center(
                  child: Text('780cal',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
          ),
          Expanded(
            flex: 46,
            child: Container(
              color: Colors.green,
              child: const Center(
                  child: Text('1280cal',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
          ),
          const Expanded(
            flex: 26,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.square, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text('Break fast :', style: TextStyle(color: Colors.white)),
              Spacer(),
              Text('1280 cal',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.grey),
          _buildCalculationRow('Total protine add', '78g'),
          _buildCalculationRow('Remaining calorie', '758 cal',
              valueColor: Colors.red),
          _buildCalculationRow('Total calories consumed', '1230 cal',
              valueColor: Colors.green),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add more items',
                  style: TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value,
      {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String name, String calories, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(calories, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {}),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('1', style: TextStyle(color: Colors.white)),
              ),
              IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCaloriesBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total : 1230 cal',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () => _showCompletionDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Ate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CompletionDialog(
            message: "Wow! You've completed 30% of your calorie budget!",
            onComplete: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              ); // Navigate to home screen
            },
          ),
        );
      },
    );
  }
}
