import 'package:flutter/material.dart';
import 'package:hungrx_app/core/utils/size_utils.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/log_meal_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/restaurant_screen.dart';

class EatScreen extends StatefulWidget {
  const EatScreen({super.key});

  @override
  State<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends State<EatScreen> {
  int selectedIndex = 1; // Set to 1 for 'Eat' tab


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(12.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCalorieBudget(),
                const SizedBox(height: 20),
                _buildOptionsGrid(),
                // const Spacer(),
                _buildEnjoyCalories(),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hi, Warren Daniel',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/dp.png'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'search your food',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCalorieBudget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2317',
          style: TextStyle(
              color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
        ),
        Text(
          'calorie budget per day',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildOptionsGrid() {
    return Row(
      children: [
        Expanded(
            child: _buildOptionCard(
          'Restaurants',
          'Discover Nearby Restaurant Menus That Fit Your Calorie Budget',
          'assets/images/burger.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RestaurantScreen()),
            );
          },
        )),
        const SizedBox(width: 16),
        Expanded(
            child: _buildOptionCard(
          'Home',
          'Log what you eat from home or grocery stores for better calorie management.',
          'assets/images/piza.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogMealScreen()),
            );
          },
        )),
      ],
    );
  }

  Widget _buildOptionCard(
      String title, String subtitle, String imagePath, void Function()? ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnjoyCalories() {
    return Text(
      'Enjoy\nCalories!',
      style: TextStyle(
          color: Colors.grey[800], fontSize: 66, fontWeight: FontWeight.bold),
    );
  }

  // Widget _buildBottomNavBar() {
  //   return BottomNavigationBar(
  //     backgroundColor: Colors.black,
  //     selectedItemColor: Colors.white,
  //     unselectedItemColor: Colors.grey,
  //     type: BottomNavigationBarType.fixed,
  //     items: [
  //       BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
  //       BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Eat'),
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  //       BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'food cart'),
  //     ],
  //   );
  // }
}
