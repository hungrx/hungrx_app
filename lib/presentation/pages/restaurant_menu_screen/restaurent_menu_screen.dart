import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/calorie_calculation_screen/calculation_tracking.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _isSearchVisible
            ? TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Find the foods under your daily kcal...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = false;
                      });
                    },
                  ),
                ),
                autofocus: true,
              )
            : null,
        actions: [
          if (!_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearchVisible = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildRestaurantInfoCard(),
                  _buildMenuList(context),
                ],
              ),
            ),
          ),
          _buildOrderSummary(context),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfoCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[900],
          // borderRadius: const BorderRadius.all(Radius.circular(16))
          ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "McDonald's",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.buttonColors, size: 16),
                    SizedBox(width: 4),
                    Text('4.2',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text('Open until 4:00 am', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '184 Waverly Pl, New York, New York 10014\n0.5 ml away',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.buttonColors,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return ListView(

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuCategory('Recommended foods', [
          _buildMenuItem(
              'Big Mac', '590 Cal.', 'assets/images/burger.png', 4.8, context),
          _buildMenuItem('Double Quarter Pounder with Cheese', '740 Cal.',
              'assets/images/burger.png', 4.2, context),
        ]),
        _buildMenuCategory('Homestyle Breakfasts', [
          _buildMenuItem(
              'Pancakes', '540 Cal.', 'assets/images/piza.png', 4.5, context),
          _buildMenuItem('Egg McMuffin', '300 Cal.', 'assets/images/piza.png',
              4.3, context),
        ]),
        _buildMenuCategory('Hash Browns and Sides', [
          _buildMenuItem('Hash Browns', '150 Cal.', 'assets/images/burger.png',
              4.6, context),
          _buildMenuItem('French Fries', '320 Cal.', 'assets/images/piza.png',
              4.7, context),
        ]),
        _buildMenuCategory('McCafé® Coffees', [
          _buildMenuItem('Cappuccino', '120 Cal.', 'assets/images/burger.png',
              4.4, context),
          _buildMenuItem(
              'Latte', '190 Cal.', 'assets/images/burger.png', 4.2, context),
        ]),
      ],
    );
  }

  Widget _buildMenuCategory(String category, List<Widget> items) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        category,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      backgroundColor: Colors.black,
      collapsedBackgroundColor: Colors.black,
      children: items,
    );
  }

  Widget _buildMenuItem(String name, String calories, String imagePath,
      double rating, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SizedBox();
              },
            ));
      },
      leading: Image.asset(imagePath, width: 50, height: 50),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Row(
        children: [
          const Icon(Icons.star, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(rating.toString(),
              style: const TextStyle(color: AppColors.buttonColors)),
          const SizedBox(width: 8),
        ],
      ),
      trailing: SizedBox(
        width: 110,
        child: Row(
          children: [
            Text(calories,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppColors.buttonColors),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total calories', style: TextStyle(color: Colors.grey)),
              Text('789cal',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CalorieCalculationScreen()),
              );
            },
            child: const Text(
              'View order list (5 items) >',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}