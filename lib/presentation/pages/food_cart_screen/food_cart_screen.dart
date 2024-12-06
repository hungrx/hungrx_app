import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Calorie Cart', style: TextStyle(color: Colors.white,fontSize: 30)),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                      _buildCalorieSummaryCard(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Food Items',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.only(bottom: 100), // Space for bottom bar
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFoodItem(
                        'Big Mac', '590 Cal', 'assets/images/burger.png'),
                    _buildFoodItem('Double Quarter Pounder', '740 Cal',
                        'assets/images/piza.png'),
                    _buildFoodItem(
                        'Big Mac', '590 Cal', 'assets/images/burger.png'),
                    _buildFoodItem('Double Quarter Pounder with Cheese',
                        '740 Cal', 'assets/images/burger.png'),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildTotalCaloriesBar(context),
          ),
        ],
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
            flex: 46,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Colors.green,
              ),
              child: const Center(
                  child: Text('1280cal',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
          ),
          Expanded(
            flex: 28,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: const Center(
                  child: Text('780cal',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieSummaryCard() {
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
          
              Text('Breakfast :', style: TextStyle(color: Colors.white)),
              Spacer(),
              Text('1280 cal',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.grey),
          _buildSummaryRow('Total protein added', '78g'),
           _buildSummaryRow('Total calories consumed', '1230 cal',
              valueColor: Colors.green),
          _buildSummaryRow('Remaining calories', '758 cal',
              valueColor: Colors.red),
         
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add more items',
                  style: TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green,size: 30,),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.buttonColors,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Calories',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                Text('1230 cal',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () => _showCompletionDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child:
                  const Text('Ate', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.green, size: 50),
                const SizedBox(height: 16),
                const Text(
                  "Wow! You've completed 30% of your calorie budget!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to dashboard or home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
