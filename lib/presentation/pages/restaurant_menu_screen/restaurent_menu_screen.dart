import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/calorie_calculation_screen/calculation_tracking.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/progress_bar.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  bool _isSearchVisible = false;
   String? expandedCategory;
  String? expandedSubcategory;
  double currentCalories = 1889.0;
  final double dailyCalorieTarget = 2000.0;
  int itemCount = 5;

 void _handleCategoryExpansion(String category, bool isExpanded) {
    setState(() {
      // If expanding, set the new category, if collapsing, clear it
      expandedCategory = isExpanded ? category : null;
      // Reset subcategory whenever category changes
      expandedSubcategory = null;
    });
  }

  // Method to handle subcategory expansion
  void _handleSubcategoryExpansion(String subcategory, bool isExpanded) {
    setState(() {
      expandedSubcategory = isExpanded ? subcategory : null;
    });
  }
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
      _buildMenuCategory('Recommended foods', {
        'Burgers': [
          _buildMenuItem('Big Mac', '590 Cal.', 'assets/images/burger.png', 4.8, context),
          _buildMenuItem('Double Quarter Pounder with Cheese', '740 Cal.', 'assets/images/burger.png', 4.2, context),
        ],
        'Sandwiches': [
          _buildMenuItem('McChicken', '400 Cal.', 'assets/images/burger.png', 4.5, context),
          _buildMenuItem('Filet-O-Fish', '380 Cal.', 'assets/images/burger.png', 4.0, context),
        ],
      }),
      _buildMenuCategory('Breakfast Menu', {
        'Homestyle Breakfasts': [
          _buildMenuItem('Pancakes', '540 Cal.', 'assets/images/piza.png', 4.5, context),
          _buildMenuItem('Egg McMuffin', '300 Cal.', 'assets/images/piza.png', 4.3, context),
        ],
        'Breakfast Sandwiches': [
          _buildMenuItem('Sausage McMuffin', '400 Cal.', 'assets/images/burger.png', 4.4, context),
          _buildMenuItem('Bacon & Egg Biscuit', '420 Cal.', 'assets/images/burger.png', 4.2, context),
        ],
      }),
      _buildMenuCategory('Sides & Snacks', {
        'Hot Sides': [
          _buildMenuItem('Hash Browns', '150 Cal.', 'assets/images/burger.png', 4.6, context),
          _buildMenuItem('French Fries', '320 Cal.', 'assets/images/piza.png', 4.7, context),
        ],
        'Cold Sides': [
          _buildMenuItem('Apple Slices', '15 Cal.', 'assets/images/burger.png', 4.0, context),
          _buildMenuItem('Side Salad', '15 Cal.', 'assets/images/burger.png', 4.2, context),
        ],
      }),
    ],
  );
}


  Widget _buildMenuCategory(String category, Map<String, List<Widget>> subcategories) {
    return ExpansionTile(
      key: Key(category),
      initiallyExpanded: expandedCategory == category,
      onExpansionChanged: (expanded) => _handleCategoryExpansion(category, expanded),
      title: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      backgroundColor: Colors.black,
      collapsedBackgroundColor: Colors.black,
      maintainState: true,
      children: subcategories.entries.map((subcategory) {
        return _buildSubcategory(category, subcategory.key, subcategory.value);
      }).toList(),
    );
  }


  Widget _buildSubcategory(String parentCategory, String subcategoryName, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ExpansionTile(
        key: Key('$parentCategory-$subcategoryName'),
        initiallyExpanded: expandedSubcategory == subcategoryName,
        onExpansionChanged: (expanded) => _handleSubcategoryExpansion(subcategoryName, expanded),
        title: Text(
          subcategoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        backgroundColor: Colors.black,
        collapsedBackgroundColor: Colors.black,
        children: items,
      ),
    );
  }

 Widget _buildMenuItem(String name, String calories, String imagePath, double rating, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SizedBox();
              },
            ),
          );
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
              Text(
                calories,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.buttonColors,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildOrderSummary(BuildContext context) {
    return CalorieSummaryWidget(
        currentCalories: currentCalories,
        dailyCalorieTarget: dailyCalorieTarget,
        itemCount: itemCount,
        onViewOrderPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CalorieCalculationScreen(),
            ),
          );
        },
        buttonColor: AppColors.buttonColors,
        primaryColor: AppColors.primaryColor,
      );
    
  }
}