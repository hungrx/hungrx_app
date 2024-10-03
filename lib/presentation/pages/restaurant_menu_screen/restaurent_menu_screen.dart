import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({super.key});

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
      ),
      body: Column(
        children: [
          _buildRestaurantInfoCard(),
          _buildSearchBar(),
          const SizedBox(height: 20,),
          Expanded(
            child: _buildMenuList(),
          ),
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "McDonald's® (FiDi (160 Broadway))",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
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
                child: const Icon(Icons.directions, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Find the foods under your daily kcal...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView(
      children: [
        _buildMenuCategory('Recommended foods', [
          _buildMenuItem(
              'Big Mac', '590 Cal.', 'assets/images/burger.png', 4.8),
          _buildMenuItem('Double Quarter Pounder with Cheese', '740 Cal.',
              'assets/images/burger.png', 4.2),
        ]),
        _buildMenuCategory('Homestyle Breakfasts', [
          _buildMenuItem('Pancakes', '540 Cal.', 'assets/images/piza.png', 4.5),
          _buildMenuItem(
              'Egg McMuffin', '300 Cal.', 'assets/images/piza.png', 4.3),
        ]),
        _buildMenuCategory('Hash Browns and Sides', [
          _buildMenuItem(
              'Hash Browns', '150 Cal.', 'assets/images/burger.png', 4.6),
          _buildMenuItem(
              'French Fries', '320 Cal.', 'assets/images/piza.png', 4.7),
        ]),
        _buildMenuCategory('McCafé® Coffees', [
          _buildMenuItem(
              'Cappuccino', '120 Cal.', 'assets/images/burger.png', 4.4),
          _buildMenuItem('Latte', '190 Cal.', 'assets/images/burger.png', 4.2),
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

  Widget _buildMenuItem(
      String name, String calories, String imagePath, double rating) {
    return ListTile(
      leading: Image.asset(imagePath, width: 50, height: 50),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Row(
        children: [
          const Icon(Icons.star, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(rating.toString(), style: const TextStyle(color: AppColors.buttonColors)),
          const SizedBox(width: 8),
       
        ],
      ),
      trailing: SizedBox(
        width: 110,
        
        child: Row(
          children: [
               Text(calories, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w800)),
        
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.buttonColors),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
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
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text('View order list (5 items) >'),
          ),
        ],
      ),
    );
  }
}
