import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/daily_insight.dart';
import 'package:hungrx_app/presentation/pages/home_screen/home_screen.dart';
import 'package:hungrx_app/presentation/pages/home_screen/widget/bottom_navbar.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screen/user_profile_screen.dart';
import 'package:hungrx_app/presentation/widgets/responsive_text.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  int _selectedIndex = 3; // Assuming cart is the 4th item in the bottom nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Order Cart'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 26
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalCalories(),
                  const SizedBox(height: 20),
                  _buildCartItems(),
                  const SizedBox(height: 20),
                  _buildOrderHistory(),
                  const SizedBox(height: 20),
             
                  const SizedBox(height: 100), // Add extra space for the fixed button
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFixedTotalCalorieFooter(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToScreen(index);
        },
      ),
    );
  }
  void _navigateToScreen(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const DailyInsightScreen();
        break;
      case 2:
        screen = const UserProfileScreen();
        break;
      case 3:
        // Already on CartScreen
        return;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Widget _buildTotalCalorieWarning() {
  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: Colors.red.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: const Text(
  //       "you're over recommended calorie for this meal by 240cal 😮",
  //       style: TextStyle(color: Colors.red, fontSize: 12),
  //     ),
  //   );
  // }

  Widget _buildFixedTotalCalorieFooter() {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: AppColors.tileColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text('Total : 1230 cal',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: AppColors.buttonColors,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text('Ate',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _buildTotalCalories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveTextWidget(
          text: '2780 cal',
          fontWeight: FontWeight.bold,
          sizeFactor: 0.07,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Your food order is above the calorie budget',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCartItem('Big Mac', '590cal'),
          _buildCartItem('Double quarter pounder', '758 cal'),
          _buildCartItem('Poori masala', '1230 cal'),
          const Divider(color: Colors.grey),
          _buildTotalCalorieRow(),
          const SizedBox(height: 12),
          _buildAddMoreItemsButton(),
        ],
      ),
    );
  }

  Widget _buildCartItem(String name, String calories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(name, style: const TextStyle(color: Colors.white)),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('1', style: TextStyle(color: Colors.white)),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: () {},
              ),
              SizedBox(
                width: 80,
                child: Text(
                  calories,
                  style: TextStyle(
                    color: calories.contains('758')
                        ? Colors.red
                        : AppColors.buttonColors,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCalorieRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total calorie', style: TextStyle(color: Colors.white)),
        Text('1230 cal', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildAddMoreItemsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.buttonColors),
        ),
      ),
      onPressed: () {
        // Implement add more items functionality
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: AppColors.buttonColors),
          SizedBox(width: 8),
          Text('Add more items',
              style: TextStyle(color: AppColors.buttonColors)),
        ],
      ),
    );
  }

  Widget _buildOrderHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order History',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        _buildOrderHistoryItem(),
        const SizedBox(height: 12),
        _buildOrderHistoryItem(),
      ],
    );
  }

  Widget _buildOrderHistoryItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildOrderHistoryRow('Big Mac', '590 Cal.', '1'),
          _buildOrderHistoryRow('Big Mac', '590 Cal.', '2'),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total items : 5',
                      style: TextStyle(color: Colors.white)),
                  Text('Total calorie : 1200cal',
                      style: TextStyle(color: Colors.white)),
                  
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
                      // Implement view order functionality
                    },
                    child:
                        const Text('View order', style: TextStyle(color: Colors.black)),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistoryRow(String name, String calories, String quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset('assets/images/burger.png', width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white)),
                Text(calories, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text('Nos. $quantity', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Widget _buildTotalCalorieFooter() {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.red.withOpacity(0.2),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: const Text(
  //           "you're over recommended calorie for this meal by 240cal 😮",
  //           style: TextStyle(color: Colors.red, fontSize: 12),
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(vertical: 16),
  //               decoration: const BoxDecoration(
  //                 color: AppColors.buttonColors,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(12),
  //                   bottomLeft: Radius.circular(12),
  //                 ),
  //               ),
  //               child: const Center(
  //                 child: Text('Total : 1230 cal',
  //                     style: TextStyle(color: Colors.black, fontSize: 16)),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(vertical: 16),
  //               decoration: const BoxDecoration(
  //                 color: Colors.black,
  //                 borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(12),
  //                   bottomRight: Radius.circular(12),
  //                 ),
  //               ),
  //               child: const Center(
  //                 child: Text('Ate',
  //                     style: TextStyle(color: Colors.white, fontSize: 16)),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
